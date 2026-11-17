import { Router } from "express";
import { prisma } from "../config/database.js";
import {
  verifyFirebaseToken,
  type AuthenticatedRequest,
} from "../middlewares/auth.middleware.js";

const router = Router();

// ==========================================
// SERIALIZER — Hapus field sensitif
// ==========================================

function sanitizeUser(user: any) {
  const {
    password_hash,
    firebase_uid,
    deleted_at,
    ...safe
  } = user;

  return {
    ...safe,
    id: safe.id?.toString?.() ?? safe.id,
    created_at: safe.created_at instanceof Date
      ? safe.created_at.toISOString()
      : safe.created_at,
    updated_at: safe.updated_at instanceof Date
      ? safe.updated_at.toISOString()
      : safe.updated_at,
    email_verified_at: safe.email_verified_at instanceof Date
      ? safe.email_verified_at.toISOString()
      : safe.email_verified_at,
    last_login_at: safe.last_login_at instanceof Date
      ? safe.last_login_at.toISOString()
      : safe.last_login_at,
  };
}

function serializeBigInt(value: any): any {
  if (typeof value === "bigint") {
    return value.toString();
  }

  if (value instanceof Date) {
    return value.toISOString();
  }

  if (Array.isArray(value)) {
    return value.map(serializeBigInt);
  }

  if (value !== null && typeof value === "object") {
    return Object.fromEntries(
      Object.entries(value).map(([key, v]) => [key, serializeBigInt(v)])
    );
  }

  return value;
}

// ==========================================
// POST /api/v1/auth/sync
// Sinkronisasi Firebase UID saat login pertama.
// Jika user belum ada di MySQL → buat baru.
// Jika sudah ada → update last_login_at.
// ==========================================

router.post(
  "/auth/sync",
  verifyFirebaseToken,
  async (req: AuthenticatedRequest, res) => {
    try {
      const firebaseUid = req.user!.uid;
      const firebaseEmail = req.user!.email;
      const firebaseName = req.user!.full_name;

      let dbUser = await prisma.users.findUnique({
        where: { firebase_uid: firebaseUid },
        include: {
          user_roles_user_roles_user_idTousers: {
            include: { roles: true },
          },
        },
      });

      if (!dbUser) {
        // Coba cari berdasarkan email (misalnya user sudah ada tapi belum link Firebase)
        const existingByEmail = await prisma.users.findUnique({
          where: { email: firebaseEmail },
        });

        if (existingByEmail) {
          // Link Firebase UID ke akun yang sudah ada
          dbUser = await prisma.users.update({
            where: { email: firebaseEmail },
            data: {
              firebase_uid: firebaseUid,
              last_login_at: new Date(),
            },
            include: {
              user_roles_user_roles_user_idTousers: {
                include: { roles: true },
              },
            },
          });
        } else {
          // Buat akun baru
          // Cari role "user" sebagai default
          const userRole = await prisma.roles.findFirst({
            where: { role_name: "user" },
          });

          dbUser = await prisma.users.create({
            data: {
              firebase_uid: firebaseUid,
              email: firebaseEmail,
              full_name: firebaseName || firebaseEmail.split("@")[0],
              password_hash: "", // Tidak digunakan karena auth lewat Firebase
              is_active: true,
              last_login_at: new Date(),
              ...(userRole
                ? {
                    user_roles_user_roles_user_idTousers: {
                      create: {
                        role_id: userRole.id,
                      },
                    },
                  }
                : {}),
            },
            include: {
              user_roles_user_roles_user_idTousers: {
                include: { roles: true },
              },
            },
          });

          // Catat aktivitas registrasi
          await prisma.activity_logs.create({
            data: {
              ip_address: req.ip || null,
              user_agent: req.get("user-agent") || null,
              user_id: dbUser.id,
              action: "register",
              entity_type: "user",
              entity_id: dbUser.id,
              new_values: {
                email: dbUser.email,
                full_name: dbUser.full_name,
              },
            },
          });
        }
      } else {
        // Update last_login_at
        await prisma.users.update({
          where: { id: dbUser.id },
          data: { last_login_at: new Date() },
        });

        // Catat aktivitas login
        await prisma.activity_logs.create({
          data: {
            ip_address: req.ip || null,
            user_agent: req.get("user-agent") || null,
            user_id: dbUser.id,
            action: "login",
            entity_type: "user",
            entity_id: dbUser.id,
            new_values: { method: "firebase" },
          },
        });
      }

      const roles =
        dbUser.user_roles_user_roles_user_idTousers.map(
          (ur) => ur.roles.role_name
        );

      return res.status(200).json({
        success: true,
        message: "Sinkronisasi akun berhasil",
        data: {
          ...sanitizeUser(dbUser),
          roles,
        },
      });
    } catch (error) {
      console.error("AUTH SYNC ERROR:", error);

      return res.status(500).json({
        success: false,
        message: "Gagal menyinkronisasi akun",
      });
    }
  }
);

// ==========================================
// GET /api/v1/me
// Profil user yang sedang login
// ==========================================

router.get(
  "/me",
  verifyFirebaseToken,
  async (req: AuthenticatedRequest, res) => {
    try {
      const userId = BigInt(req.user!.id);

      const dbUser = await prisma.users.findUnique({
        where: { id: userId },
        include: {
          user_roles_user_roles_user_idTousers: {
            include: { roles: true },
          },
          user_addresses: {
            orderBy: { is_default: "desc" },
          },
        },
      });

      if (!dbUser || !dbUser.is_active || dbUser.deleted_at !== null) {
        return res.status(404).json({
          success: false,
          message: "Akun tidak ditemukan atau tidak aktif",
        });
      }

      const roles =
        dbUser.user_roles_user_roles_user_idTousers.map(
          (ur) => ur.roles.role_name
        );

      return res.status(200).json({
        success: true,
        message: "Profil berhasil diambil",
        data: {
          ...sanitizeUser(dbUser),
          roles,
          addresses: serializeBigInt(dbUser.user_addresses),
        },
      });
    } catch (error) {
      console.error("GET ME ERROR:", error);

      return res.status(500).json({
        success: false,
        message: "Gagal mengambil profil",
      });
    }
  }
);

// ==========================================
// PATCH /api/v1/me
// Update profil sendiri
// ==========================================

router.patch(
  "/me",
  verifyFirebaseToken,
  async (req: AuthenticatedRequest, res) => {
    try {
      const userId = BigInt(req.user!.id);
      const body = req.body;

      if (
        !body ||
        typeof body !== "object" ||
        Array.isArray(body)
      ) {
        return res.status(400).json({
          success: false,
          message: "Format body tidak valid",
        });
      }

      const updateData: Record<string, any> = {};

      // full_name
      if (body.full_name !== undefined) {
        if (
          typeof body.full_name !== "string" ||
          body.full_name.trim().length === 0 ||
          body.full_name.trim().length > 100
        ) {
          return res.status(400).json({
            success: false,
            message: "Nama lengkap harus diisi dan maksimal 100 karakter",
          });
        }

        updateData.full_name = body.full_name.trim();
      }

      // phone
      if (body.phone !== undefined) {
        if (
          body.phone !== null &&
          (
            typeof body.phone !== "string" ||
            body.phone.trim().length > 20 ||
            !/^[0-9+\-\s()]+$/.test(body.phone.trim())
          )
        ) {
          return res.status(400).json({
            success: false,
            message: "Nomor telepon tidak valid (maksimal 20 karakter)",
          });
        }

        updateData.phone = body.phone === null
          ? null
          : body.phone.trim() || null;
      }

      // profile_photo
      if (body.profile_photo !== undefined) {
        if (
          body.profile_photo !== null &&
          (
            typeof body.profile_photo !== "string" ||
            body.profile_photo.trim().length > 500
          )
        ) {
          return res.status(400).json({
            success: false,
            message: "URL foto profil tidak valid (maksimal 500 karakter)",
          });
        }

        if (body.profile_photo !== null && body.profile_photo !== "") {
          try {
            const parsed = new URL(body.profile_photo.trim());

            if (!["http:", "https:"].includes(parsed.protocol)) {
              throw new Error("Protocol tidak valid");
            }
          } catch {
            return res.status(400).json({
              success: false,
              message: "Format URL foto profil tidak valid",
            });
          }
        }

        updateData.profile_photo = body.profile_photo === null
          ? null
          : body.profile_photo.trim() || null;
      }

      if (Object.keys(updateData).length === 0) {
        return res.status(400).json({
          success: false,
          message: "Tidak ada data yang diubah",
        });
      }

      updateData.updated_at = new Date();

      // Ambil data lama untuk activity log
      const oldUser = await prisma.users.findUnique({
        where: { id: userId },
        select: {
          full_name: true,
          phone: true,
          profile_photo: true,
        },
      });

      if (!oldUser) {
        return res.status(404).json({
          success: false,
          message: "Akun tidak ditemukan",
        });
      }

      const updatedUser = await prisma.$transaction(async (tx) => {
        const updated = await tx.users.update({
          where: { id: userId },
          data: updateData,
          include: {
            user_roles_user_roles_user_idTousers: {
              include: { roles: true },
            },
          },
        });

        // Catat perubahan profil
        const changedFields = Object.keys(updateData).filter(
          (k) => k !== "updated_at"
        );

        await tx.activity_logs.create({
          data: {
            ip_address: req.ip || null,
            user_agent: req.get("user-agent") || null,
            user_id: userId,
            action: "update",
            entity_type: "user",
            entity_id: userId,
            old_values: Object.fromEntries(
              changedFields.map((f) => [
                f,
                (oldUser as any)[f] ?? null,
              ])
            ),
            new_values: Object.fromEntries(
              changedFields.map((f) => [
                f,
                updateData[f] ?? null,
              ])
            ),
          },
        });

        return updated;
      });

      const roles =
        updatedUser.user_roles_user_roles_user_idTousers.map(
          (ur) => ur.roles.role_name
        );

      return res.status(200).json({
        success: true,
        message: "Profil berhasil diperbarui",
        data: {
          ...sanitizeUser(updatedUser),
          roles,
        },
      });
    } catch (error) {
      console.error("PATCH ME ERROR:", error);

      return res.status(500).json({
        success: false,
        message: "Gagal memperbarui profil",
      });
    }
  }
);

export default router;
