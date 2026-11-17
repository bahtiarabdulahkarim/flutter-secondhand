
import { firebaseAuth } from "../config/firebase.js";
import { prisma } from "../config/database.js";
import type { Request, Response, NextFunction } from "express";

export interface AuthenticatedRequest extends Request {
  user?: {
    uid: string;
    id: string;
    email: string;
    full_name: string;
    roles: string[];
  };
}

export async function verifyFirebaseToken(
  req: AuthenticatedRequest,
  res: Response,
  next: NextFunction
) {
  try {
    const authHeader = req.headers.authorization;

    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      return res.status(401).json({
        success: false,
        message: "Token autentikasi tidak ditemukan",
      });
    }

    const token = authHeader.split(" ")[1];

    if (!token) {
      return res.status(401).json({
        success: false,
        message: "Token autentikasi tidak valid",
      });
    }

    // 1. Verifikasi Firebase ID Token
    let decodedToken;

    try {
      decodedToken = await firebaseAuth.verifyIdToken(token);
    } catch {
      return res.status(401).json({
        success: false,
        message: "Token autentikasi tidak valid atau kedaluwarsa",
      });
    }

    // 2. Cari akun berdasarkan Firebase UID
    const dbUser = await prisma.users.findUnique({
      where: {
        firebase_uid: decodedToken.uid,
      },
include: {
  user_roles_user_roles_user_idTousers: {
    include: {
      roles: true,
    },
  },
},
    });

    if (!dbUser) {
      return res.status(403).json({
        success: false,
        message: "Akun Firebase belum terhubung dengan akun SecondHand",
      });
    }

    // 3. Periksa status akun
    if (!dbUser.is_active || dbUser.deleted_at !== null) {
      return res.status(403).json({
        success: false,
        message: "Akun tidak aktif atau telah dihapus",
      });
    }

    // 4. Ambil role dari MySQL
    const roles =
  dbUser.user_roles_user_roles_user_idTousers.map(
    (item) => item.roles.role_name
  );

    // 5. Simpan identitas pengguna untuk digunakan route
    req.user = {
      uid: decodedToken.uid,
      id: dbUser.id.toString(),
      email: dbUser.email,
      full_name: dbUser.full_name,
      roles,
    };

    next();
  } catch (error) {
    console.error("AUTH MIDDLEWARE ERROR:", error);

    return res.status(500).json({
      success: false,
      message: "Terjadi kesalahan saat memverifikasi akun",
    });
  }
}

// Middleware untuk membatasi akses berdasarkan role
export function authorizeRoles(...allowedRoles: string[]) {
  return (
    req: AuthenticatedRequest,
    res: Response,
    next: NextFunction
  ) => {
    // Pastikan pengguna sudah terautentikasi
    if (!req.user) {
      return res.status(401).json({
        success: false,
        message: "Pengguna belum terautentikasi",
      });
    }

    // Periksa apakah pengguna memiliki role yang diizinkan
    const hasRole = req.user.roles.some((role) =>
      allowedRoles.includes(role)
    );

    if (!hasRole) {
      return res.status(403).json({
        success: false,
        message: "Kamu tidak memiliki izin untuk mengakses resource ini",
      });
    }

    next();
  };
}