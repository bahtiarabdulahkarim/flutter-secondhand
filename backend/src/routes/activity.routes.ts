
import { Router } from "express";
import { prisma } from "../config/database.js";
import {
  verifyFirebaseToken,
  authorizeRoles,
} from "../middlewares/auth.middleware.js";

const router = Router();

// ==========================================
// GET ACTIVITY LOGS
// Admin dan Owner
// ==========================================

router.get(
  "/activity-logs",
  verifyFirebaseToken,
  authorizeRoles("admin", "owner"),
  async (req, res) => {
    try {
      
const pageInput =
  req.query.page === undefined ? "1" : req.query.page;

const limitInput =
  req.query.limit === undefined ? "20" : req.query.limit;

// Validasi page
if (
  typeof pageInput !== "string" ||
  !/^[1-9]\d*$/.test(pageInput) ||
  !Number.isSafeInteger(Number(pageInput))
) {
  return res.status(400).json({
    success: false,
    message: "Parameter page harus berupa bilangan bulat positif",
  });
}

// Validasi limit
if (
  typeof limitInput !== "string" ||
  !/^[1-9]\d*$/.test(limitInput) ||
  !Number.isSafeInteger(Number(limitInput)) ||
  Number(limitInput) > 100
) {
  return res.status(400).json({
    success: false,
    message: "Parameter limit harus berupa bilangan bulat antara 1 sampai 100",
  });
}

const page = Number(pageInput);
const limit = Number(limitInput);
const skip = (page - 1) * limit;

// Pastikan skip masih aman
if (!Number.isSafeInteger(skip)) {
  return res.status(400).json({
    success: false,
    message: "Parameter page terlalu besar",
  });
}


      
      const actionInput = req.query.action;
      const entityTypeInput = req.query.entity_type;
      const userIdInput = req.query.user_id;

      // Validasi action
      if (
        actionInput !== undefined &&
        (
          typeof actionInput !== "string" ||
          actionInput.trim().length > 50 ||
          /[\x00-\x1F\x7F]/.test(actionInput)
        )
      ) {
        return res.status(400).json({
          success: false,
          message: "Parameter action tidak valid atau maksimal 50 karakter.",
        });
      }

      // Validasi entity_type
      if (
        entityTypeInput !== undefined &&
        (
          typeof entityTypeInput !== "string" ||
          entityTypeInput.trim().length > 50 ||
          /[\x00-\x1F\x7F]/.test(entityTypeInput)
        )
      ) {
        return res.status(400).json({
          success: false,
          message: "Parameter entity_type tidak valid atau maksimal 50 karakter.",
        });
      }

      // Validasi user_id
      if (
        userIdInput !== undefined &&
        (
          typeof userIdInput !== "string" ||
          !/^[1-9]\d*$/.test(userIdInput) ||
          BigInt(userIdInput) > 18446744073709551615n
        )
      ) {
        return res.status(400).json({
          success: false,
          message: "user_id harus berupa bilangan positif yang valid.",
        });
      }

      const action =
        typeof actionInput === "string" ? actionInput.trim() : undefined;

      const entityType =
        typeof entityTypeInput === "string"
          ? entityTypeInput.trim()
          : undefined;

      const userId =
        typeof userIdInput === "string" ? userIdInput : undefined;

      const where: any = {};

      if (action) {
        where.action = action;
      }

      if (entityType) {
        where.entity_type = entityType;
      }

      if (userId) {
        where.user_id = BigInt(userId);
      }

      const [logs, total] = await prisma.$transaction([
        prisma.activity_logs.findMany({
          where,
          skip,
          take: limit,
          orderBy: [
            { created_at: "desc" },
            { id: "desc" },
          ],
          select: {
            id: true,
            user_id: true,
            action: true,
            entity_type: true,
            entity_id: true,
            old_values: true,
            new_values: true,
            ip_address: true,
            user_agent: true,
            created_at: true,
            users: {
              select: {
                id: true,
                full_name: true,
                email: true,
              },
            },
          },
        }),

        prisma.activity_logs.count({ where }),
      ]);

      const data = logs.map((log) => ({
        ...log,
        id: log.id.toString(),
        user_id: log.user_id?.toString() ?? null,
        entity_id: log.entity_id?.toString() ?? null,
        users: log.users
          ? {
              id: log.users.id.toString(),
              full_name: log.users.full_name,
              email: log.users.email,
            }
          : null,
      }));

      return res.status(200).json({
        success: true,
        message: "Activity log berhasil diambil",
        pagination: {
          page,
          limit,
          total,
          total_pages: Math.ceil(total / limit),
        },
        data,
      });
    } catch (error) {
      console.error("Get activity logs error:", error);

      return res.status(500).json({
        success: false,
        message: "Gagal mengambil activity log.",
      });
    }
  }
);

export default router;
