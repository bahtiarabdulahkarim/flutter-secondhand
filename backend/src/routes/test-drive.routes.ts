import { Router, type Request } from "express";
import { prisma } from "../config/database.js";
import {
  verifyFirebaseToken,
  authorizeRoles,
  type AuthenticatedRequest,
} from "../middlewares/auth.middleware.js";

const router = Router();

// ==========================================
// AUDIT REQUEST HELPER
// ==========================================

function getRequestAudit(req: Request) {
  return {
    ip_address: req.ip || null,
    user_agent: req.get("user-agent") || null,
  };
}

// ==========================================
// HELPER
// ==========================================

const allowedStatuses = [
  "pending",
  "approved",
  "rejected",
  "completed",
  "cancelled",
] as const;

type TestDriveStatus = (typeof allowedStatuses)[number];

class InputValidationError extends Error {
  constructor(message: string) {
    super(message);
    this.name = "InputValidationError";
  }
}

function parseId(value: unknown): bigint | null {
  try {
    if (
      value === undefined ||
      value === null ||
      !/^\d+$/.test(String(value))
    ) {
      return null;
    }

    const id = BigInt(String(value));
    return id > 0n ? id : null;
  } catch {
    return null;
  }
}

function parseDate(value: unknown): Date | null {
  if (
    typeof value !== "string" ||
    !/^\d{4}-\d{2}-\d{2}$/.test(value)
  ) {
    return null;
  }

  const date = new Date(`${value}T00:00:00.000Z`);

  if (
    Number.isNaN(date.getTime()) ||
    date.toISOString().slice(0, 10) !== value
  ) {
    return null;
  }

  return date;
}

function parseTime(value: unknown): Date | null {
  if (
    typeof value !== "string" ||
    !/^([01]\d|2[0-3]):[0-5]\d(:[0-5]\d)?$/.test(value)
  ) {
    return null;
  }

  const normalized = value.length === 5 ? `${value}:00` : value;

  return new Date(`1970-01-01T${normalized}.000Z`);
}

function timeToMinutes(value: string): number {
  const [hours, minutes] = value.split(":").map(Number);
  return hours * 60 + minutes;
}


function serialize(value: any): any {
  if (typeof value === "bigint") {
    return value.toString();
  }

  if (value instanceof Date) {
    return value.toISOString();
  }

  // Mengubah Prisma Decimal menjadi string
  if (
    value &&
    typeof value === "object" &&
    typeof value.toFixed === "function"
  ) {
    return value.toString();
  }

  if (Array.isArray(value)) {
    return value.map(serialize);
  }

  if (value && typeof value === "object") {
    return Object.fromEntries(
      Object.entries(value).map(([key, item]) => [
        key,
        serialize(item),
      ])
    );
  }

  return value;
}


function handleError(res: any, error: any) {
  if (error instanceof InputValidationError) {
    return res.status(400).json({
      success: false,
      message: error.message,
    });
  }

  // Menangani konflik transaksi Prisma (Serializable)
  if (error?.code === "P2034") {
    return res.status(409).json({
      success: false,
      message:
        "Terjadi konflik transaksi. Silakan coba proses kembali.",
    });
  }

  console.error("TEST DRIVE ERROR:", error);

  return res.status(500).json({
    success: false,
    message: "Terjadi kesalahan pada server",
  });
}


const testDriveInclude = {
  users_test_drives_user_idTousers: {
    select: {
      id: true,
      full_name: true,
      email: true,
      phone: true,
    },
  },
  users_test_drives_assigned_admin_idTousers: {
    select: {
      id: true,
      full_name: true,
      email: true,
    },
  },
  users_test_drives_approved_byTousers: {
    select: {
      id: true,
      full_name: true,
      email: true,
    },
  },
  vehicles: {
    select: {
      id: true,
      vehicle_code: true,
      title: true,
      year: true,
      price: true,
      status: true,
    },
  },
};

// ==========================================
// GET ALL TEST DRIVES
// GET /api/v1/test-drives
// Admin/Owner: semua data, bisa filter user_id
// User: hanya miliknya
// ==========================================

router.get(
  "/test-drives",
  verifyFirebaseToken,
  async (req: AuthenticatedRequest, res) => {
    try {
      const isPrivileged =
        req.user?.roles.includes("admin") === true ||
        req.user?.roles.includes("owner") === true;

      const page = Math.max(Number(req.query.page) || 1, 1);
      const limit = Math.min(
        Math.max(Number(req.query.limit) || 10, 1),
        100
      );

      const where: any = {};

      // User hanya bisa melihat test drive miliknya
      if (!isPrivileged) {
        where.user_id = BigInt(req.user!.id);
      }

      if (req.query.status) {
        if (
          !allowedStatuses.includes(
            req.query.status as TestDriveStatus
          )
        ) {
          throw new InputValidationError("Status tidak valid");
        }

        where.status = req.query.status;
      }

      // Filter user_id hanya untuk admin/owner
      if (req.query.user_id) {
        if (!isPrivileged) {
          throw new InputValidationError(
            "Kamu tidak memiliki izin menggunakan filter user_id"
          );
        }

        const userId = parseId(req.query.user_id);

        if (!userId) {
          throw new InputValidationError("User ID tidak valid");
        }

        where.user_id = userId;
      }

      if (req.query.vehicle_id) {
        const vehicleId = parseId(req.query.vehicle_id);

        if (!vehicleId) {
          throw new InputValidationError("Vehicle ID tidak valid");
        }

        where.vehicle_id = vehicleId;
      }

      if (req.query.scheduled_date) {
        const date = parseDate(req.query.scheduled_date);

        if (!date) {
          throw new InputValidationError(
            "Format tanggal harus YYYY-MM-DD"
          );
        }

        where.scheduled_date = date;
      }

      const [data, total] = await prisma.$transaction([
        prisma.test_drives.findMany({
          where,
          include: testDriveInclude,
          orderBy: { created_at: "desc" },
          skip: (page - 1) * limit,
          take: limit,
        }),
        prisma.test_drives.count({ where }),
      ]);

      return res.json({
        success: true,
        message: "Daftar test drive berhasil diambil",
        data: serialize(data),
        pagination: {
          page,
          limit,
          total,
          total_pages: Math.ceil(total / limit),
        },
      });
    } catch (error) {
      return handleError(res, error);
    }
  }
);

// ==========================================
// GET TEST DRIVE DETAIL
// GET /api/v1/test-drives/:id
// User: hanya miliknya; Admin/Owner: semua
// ==========================================

router.get(
  "/test-drives/:id",
  verifyFirebaseToken,
  async (req: AuthenticatedRequest, res) => {
    try {
      const id = parseId(req.params.id);

      if (!id) {
        throw new InputValidationError("ID test drive tidak valid");
      }

      const isPrivileged =
        req.user?.roles.includes("admin") === true ||
        req.user?.roles.includes("owner") === true;

      const data = await prisma.test_drives.findUnique({
        where: { id },
        include: {
          ...testDriveInclude,
          test_drive_status_history: {
            include: {
              users: {
                select: {
                  id: true,
                  full_name: true,
                  email: true,
                },
              },
            },
            orderBy: { created_at: "asc" },
          },
        },
      });

      if (!data) {
        return res.status(404).json({
          success: false,
          message: "Data test drive tidak ditemukan",
        });
      }

      // User hanya boleh melihat test drive miliknya
      if (
        !isPrivileged &&
        data.user_id.toString() !== req.user!.id
      ) {
        return res.status(404).json({
          success: false,
          message: "Data test drive tidak ditemukan",
        });
      }

      return res.json({
        success: true,
        message: "Detail test drive berhasil diambil",
        data: serialize(data),
      });
    } catch (error) {
      return handleError(res, error);
    }
  }
);

// ==========================================
// CREATE TEST DRIVE
// POST /api/v1/test-drives
// User: booking untuk dirinya sendiri
// Admin/Owner: bisa booking atas nama customer lain
// ==========================================

router.post(
  "/test-drives",
  verifyFirebaseToken,
  async (req: AuthenticatedRequest, res) => {
    try {
      const isPrivileged =
        req.user?.roles.includes("admin") === true ||
        req.user?.roles.includes("owner") === true;

      const actorId = BigInt(req.user!.id);

      // User otomatis menjadi pemesan, Admin/Owner bisa memilih customer
      let userId: bigint;

      if (isPrivileged && req.body.user_id !== undefined) {
        const parsedUserId = parseId(req.body.user_id);

        if (!parsedUserId) {
          throw new InputValidationError("User ID tidak valid");
        }

        userId = parsedUserId;
      } else {
        // User biasa: ID diambil dari token, bukan dari body
        userId = actorId;
      }

      const {
        vehicle_id,
        scheduled_date,
        start_time,
        end_time,
        customer_notes,
      } = req.body;

      const vehicleId = parseId(vehicle_id);
      const date = parseDate(scheduled_date);
      const start = parseTime(start_time);
      const end = parseTime(end_time);

      if (!vehicleId) {
        throw new InputValidationError("Vehicle ID tidak valid");
      }

      if (!date) {
        throw new InputValidationError(
          "Tanggal harus menggunakan format YYYY-MM-DD"
        );
      }

      if (!start || !end) {
        throw new InputValidationError(
          "Jam harus menggunakan format HH:mm atau HH:mm:ss"
        );
      }

      if (
        timeToMinutes(String(start_time).slice(0, 5)) >=
        timeToMinutes(String(end_time).slice(0, 5))
      ) {
        throw new InputValidationError(
          "Jam selesai harus lebih besar dari jam mulai"
        );
      }

      // Pastikan tanggal tidak di masa lalu
      const today = new Date();
      today.setUTCHours(0, 0, 0, 0);

      if (date < today) {
        throw new InputValidationError(
          "Tanggal test drive tidak boleh di masa lalu"
        );
      }

      const user = await prisma.users.findFirst({
        where: {
          id: userId,
          is_active: true,
          deleted_at: null,
        },
      });

      if (!user) {
        throw new InputValidationError(
          "Customer tidak ditemukan atau tidak aktif"
        );
      }

      const vehicle = await prisma.vehicles.findFirst({
        where: {
          id: vehicleId,
          status: "available",
          deleted_at: null,
        },
      });

      if (!vehicle) {
        throw new InputValidationError(
          "Kendaraan tidak ditemukan atau tidak tersedia"
        );
      }

      const bookingCode =
        `TD-${Date.now()}-${Math.floor(Math.random() * 1000)}`;

      const created = await prisma.$transaction(async (tx) => {
        // Cek konflik jadwal saat membuat booking
        const conflict = await tx.test_drives.findFirst({
          where: {
            vehicle_id: vehicleId,
            scheduled_date: date,
            status: { in: ["pending", "approved"] },
            start_time: { lt: end },
            end_time: { gt: start },
          },
        });

        if (conflict) {
          throw new InputValidationError(
            "Slot jadwal sudah dipesan. Pilih waktu yang berbeda."
          );
        }

        const booking = await tx.test_drives.create({
          data: {
            booking_code: bookingCode,
            user_id: userId,
            vehicle_id: vehicleId,
            scheduled_date: date,
            start_time: start,
            end_time: end,
            status: "pending",
            customer_notes: customer_notes?.trim() || null,
          },
        });

        await tx.test_drive_status_history.create({
          data: {
            test_drive_id: booking.id,
            old_status: null,
            new_status: "pending",
            changed_by: actorId,
            notes: isPrivileged
              ? "Booking dibuat oleh admin atas nama customer"
              : "Customer mengajukan jadwal test drive",
          },
        });

        await tx.activity_logs.create({
          data: {
            ...getRequestAudit(req),
            user_id: actorId,
            action: "create",
            entity_type: "test_drive",
            entity_id: booking.id,
            old_values: undefined,
            new_values: {
              booking_code: booking.booking_code,
              vehicle_id: vehicleId.toString(),
              user_id: userId.toString(),
              scheduled_date,
              start_time,
              end_time,
              status: "pending",
            },
          },
        });

        return booking;
      });

      return res.status(201).json({
        success: true,
        message: "Pengajuan test drive berhasil dibuat",
        data: serialize(created),
      });
    } catch (error) {
      return handleError(res, error);
    }
  }
);

// ==========================================
// UPDATE TEST DRIVE STATUS
// PATCH /api/v1/test-drives/:id/status
// ADMIN / OWNER only
// ==========================================

router.patch(
  "/test-drives/:id/status",
  verifyFirebaseToken,
  authorizeRoles("admin", "owner"),
  async (req: AuthenticatedRequest, res) => {
    try {
      const id = parseId(req.params.id);
      const { status, admin_notes } = req.body;

      // Aktor diambil dari token, bukan dari body
      const actorId = BigInt(req.user!.id);

      if (!id) {
        throw new InputValidationError("ID test drive tidak valid");
      }

      if (!allowedStatuses.includes(status)) {
        throw new InputValidationError("Status baru tidak valid");
      }

      const updated = await prisma.$transaction(
        async (tx) => {
          const booking = await tx.test_drives.findUnique({
            where: { id },
          });

          if (!booking) {
            throw new InputValidationError(
              "Data test drive tidak ditemukan"
            );
          }

          const transitions: Record<string, string[]> = {
            pending: ["approved", "rejected", "cancelled"],
            approved: ["completed", "cancelled"],
            rejected: [],
            completed: [],
            cancelled: [],
          };

          if (!transitions[booking.status].includes(status)) {
            throw new InputValidationError(
              `Perubahan status dari ${booking.status} ke ${status} tidak diperbolehkan`
            );
          }

          // Cek bentrok hanya saat pengajuan disetujui.
          if (status === "approved") {
            const conflict = await tx.test_drives.findFirst({
              where: {
                id: { not: id },
                vehicle_id: booking.vehicle_id,
                scheduled_date: booking.scheduled_date,
                status: "approved",
                start_time: { lt: booking.end_time },
                end_time: { gt: booking.start_time },
              },
            });

            if (conflict) {
              throw new InputValidationError(
                "Jadwal berbenturan dengan test drive lain yang sudah disetujui"
              );
            }
          }

          const now = new Date();

          const result = await tx.test_drives.update({
            where: { id },
            data: {
              status,
              admin_notes:
                admin_notes !== undefined
                  ? admin_notes?.trim() || null
                  : undefined,
              ...(status === "approved"
                ? {
                    approved_by: actorId,
                    approved_at: now,
                  }
                : {}),
              updated_at: now,
            },
          });

          await tx.test_drive_status_history.create({
            data: {
              test_drive_id: id,
              old_status: booking.status,
              new_status: status,
              changed_by: actorId,
              notes: admin_notes?.trim() || null,
            },
          });

          await tx.activity_logs.create({
            data: {
              ...getRequestAudit(req),
              user_id: actorId,
              action: "update",
              entity_type: "test_drive",
              entity_id: id,
              old_values: {
                status: booking.status,
              },
              new_values: {
                status,
                admin_notes: admin_notes?.trim() || null,
              },
            },
          });

          return result;
        },
        {
          isolationLevel: "Serializable",
        }
      );

      return res.json({
        success: true,
        message: "Status test drive berhasil diperbarui",
        data: serialize(updated),
      });
    } catch (error) {
      return handleError(res, error);
    }
  }
);

// ==========================================
// ASSIGN ADMIN
// PATCH /api/v1/test-drives/:id/assign
// ADMIN / OWNER only
// ==========================================

router.patch(
  "/test-drives/:id/assign",
  verifyFirebaseToken,
  authorizeRoles("admin", "owner"),
  async (req: AuthenticatedRequest, res) => {
    try {
      const id = parseId(req.params.id);
      const assignedAdminId = parseId(req.body.assigned_admin_id);

      // Aktor diambil dari token
      const actorId = BigInt(req.user!.id);

      if (!id) {
        throw new InputValidationError("ID test drive tidak valid");
      }

      if (!assignedAdminId) {
        throw new InputValidationError("ID admin yang ditugaskan wajib diisi");
      }

      const admin = await prisma.users.findFirst({
        where: {
          id: assignedAdminId,
          is_active: true,
          deleted_at: null,
        },
      });

      if (!admin) {
        throw new InputValidationError(
          "Admin tidak ditemukan atau tidak aktif"
        );
      }

      const updated = await prisma.$transaction(async (tx) => {
        const booking = await tx.test_drives.findUnique({
          where: { id },
        });

        if (!booking) {
          throw new InputValidationError(
            "Data test drive tidak ditemukan"
          );
        }

        const result = await tx.test_drives.update({
          where: { id },
          data: {
            assigned_admin_id: assignedAdminId,
            updated_at: new Date(),
          },
        });

        await tx.activity_logs.create({
          data: {
            ...getRequestAudit(req),
            user_id: actorId,
            action: "update",
            entity_type: "test_drive",
            entity_id: id,
            old_values: {
              assigned_admin_id:
                booking.assigned_admin_id?.toString() ?? null,
            },
            new_values: {
              assigned_admin_id: assignedAdminId.toString(),
            },
          },
        });

        return result;
      });

      return res.json({
        success: true,
        message: "Admin berhasil ditugaskan",
        data: serialize(updated),
      });
    } catch (error) {
      return handleError(res, error);
    }
  }
);

export default router;
