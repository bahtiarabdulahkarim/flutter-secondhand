import { Router, type Request } from "express";
import { prisma } from "../config/database.js";
import { verifyFirebaseToken, authorizeRoles, type AuthenticatedRequest } from "../middlewares/auth.middleware.js";

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
// KONFIGURASI
// ==========================================

const allowedCostTypes = [
  "acquisition",
  "repair",
  "other",
];

// ==========================================
// SERIALIZER BIGINT
// ==========================================

function serializeBigInt(value: any): any {
  if (typeof value === "bigint") {
    return value.toString();
  }

  if (Array.isArray(value)) {
    return value.map((item) => serializeBigInt(item));
  }

  if (
    value !== null &&
    typeof value === "object" &&
    Object.getPrototypeOf(value) === Object.prototype
  ) {
    return Object.fromEntries(
      Object.entries(value).map(([key, item]) => [
        key,
        serializeBigInt(item),
      ])
    );
  }

  return value;
}

// ==========================================
// VALIDASI ID
// ==========================================

function parseId(value: unknown): bigint | null {
  if (
    typeof value !== "string" &&
    typeof value !== "number"
  ) {
    return null;
  }

  const str = String(value).trim();

  if (!/^[1-9]\d*$/.test(str)) {
    return null;
  }

  try {
    return BigInt(str);
  } catch {
    return null;
  }
}

// ==========================================
// VALIDASI NOMINAL
// ==========================================

function validateAmount(value: any): string | null {
  if (
    typeof value !== "string" &&
    typeof value !== "number"
  ) {
    return null;
  }

  const amount = String(value).trim();

  if (!/^\d{1,13}(\.\d{1,2})?$/.test(amount)) {
    return null;
  }

  if (Number(amount) <= 0) {
    return null;
  }

  return amount;
}

// ==========================================
// VALIDASI TANGGAL
// Format: YYYY-MM-DD
// ==========================================

function validateDate(value: any): Date | null {
  if (typeof value !== "string") {
    return null;
  }

  if (!/^\d{4}-\d{2}-\d{2}$/.test(value)) {
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

// ==========================================
// CEK KENDARAAN
// ==========================================

async function findVehicle(vehicleId: bigint) {
  return prisma.vehicles.findFirst({
    where: {
      id: vehicleId,
      deleted_at: null,
    },
    select: {
      id: true,
      title: true,
      vehicle_code: true,
      price: true,
      status: true,
    },
  });
}

// ==========================================
// GET /vehicles/:vehicleId/costs
// Mengambil daftar biaya kendaraan
// ==========================================

router.get("/vehicles/:vehicleId/costs", verifyFirebaseToken, authorizeRoles("admin", "owner"), async (req, res) => {
  try {
    const vehicleId = parseId(req.params.vehicleId);

    if (!vehicleId) {
      return res.status(400).json({
        success: false,
        message: "ID kendaraan tidak valid",
      });
    }

    const vehicle = await findVehicle(vehicleId);

    if (!vehicle) {
      return res.status(404).json({
        success: false,
        message: "Data kendaraan tidak ditemukan",
      });
    }

    const costs = await prisma.vehicle_costs.findMany({
      where: {
        vehicle_id: vehicleId,
      },
      orderBy: [
        { expense_date: "desc" },
        { id: "desc" },
      ],
      include: {
       users: {
  select: {
    id: true,
    full_name: true,
  },
},
      },
    });

    return res.json({
      success: true,
      message: "Data biaya kendaraan berhasil diambil",
      vehicle: serializeBigInt(vehicle),
      total: costs.length,
      data: serializeBigInt(costs),
    });
  } catch (error) {
    console.error("ERROR POST VEHICLE COSTS:", error);

    return res.status(500).json({
      success: false,
      message: "Gagal mengambil data biaya kendaraan",
    });
  }
});

// ==========================================
// POST /vehicles/:vehicleId/costs
// Menambahkan biaya kendaraan
// ==========================================

router.post("/vehicles/:vehicleId/costs", verifyFirebaseToken, authorizeRoles("admin", "owner"), async (req, res) => {
  try {
    const vehicleId = parseId(req.params.vehicleId);

    if (!vehicleId) {
      return res.status(400).json({
        success: false,
        message: "ID kendaraan tidak valid",
      });
    }

    const vehicle = await findVehicle(vehicleId);

    if (!vehicle) {
      return res.status(404).json({
        success: false,
        message: "Data kendaraan tidak ditemukan",
      });
    }

    const {
      cost_type,
      description,
      amount,
      expense_date,
    } = req.body;

    if (
      typeof cost_type !== "string" ||
      !allowedCostTypes.includes(cost_type)
    ) {
      return res.status(400).json({
        success: false,
        message: `Jenis biaya harus salah satu dari: ${allowedCostTypes.join(", ")}`,
      });
    }

    const validAmount = validateAmount(amount);

    if (!validAmount) {
      return res.status(400).json({
        success: false,
        message: "Nominal biaya tidak valid",
      });
    }

    const validDate = validateDate(expense_date);

    if (!validDate) {
      return res.status(400).json({
        success: false,
        message: "Tanggal biaya harus menggunakan format YYYY-MM-DD",
      });
    }

    if (
      description !== undefined &&
      description !== null &&
      (
        typeof description !== "string" ||
        description.length > 255
      )
    ) {
      return res.status(400).json({
        success: false,
        message: "Deskripsi maksimal 255 karakter",
      });
    }

    // recorded_by selalu diambil dari token autentikasi, bukan dari body
    const recordedById = BigInt((req as AuthenticatedRequest).user!.id);

const newCost = await prisma.$transaction(async (tx) => {
  const createdCost = await tx.vehicle_costs.create({
    data: {
      vehicle_id: vehicleId,
      cost_type,
      description: description?.trim() || null,
      amount: validAmount,
      expense_date: validDate,
      recorded_by: recordedById,
    },
  });

  // Catat aktivitas penambahan biaya kendaraan
  await tx.activity_logs.create({
    data: {
        ...getRequestAudit(req),
      user_id: BigInt((req as AuthenticatedRequest).user!.id),
      action: "create",
      entity_type: "vehicle_cost",
      entity_id: createdCost.id,
      new_values: {
        vehicle_id: vehicleId.toString(),
        cost_type: createdCost.cost_type,
        description: createdCost.description,
        amount: createdCost.amount.toString(),
        expense_date: createdCost.expense_date.toISOString(),
        recorded_by: createdCost.recorded_by?.toString() ?? null,
      },
    },
  });

  return createdCost;
});

    return res.status(201).json({
      success: true,
      message: "Biaya kendaraan berhasil ditambahkan",
      data: serializeBigInt(newCost),
    });
  } catch (error) {
    console.error("CREATE VEHICLE COST ERROR:", error);

    return res.status(500).json({
      success: false,
      message: "Gagal menambahkan biaya kendaraan",
    });
  }
});

// ==========================================
// PUT /vehicle-costs/:costId
// Mengubah biaya kendaraan
// ==========================================

router.put("/vehicle-costs/:costId", verifyFirebaseToken, authorizeRoles("admin", "owner"), async (req, res) => {
  try {
    const costId = parseId(req.params.costId);

    if (!costId) {
      return res.status(400).json({
        success: false,
        message: "ID biaya tidak valid",
      });
    }

    const existingCost = await prisma.vehicle_costs.findUnique({
      where: {
        id: costId,
      },
    });

    if (!existingCost) {
      return res.status(404).json({
        success: false,
        message: "Data biaya kendaraan tidak ditemukan",
      });
    }

    const {
      cost_type,
      description,
      amount,
      expense_date,
    } = req.body;

    const updateData: {
      cost_type?: string;
      description?: string | null;
      amount?: string;
      expense_date?: Date;
    } = {};

    if (cost_type !== undefined) {
      if (
        typeof cost_type !== "string" ||
        !allowedCostTypes.includes(cost_type)
      ) {
        return res.status(400).json({
          success: false,
          message: `Jenis biaya harus salah satu dari: ${allowedCostTypes.join(", ")}`,
        });
      }

      updateData.cost_type = cost_type;
    }

    if (amount !== undefined) {
      const validAmount = validateAmount(amount);

      if (!validAmount) {
        return res.status(400).json({
          success: false,
          message: "Nominal biaya tidak valid",
        });
      }

      updateData.amount = validAmount;
    }

    if (expense_date !== undefined) {
      const validDate = validateDate(expense_date);

      if (!validDate) {
        return res.status(400).json({
          success: false,
          message: "Tanggal biaya harus menggunakan format YYYY-MM-DD",
        });
      }

      updateData.expense_date = validDate;
    }

    if (description !== undefined) {
      if (
        description !== null &&
        (
          typeof description !== "string" ||
          description.length > 255
        )
      ) {
        return res.status(400).json({
          success: false,
          message: "Deskripsi maksimal 255 karakter",
        });
      }

      updateData.description =
        typeof description === "string"
          ? description.trim() || null
          : null;
    }

    if (Object.keys(updateData).length === 0) {
      return res.status(400).json({
        success: false,
        message: "Tidak ada data yang diubah",
      });
    }

   const updatedCost = await prisma.$transaction(async (tx) => {
  const updated = await tx.vehicle_costs.update({
    where: {
      id: costId,
    },
    data: updateData,
  });

  // Catat perubahan biaya kendaraan
  await tx.activity_logs.create({
    data: {
        ...getRequestAudit(req),
      user_id: BigInt((req as AuthenticatedRequest).user!.id),
      action: "update",
      entity_type: "vehicle_cost",
      entity_id: updated.id,

      old_values: {
        vehicle_id: existingCost.vehicle_id.toString(),
        cost_type: existingCost.cost_type,
        description: existingCost.description,
        amount: existingCost.amount.toString(),
        expense_date: existingCost.expense_date.toISOString(),
        recorded_by: existingCost.recorded_by?.toString() ?? null,
      },

      new_values: {
        vehicle_id: updated.vehicle_id.toString(),
        cost_type: updated.cost_type,
        description: updated.description,
        amount: updated.amount.toString(),
        expense_date: updated.expense_date.toISOString(),
        recorded_by: updated.recorded_by?.toString() ?? null,
      },
    },
  });

  return updated;
});

    return res.json({
      success: true,
      message: "Biaya kendaraan berhasil diperbarui",
      data: serializeBigInt(updatedCost),
    });
  } catch (error) {
    console.error("UPDATE VEHICLE COST ERROR:", error);

    return res.status(500).json({
      success: false,
      message: "Gagal memperbarui biaya kendaraan",
    });
  }
});

// ==========================================
// DELETE /vehicle-costs/:costId
// Menghapus biaya kendaraan
// ==========================================

router.delete("/vehicle-costs/:costId", verifyFirebaseToken, authorizeRoles("admin", "owner"), async (req, res) => {
  try {
    const costId = parseId(req.params.costId);

    if (!costId) {
      return res.status(400).json({
        success: false,
        message: "ID biaya tidak valid",
      });
    }

    const existingCost = await prisma.vehicle_costs.findUnique({
      where: {
        id: costId,
      },
select: {
  id: true,
  vehicle_id: true,
  cost_type: true,
  description: true,
  amount: true,
  expense_date: true,
  recorded_by: true,
},
    });

    if (!existingCost) {
      return res.status(404).json({
        success: false,
        message: "Data biaya kendaraan tidak ditemukan",
      });
    }

await prisma.$transaction(async (tx) => {
  // Hapus biaya kendaraan
  await tx.vehicle_costs.delete({
    where: {
      id: costId,
    },
  });

  // Catat aktivitas penghapusan biaya
  await tx.activity_logs.create({
    data: {
        ...getRequestAudit(req),
      user_id: BigInt((req as AuthenticatedRequest).user!.id),
      action: "delete",
      entity_type: "vehicle_cost",
      entity_id: existingCost.id,
      old_values: {
        vehicle_id: existingCost.vehicle_id.toString(),
        cost_type: existingCost.cost_type,
        description: existingCost.description,
        amount: existingCost.amount.toString(),
        expense_date: existingCost.expense_date.toISOString(),
        recorded_by: existingCost.recorded_by?.toString() ?? null,
      },
      new_values: {
        deleted: true,
      },
    },
  });
});

    return res.json({
      success: true,
      message: "Biaya kendaraan berhasil dihapus",
      data: serializeBigInt({
        deleted_cost_id: existingCost.id,
        vehicle_id: existingCost.vehicle_id,
      }),
    });
  } catch (error) {
    console.error("DELETE VEHICLE COST ERROR:", error);

    return res.status(500).json({
      success: false,
      message: "Gagal menghapus biaya kendaraan",
    });
  }
});

// ==========================================
// GET /vehicles/:vehicleId/cost-summary
// Ringkasan modal dan biaya kendaraan
// ==========================================

router.get(
  "/vehicles/:vehicleId/cost-summary",
  verifyFirebaseToken,
  authorizeRoles("admin", "owner"),
  async (req, res) => {
    try {
      const vehicleId = parseId(req.params.vehicleId);

      if (!vehicleId) {
        return res.status(400).json({
          success: false,
          message: "ID kendaraan tidak valid",
        });
      }

      const vehicle = await findVehicle(vehicleId);

      if (!vehicle) {
        return res.status(404).json({
          success: false,
          message: "Data kendaraan tidak ditemukan",
        });
      }

      const costs = await prisma.vehicle_costs.groupBy({
        by: ["cost_type"],
        where: {
          vehicle_id: vehicleId,
        },
        _sum: {
          amount: true,
        },
        _count: {
          id: true,
        },
      });

      let totalCost = 0;

      const breakdown = costs.map((item) => {
        const amount = Number(item._sum.amount ?? 0);

        totalCost += amount;

        return {
          cost_type: item.cost_type,
          total_amount: amount.toFixed(2),
          total_records: item._count.id,
        };
      });

      const purchaseCost =
        breakdown.find((item) => item.cost_type === "acquisition");

      const sellingPrice = Number(vehicle.price);
      const estimatedProfit = sellingPrice - totalCost;

      return res.json({
        success: true,
        message: "Ringkasan biaya kendaraan berhasil diambil",
        data: {
          vehicle: serializeBigInt(vehicle),
          selling_price: sellingPrice.toFixed(2),
          purchase_cost: purchaseCost?.total_amount ?? "0.00",
          total_cost: totalCost.toFixed(2),
          estimated_profit: estimatedProfit.toFixed(2),
          breakdown,
          note: "Estimasi keuntungan menggunakan harga jual kendaraan saat ini, bukan harga transaksi final.",
        },
      });
    } catch (error) {
      console.error("VEHICLE COST SUMMARY ERROR:", error);

      return res.status(500).json({
        success: false,
        message: "Gagal mengambil ringkasan biaya kendaraan",
      });
    }
  }
);

export default router;
