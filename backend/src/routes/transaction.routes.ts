
import { Router, type Request } from "express";
import { prisma } from "../config/database.js";
import {
  verifyFirebaseToken,
  authorizeRoles,
  type AuthenticatedRequest,
} from "../middlewares/auth.middleware.js";

const router = Router();

const MAX_BIGINT = 18446744073709551615n;
const MAX_MONEY = 9999999999999.99;

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
// CUSTOM ERRORS
// ==========================================

class InputValidationError extends Error {
  constructor(message: string) {
    super(message);
    this.name = "InputValidationError";
  }
}

// ==========================================
// HELPER VALIDASI ID
// ==========================================

function parseId(value: unknown, message = "ID tidak valid"): bigint {
  if (
    (typeof value !== "string" && typeof value !== "number" && typeof value !== "bigint") ||
    !/^[1-9]\d*$/.test(String(value))
  ) {
    throw new InputValidationError(message);
  }

  const parsed = BigInt(value);

  if (parsed > MAX_BIGINT) {
    throw new InputValidationError(message);
  }

  return parsed;
}

// ==========================================
// SERIALIZER BIGINT
// ==========================================

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
    const result: any = {};

    for (const key in value) {
      result[key] = serializeBigInt(value[key]);
    }

    return result;
  }

  return value;
}

// ==========================================
// MONEY HELPER
// ==========================================

function money(value: any): number {
  if (
    value === null ||
    value === undefined ||
    value === "" ||
    (typeof value !== "number" && typeof value !== "string")
  ) {
    throw new InputValidationError("Nominal tidak valid");
  }

  const result = Number(value);

  if (
    !Number.isFinite(result) ||
    result < 0 ||
    result > MAX_MONEY
  ) {
    throw new InputValidationError("Nominal tidak valid");
  }

  const rounded = Math.round(result * 100) / 100;

  if (rounded > MAX_MONEY) {
    throw new InputValidationError("Nominal tidak valid");
  }

  return rounded;
}

function formatMoney(value: number): string {
  return value.toFixed(2);
}

// ==========================================
// ROLE HELPER
// ==========================================

function isAdminOrOwner(req: AuthenticatedRequest): boolean {
  return (
    req.user?.roles.includes("admin") === true ||
    req.user?.roles.includes("owner") === true
  );
}

function getActorId(req: AuthenticatedRequest): bigint {
  return parseId(req.user?.id, "ID pengguna tidak valid");
}

// ==========================================
// GET ALL TRANSACTIONS
// ==========================================

router.get(
  "/transactions",
  verifyFirebaseToken,
  async (req: AuthenticatedRequest, res) => {
    try {
      const isPrivileged = isAdminOrOwner(req);
      const isUser = req.user?.roles.includes("user") === true;

      if (!isPrivileged && !isUser) {
        return res.status(403).json({
          success: false,
          message: "Kamu tidak memiliki izin untuk melihat transaksi",
        });
      }

      const pageInput =
        req.query.page === undefined ? "1" : req.query.page;

      const limitInput =
        req.query.limit === undefined ? "10" : req.query.limit;

      if (
        typeof pageInput !== "string" ||
        !/^[1-9]\d*$/.test(pageInput) ||
        !Number.isSafeInteger(Number(pageInput))
      ) {
        throw new InputValidationError(
          "Parameter page harus berupa bilangan bulat positif"
        );
      }

      if (
        typeof limitInput !== "string" ||
        !/^[1-9]\d*$/.test(limitInput) ||
        !Number.isSafeInteger(Number(limitInput)) ||
        Number(limitInput) > 100
      ) {
        throw new InputValidationError(
          "Parameter limit harus berupa bilangan bulat antara 1 sampai 100"
        );
      }

      const page = Number(pageInput);
      const limit = Number(limitInput);
      const skip = (page - 1) * limit;

      if (!Number.isSafeInteger(skip)) {
        throw new InputValidationError(
          "Parameter page terlalu besar"
        );
      }

      const where: any = {};

      // User hanya dapat melihat transaksi miliknya.
      if (isUser && !isPrivileged) {
        where.customer_id = getActorId(req);
      }

      // Filter customer_id hanya untuk admin dan owner.
      if (req.query.customer_id !== undefined) {
        if (!isPrivileged) {
          throw new InputValidationError(
            "Kamu tidak memiliki izin menggunakan filter customer_id"
          );
        }

        where.customer_id = parseId(
          req.query.customer_id,
          "Customer ID tidak valid"
        );
      }

      if (req.query.status !== undefined) {
        if (typeof req.query.status !== "string") {
          throw new InputValidationError(
            "Status transaksi tidak valid"
          );
        }

        const allowedStatus = [
          "pending",
          "processing",
          "completed",
          "cancelled",
        ];

        if (!allowedStatus.includes(req.query.status)) {
          throw new InputValidationError(
            "Status transaksi tidak valid"
          );
        }

        where.status = req.query.status;
      }

      const [transactions, total] = await Promise.all([
        prisma.transactions.findMany({
          where,
          skip,
          take: limit,
          orderBy: {
            created_at: "desc",
          },
          include: {
            transaction_items: true,
            transaction_payments: true,
          },
        }),

        prisma.transactions.count({ where }),
      ]);

      return res.json({
        success: true,
        message: "Data transaksi berhasil diambil",
        data: serializeBigInt(transactions),
        pagination: {
          page,
          limit,
          total,
          total_pages: Math.ceil(total / limit),
        },
      });
    } catch (error: any) {
      if (error instanceof InputValidationError) {
        return res.status(400).json({
          success: false,
          message: error.message,
        });
      }

      console.error("GET TRANSACTIONS ERROR:", error);

      return res.status(500).json({
        success: false,
        message: "Gagal mengambil data transaksi",
      });
    }
  }
);

// ==========================================
// GET TRANSACTION DETAIL
// ==========================================

router.get(
  "/transactions/:id",
  verifyFirebaseToken,
  async (req: AuthenticatedRequest, res) => {
    try {
      const transactionId = parseId(
        req.params.id,
        "ID transaksi tidak valid"
      );

      const transaction = await prisma.transactions.findUnique({
        where: {
          id: transactionId,
        },
        include: {
          transaction_items: {
            include: {
              vehicles: {
                select: {
                  id: true,
                  vehicle_code: true,
                  title: true,
                  status: true,
                },
              },
            },
          },
          transaction_payments: true,
          transaction_documents: true,
          transaction_status_history: true,
          users_transactions_customer_idTousers: {
            select: {
              id: true,
              full_name: true,
              email: true,
              phone: true,
            },
          },
          users_transactions_handled_byTousers: {
            select: {
              id: true,
              full_name: true,
              email: true,
            },
          },
        },
      });

      if (!transaction) {
        return res.status(404).json({
          success: false,
          message: "Transaksi tidak ditemukan",
        });
      }

      const isPrivileged = isAdminOrOwner(req);
      const isUser = req.user?.roles.includes("user") === true;

      if (!isPrivileged && !isUser) {
        return res.status(403).json({
          success: false,
          message: "Kamu tidak memiliki izin melihat transaksi",
        });
      }

      // User hanya boleh melihat transaksi miliknya sendiri.
      if (
        isUser &&
        !isPrivileged &&
        transaction.customer_id.toString() !== req.user?.id
      ) {
        return res.status(404).json({
          success: false,
          message: "Transaksi tidak ditemukan",
        });
      }

      return res.json({
        success: true,
        message: "Detail transaksi berhasil diambil",
        data: serializeBigInt(transaction),
      });
    } catch (error: any) {
      if (error instanceof InputValidationError) {
        return res.status(400).json({
          success: false,
          message: error.message,
        });
      }

      console.error("GET TRANSACTION DETAIL ERROR:", error);

      return res.status(500).json({
        success: false,
        message: "Gagal mengambil detail transaksi",
      });
    }
  }
);

// ==========================================
// CREATE TRANSACTION
// ==========================================

router.post(
  "/transactions",
  verifyFirebaseToken,
  async (req: AuthenticatedRequest, res) => {
    try {
      const isPrivileged = isAdminOrOwner(req);
      const isUser = req.user?.roles.includes("user") === true;

      if (!isPrivileged && !isUser) {
        return res.status(403).json({
          success: false,
          message: "Kamu tidak memiliki izin membuat transaksi",
        });
      }

      const {
        customer_id,
        handled_by,
        items,
        discount = 0,
        notes,
      } = req.body;

      const actorId = getActorId(req);

      // User otomatis menjadi customer transaksi.
      // Admin dan owner boleh memilih customer.
      const customerId = isPrivileged
        ? parseId(customer_id, "Customer ID wajib diisi")
        : actorId;

      // User tidak dapat menentukan handled_by.
      // Admin dan owner dapat menentukan petugas.
      const handlerId = isPrivileged
        ? (
            handled_by !== undefined && handled_by !== null
              ? parseId(handled_by, "Handled by tidak valid")
              : actorId
          )
        : null;

      if (!Array.isArray(items) || items.length === 0) {
        throw new InputValidationError(
          "Minimal harus ada satu kendaraan dalam transaksi"
        );
      }

      if (items.length > 50) {
        throw new InputValidationError(
          "Maksimal 50 kendaraan dalam satu transaksi"
        );
      }

      if (
        notes !== undefined &&
        notes !== null &&
        (typeof notes !== "string" || notes.length > 1000)
      ) {
        throw new InputValidationError(
          "Catatan transaksi maksimal 1000 karakter"
        );
      }

      const transactionDiscount = money(discount);

      // Validasi ID kendaraan.
      const vehicleIds = items.map((item: any) => {
        if (!item || typeof item !== "object") {
          throw new InputValidationError(
            "Data item transaksi tidak valid"
          );
        }

        return parseId(
          item.vehicle_id,
          "Vehicle ID tidak valid"
        );
      });

      const uniqueVehicleIds = new Set(
        vehicleIds.map((id: bigint) => id.toString())
      );

      if (uniqueVehicleIds.size !== vehicleIds.length) {
        throw new InputValidationError(
          "Kendaraan yang sama tidak boleh dimasukkan dua kali"
        );
      }

      const result = await prisma.$transaction(async (tx) => {
        // Pastikan customer tersedia.
        const customer = await tx.users.findFirst({
          where: {
            id: customerId,
            is_active: true,
            deleted_at: null,
          },
        });

        if (!customer) {
          throw new InputValidationError(
            "Customer tidak ditemukan atau tidak aktif"
          );
        }

        // Pastikan petugas tersedia.
        if (handlerId !== null) {
          const handler = await tx.users.findFirst({
            where: {
              id: handlerId,
              is_active: true,
              deleted_at: null,
            },
          });

          if (!handler) {
            throw new InputValidationError(
              "User yang menangani transaksi tidak ditemukan"
            );
          }
        }

        // Ambil kendaraan yang masih tersedia.
        const vehicles = await tx.vehicles.findMany({
          where: {
            id: {
              in: vehicleIds,
            },
            status: "available",
            deleted_at: null,
          },
        });

        if (vehicles.length !== vehicleIds.length) {
          throw new InputValidationError(
            "Ada kendaraan yang tidak ditemukan atau tidak tersedia"
          );
        }

        // Reservasi kendaraan.
        const reservedVehicles = await tx.vehicles.updateMany({
          where: {
            id: {
              in: vehicleIds,
            },
            status: "available",
            deleted_at: null,
          },
          data: {
            status: "reserved",
          },
        });

        if (reservedVehicles.count !== vehicleIds.length) {
          throw new InputValidationError(
            "Ada kendaraan yang sudah dipesan atau tidak tersedia"
          );
        }

        // Catat perubahan status kendaraan.
        for (const vehicle of vehicles) {
          await tx.activity_logs.create({
            data: {
              ...getRequestAudit(req),
              user_id: actorId,
              action: "update",
              entity_type: "vehicle",
              entity_id: vehicle.id,
              old_values: {
                status: "available",
              },
              new_values: {
                status: "reserved",
              },
            },
          });
        }

        let subtotal = 0;
        const transactionItems: any[] = [];

        for (const item of items) {
          const vehicle = vehicles.find(
            (v: any) => v.id === BigInt(item.vehicle_id)
          );

          if (!vehicle) {
            throw new InputValidationError(
              "Data kendaraan tidak ditemukan"
            );
          }

          const salePrice =
            item.sale_price !== undefined
              ? money(item.sale_price)
              : money(vehicle.price);

          if (salePrice <= 0) {
            throw new InputValidationError(
              "Harga jual kendaraan harus lebih dari nol"
            );
          }

          const itemDiscount =
            item.discount_amount !== undefined
              ? money(item.discount_amount)
              : 0;

          if (itemDiscount > salePrice) {
            throw new InputValidationError(
              "Diskon item tidak boleh melebihi harga jual"
            );
          }

          subtotal =
            Math.round((subtotal + salePrice) * 100) / 100;

          const costs = await tx.vehicle_costs.groupBy({
            by: ["cost_type"],
            where: {
              vehicle_id: vehicle.id,
            },
            _sum: {
              amount: true,
            },
          });

          const acquisitionCost = Number(
            costs.find(
              (cost: any) => cost.cost_type === "acquisition"
            )?._sum.amount ?? 0
          );

          const repairCost = Number(
            costs.find(
              (cost: any) => cost.cost_type === "repair"
            )?._sum.amount ?? 0
          );

          const otherCost = Number(
            costs.find(
              (cost: any) => cost.cost_type === "other"
            )?._sum.amount ?? 0
          );

          transactionItems.push({
            vehicle_id: vehicle.id,
            vehicle_title_snapshot: vehicle.title,
            vehicle_code_snapshot: vehicle.vehicle_code,
            acquisition_cost_snapshot: formatMoney(acquisitionCost),
            repair_cost_snapshot: formatMoney(repairCost),
            other_cost_snapshot: formatMoney(otherCost),
            sale_price: formatMoney(salePrice),
            discount_amount: formatMoney(itemDiscount),
          });
        }

        if (transactionDiscount > subtotal) {
          throw new InputValidationError(
            "Diskon transaksi tidak boleh melebihi subtotal"
          );
        }

        const itemDiscountTotal = transactionItems.reduce(
          (total: number, item: any) =>
            total + Number(item.discount_amount),
          0
        );

        const totalDiscount =
          Math.round(
            (transactionDiscount + itemDiscountTotal) * 100
          ) / 100;

        if (totalDiscount > subtotal) {
          throw new InputValidationError(
            "Total diskon tidak boleh melebihi subtotal"
          );
        }

        const totalAmount =
          Math.round((subtotal - totalDiscount) * 100) / 100;

        // Buat transaksi.
        const transaction = await tx.transactions.create({
          data: {
            transaction_code: `TRX-${Date.now()}`,
            customer_id: customerId,
            handled_by: handlerId,
            subtotal: formatMoney(subtotal),
            discount: formatMoney(totalDiscount),
            total_amount: formatMoney(totalAmount),
            status: "pending",
            notes: notes || null,
          },
        });

        // Simpan item transaksi.
        await tx.transaction_items.createMany({
          data: transactionItems.map((item: any) => ({
            ...item,
            transaction_id: transaction.id,
          })),
        });

        // Simpan riwayat status awal.
        await tx.transaction_status_history.create({
          data: {
            transaction_id: transaction.id,
            old_status: null,
            new_status: "pending",
            changed_by: actorId,
            notes: "Transaksi dibuat",
          },
        });

        // Catat Activity Log transaksi.
        await tx.activity_logs.create({
          data: {
            ...getRequestAudit(req),
            user_id: actorId,
            action: "create",
            entity_type: "transaction",
            entity_id: transaction.id,
            new_values: {
              transaction_code: transaction.transaction_code,
              customer_id: customerId.toString(),
              subtotal: formatMoney(subtotal),
              discount: formatMoney(totalDiscount),
              total_amount: formatMoney(totalAmount),
              status: "pending",
            },
          },
        });

        return tx.transactions.findUnique({
          where: {
            id: transaction.id,
          },
          include: {
            transaction_items: true,
            transaction_payments: true,
          },
        });
      });

      return res.status(201).json({
        success: true,
        message: "Transaksi berhasil dibuat",
        data: serializeBigInt(result),
      });
    } catch (error: any) {
      if (error instanceof InputValidationError) {
        return res.status(400).json({
          success: false,
          message: error.message,
        });
      }

      console.error("CREATE TRANSACTION ERROR:", error);

      return res.status(500).json({
        success: false,
        message: "Gagal membuat transaksi",
      });
    }
  }
);

// ==========================================
// UPDATE TRANSACTION STATUS
// ==========================================

router.patch(
  "/transactions/:id/status",
  verifyFirebaseToken,
  authorizeRoles("admin", "owner"),
  async (req: AuthenticatedRequest, res) => {
    try {
      const transactionId = parseId(
        req.params.id,
        "ID transaksi tidak valid"
      );

      const actorId = getActorId(req);
      const newStatus = req.body.status;

      const notes =
        typeof req.body.notes === "string"
          ? req.body.notes.trim()
          : null;

      if (
        notes !== null &&
        notes.length > 1000
      ) {
        throw new InputValidationError(
          "Catatan status maksimal 1000 karakter"
        );
      }

      const allowedTransitions: Record<string, string[]> = {
        pending: ["processing", "cancelled"],
        processing: ["completed", "cancelled"],
        completed: [],
        cancelled: [],
      };

      if (
        typeof newStatus !== "string" ||
        !Object.prototype.hasOwnProperty.call(
          allowedTransitions,
          newStatus
        )
      ) {
        throw new InputValidationError(
          "Status transaksi tidak valid"
        );
      }

      const result = await prisma.$transaction(async (tx) => {
        const transaction = await tx.transactions.findUnique({
          where: {
            id: transactionId,
          },
          include: {
            transaction_items: true,
          },
        });

        if (!transaction) {
          throw new InputValidationError(
            "Transaksi tidak ditemukan"
          );
        }

        const oldStatus = transaction.status;

        if (!allowedTransitions[oldStatus]?.includes(newStatus)) {
          throw new InputValidationError(
            `Transisi status dari ${oldStatus} ke ${newStatus} tidak diizinkan`
          );
        }

        if (transaction.transaction_items.length === 0) {
          throw new InputValidationError(
            "Transaksi tidak memiliki item kendaraan"
          );
        }

        const vehicleIds = transaction.transaction_items.map(
          (item: any) => item.vehicle_id
        );

        // Jika transaksi akan diselesaikan,
        // pastikan pembayaran terverifikasi mencukupi.
        if (newStatus === "completed") {
          const paymentSummary =
            await tx.transaction_payments.aggregate({
              where: {
                transaction_id: transactionId,
                payment_status: "verified",
              },
              _sum: {
                amount: true,
              },
            });

          const verifiedAmount = Number(
            paymentSummary._sum.amount ?? 0
          );

          const totalAmount = Number(transaction.total_amount);

          if (verifiedAmount < totalAmount) {
            throw new InputValidationError(
              "Transaksi belum dapat diselesaikan karena pembayaran terverifikasi belum mencukupi"
            );
          }
        }

        // Jika selesai, ubah kendaraan reserved menjadi sold.
        if (newStatus === "completed") {
          const updatedVehicles = await tx.vehicles.updateMany({
            where: {
              id: {
                in: vehicleIds,
              },
              status: "reserved",
              deleted_at: null,
            },
            data: {
              status: "sold",
            },
          });

          if (updatedVehicles.count !== vehicleIds.length) {
            throw new InputValidationError(
              "Status kendaraan tidak sesuai dengan reservasi transaksi"
            );
          }

          for (const vehicleId of vehicleIds) {
            await tx.activity_logs.create({
              data: {
                ...getRequestAudit(req),
                user_id: actorId,
                action: "update",
                entity_type: "vehicle",
                entity_id: vehicleId,
                old_values: {
                  status: "reserved",
                },
                new_values: {
                  status: "sold",
                },
              },
            });
          }
        }

        // Jika dibatalkan, kembalikan kendaraan menjadi available.
        if (newStatus === "cancelled") {
          const updatedVehicles = await tx.vehicles.updateMany({
            where: {
              id: {
                in: vehicleIds,
              },
              status: "reserved",
              deleted_at: null,
            },
            data: {
              status: "available",
            },
          });

          if (updatedVehicles.count !== vehicleIds.length) {
            throw new InputValidationError(
              "Kendaraan tidak dapat dikembalikan karena status reservasinya sudah berubah"
            );
          }

          for (const vehicleId of vehicleIds) {
            await tx.activity_logs.create({
              data: {
                ...getRequestAudit(req),
                user_id: actorId,
                action: "update",
                entity_type: "vehicle",
                entity_id: vehicleId,
                old_values: {
                  status: "reserved",
                },
                new_values: {
                  status: "available",
                },
              },
            });
          }
        }

        const updatedTransaction = await tx.transactions.update({
          where: {
            id: transactionId,
          },
          data: {
            status: newStatus as any,
          },
        });

        // Catat aktor yang benar-benar mengubah status.
        await tx.transaction_status_history.create({
          data: {
            transaction_id: transactionId,
            old_status: oldStatus,
            new_status: newStatus,
            changed_by: actorId,
            notes: notes || `Status transaksi diubah menjadi ${newStatus}`,
          },
        });

        await tx.activity_logs.create({
          data: {
            ...getRequestAudit(req),
            user_id: actorId,
            action: "update",
            entity_type: "transaction",
            entity_id: transactionId,
            old_values: {
              status: oldStatus,
            },
            new_values: {
              status: newStatus,
            },
          },
        });

        return tx.transactions.findUnique({
          where: {
            id: updatedTransaction.id,
          },
          include: {
            transaction_items: true,
            transaction_payments: true,
            transaction_status_history: true,
          },
        });
      });

      return res.status(200).json({
        success: true,
        message: "Status transaksi berhasil diperbarui",
        data: serializeBigInt(result),
      });
    } catch (error: any) {
      if (error instanceof InputValidationError) {
        return res.status(400).json({
          success: false,
          message: error.message,
        });
      }

      console.error("UPDATE TRANSACTION STATUS ERROR:", error);

      return res.status(500).json({
        success: false,
        message: "Gagal memperbarui status transaksi",
      });
    }
  }
);

// ==========================================
// CREATE TRANSACTION PAYMENT
// ==========================================

router.post(
  "/transactions/:id/payments",
  verifyFirebaseToken,
  async (req: AuthenticatedRequest, res) => {
    try {
      const transactionId = parseId(
        req.params.id,
        "ID transaksi tidak valid"
      );

      const actorId = getActorId(req);
      const amount = money(req.body.amount);

      const paymentMethod =
        req.body.payment_method === undefined
          ? "cash"
          : req.body.payment_method;

      const allowedMethods = [
        "cash",
        "bank_transfer",
        "e_wallet",
        "other",
      ];

      if (amount <= 0) {
        throw new InputValidationError(
          "Nominal pembayaran harus lebih dari nol"
        );
      }

      if (
        typeof paymentMethod !== "string" ||
        !allowedMethods.includes(paymentMethod)
      ) {
        throw new InputValidationError(
          "Metode pembayaran tidak valid"
        );
      }

      const referenceNumber =
        typeof req.body.reference_number === "string"
          ? req.body.reference_number.trim()
          : null;

      const proofUrl =
        typeof req.body.proof_url === "string"
          ? req.body.proof_url.trim()
          : null;

      const notes =
        typeof req.body.notes === "string"
          ? req.body.notes.trim()
          : null;

      if (referenceNumber && referenceNumber.length > 100) {
        throw new InputValidationError(
          "Nomor referensi maksimal 100 karakter"
        );
      }

      if (proofUrl && proofUrl.length > 500) {
        throw new InputValidationError(
          "URL bukti pembayaran maksimal 500 karakter"
        );
      }

      if (notes && notes.length > 1000) {
        throw new InputValidationError(
          "Catatan pembayaran maksimal 1000 karakter"
        );
      }

      const result = await prisma.$transaction(async (tx) => {
        const transaction = await tx.transactions.findUnique({
          where: {
            id: transactionId,
          },
        });

        if (!transaction) {
          throw new InputValidationError(
            "Transaksi tidak ditemukan"
          );
        }

        const isPrivileged = isAdminOrOwner(req);
        const isUser = req.user?.roles.includes("user") === true;

        if (!isPrivileged && !isUser) {
          throw new InputValidationError(
            "Kamu tidak memiliki izin menambahkan pembayaran"
          );
        }

        // User hanya boleh membayar transaksinya sendiri.
        if (
          isUser &&
          !isPrivileged &&
          transaction.customer_id.toString() !== req.user?.id
        ) {
          throw new InputValidationError(
            "Transaksi tidak ditemukan"
          );
        }

        if (
          transaction.status !== "pending" &&
          transaction.status !== "processing"
        ) {
          throw new InputValidationError(
            "Pembayaran hanya dapat ditambahkan pada transaksi pending atau processing"
          );
        }

        const paymentSummary =
          await tx.transaction_payments.aggregate({
            where: {
              transaction_id: transactionId,
              payment_status: {
                in: ["pending", "verified"],
              },
            },
            _sum: {
              amount: true,
            },
          });

        const existingPayments = Number(
          paymentSummary._sum.amount ?? 0
        );

        const totalAmount = Number(transaction.total_amount);

        if (existingPayments + amount > totalAmount) {
          throw new InputValidationError(
            "Total pembayaran melebihi jumlah transaksi"
          );
        }

        const payment = await tx.transaction_payments.create({
          data: {
            transaction_id: transactionId,
            payment_method: paymentMethod as any,
            amount: formatMoney(amount),
            payment_date: new Date(),
            payment_status: "pending",
            reference_number: referenceNumber || null,
            proof_url: proofUrl || null,
            notes: notes || null,
          },
        });

        await tx.activity_logs.create({
          data: {
            ...getRequestAudit(req),
            user_id: actorId,
            action: "create",
            entity_type: "transaction_payment",
            entity_id: payment.id,
            new_values: {
              transaction_id: transactionId.toString(),
              amount: formatMoney(amount),
              payment_method: paymentMethod,
              payment_status: "pending",
            },
          },
        });

        return payment;
      });

      return res.status(201).json({
        success: true,
        message: "Pembayaran berhasil dicatat",
        data: serializeBigInt(result),
      });
    } catch (error: any) {
      if (error instanceof InputValidationError) {
        return res.status(400).json({
          success: false,
          message: error.message,
        });
      }

      console.error("CREATE TRANSACTION PAYMENT ERROR:", error);

      return res.status(500).json({
        success: false,
        message: "Gagal mencatat pembayaran",
      });
    }
  }
);

// ==========================================
// UPDATE TRANSACTION PAYMENT STATUS
// ==========================================

router.patch(
  "/transactions/:id/payments/:paymentId/status",
  verifyFirebaseToken,
  authorizeRoles("admin", "owner"),
  async (req: AuthenticatedRequest, res) => {
    try {
      const transactionId = parseId(
        req.params.id,
        "ID transaksi tidak valid"
      );

      const paymentId = parseId(
        req.params.paymentId,
        "ID pembayaran tidak valid"
      );

      const actorId = getActorId(req);
      const newStatus = req.body.payment_status;

      if (!["verified", "rejected"].includes(newStatus)) {
        throw new InputValidationError(
          "Status pembayaran hanya boleh verified atau rejected"
        );
      }

      const result = await prisma.$transaction(async (tx) => {
        const transaction = await tx.transactions.findUnique({
          where: {
            id: transactionId,
          },
        });

        if (!transaction) {
          throw new InputValidationError(
            "Transaksi tidak ditemukan"
          );
        }

        if (
          transaction.status !== "pending" &&
          transaction.status !== "processing"
        ) {
          throw new InputValidationError(
            "Pembayaran tidak dapat diubah karena transaksi sudah selesai atau dibatalkan"
          );
        }

        const payment = await tx.transaction_payments.findFirst({
          where: {
            id: paymentId,
            transaction_id: transactionId,
          },
        });

        if (!payment) {
          throw new InputValidationError(
            "Pembayaran tidak ditemukan"
          );
        }

        if (payment.payment_status !== "pending") {
          throw new InputValidationError(
            "Pembayaran ini sudah diverifikasi atau ditolak"
          );
        }

        if (newStatus === "verified") {
          const paymentSummary =
            await tx.transaction_payments.aggregate({
              where: {
                transaction_id: transactionId,
                payment_status: "verified",
              },
              _sum: {
                amount: true,
              },
            });

          const verifiedAmount = Number(
            paymentSummary._sum.amount ?? 0
          );

          const totalAmount = Number(transaction.total_amount);

          if (
            verifiedAmount + Number(payment.amount) >
            totalAmount
          ) {
            throw new InputValidationError(
              "Verifikasi pembayaran akan melebihi total transaksi"
            );
          }
        }

        const updatedPayment =
          await tx.transaction_payments.update({
            where: {
              id: paymentId,
            },
            data: {
              payment_status: newStatus as any,
              verified_by: actorId,
            },
          });

        await tx.activity_logs.create({
          data: {
            ...getRequestAudit(req),
            user_id: actorId,
            action: "update",
            entity_type: "transaction_payment",
            entity_id: paymentId,
            old_values: {
              payment_status: "pending",
            },
            new_values: {
              payment_status: newStatus,
              verified_by: actorId.toString(),
            },
          },
        });

        return updatedPayment;
      });

      return res.status(200).json({
        success: true,
        message:
          newStatus === "verified"
            ? "Pembayaran berhasil diverifikasi"
            : "Pembayaran berhasil ditolak",
        data: serializeBigInt(result),
      });
    } catch (error: any) {
      if (error instanceof InputValidationError) {
        return res.status(400).json({
          success: false,
          message: error.message,
        });
      }

      console.error("UPDATE PAYMENT STATUS ERROR:", error);

      return res.status(500).json({
        success: false,
        message: "Gagal memperbarui status pembayaran",
      });
    }
  }
);

export default router;
