
import { Router, type Request } from "express";
import { prisma } from "../config/database.js";
import {
  verifyFirebaseToken,
  authorizeRoles,
} from "../middlewares/auth.middleware.js";
import type { AuthenticatedRequest } from "../middlewares/auth.middleware.js";

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
// CUSTOM ERRORS
// ==========================================

class InputValidationError extends Error {
  constructor(message: string) {
    super(message);
    this.name = "InputValidationError";
  }
}

class ModelNotFoundError extends Error {
  constructor() {
    super("MODEL_NOT_FOUND");
    this.name = "ModelNotFoundError";
  }
}

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
// GET /api/v1/vehicles
// Daftar kendaraan + pagination + filter
// PUBLIC
// ==========================================

router.get("/", async (req, res) => {
  try {
    const page = Math.max(1, Number(req.query.page) || 1);

    const limit = Math.min(
      50,
      Math.max(1, Number(req.query.limit) || 10)
    );

    const skip = (page - 1) * limit;

    const search =
      typeof req.query.search === "string"
        ? req.query.search.trim()
        : "";

    const category =
      typeof req.query.category === "string"
        ? req.query.category.trim().toLowerCase()
        : "";

    const minPriceRaw =
      typeof req.query.minPrice === "string"
        ? req.query.minPrice.trim()
        : "";

    const maxPriceRaw =
      typeof req.query.maxPrice === "string"
        ? req.query.maxPrice.trim()
        : "";

    const minPrice = minPriceRaw
      ? Number(minPriceRaw)
      : undefined;

    const maxPrice = maxPriceRaw
      ? Number(maxPriceRaw)
      : undefined;

    if (
      minPrice !== undefined &&
      (!Number.isFinite(minPrice) || minPrice < 0)
    ) {
      return res.status(400).json({
        success: false,
        message: "Harga minimum tidak valid",
      });
    }

    if (
      maxPrice !== undefined &&
      (!Number.isFinite(maxPrice) || maxPrice < 0)
    ) {
      return res.status(400).json({
        success: false,
        message: "Harga maksimum tidak valid",
      });
    }

    if (
      minPrice !== undefined &&
      maxPrice !== undefined &&
      minPrice > maxPrice
    ) {
      return res.status(400).json({
        success: false,
        message:
          "Harga minimum tidak boleh lebih besar dari harga maksimum",
      });
    }

    const minYearRaw =
      typeof req.query.minYear === "string"
        ? req.query.minYear.trim()
        : "";

    const maxYearRaw =
      typeof req.query.maxYear === "string"
        ? req.query.maxYear.trim()
        : "";

    const minYear = minYearRaw
      ? Number(minYearRaw)
      : undefined;

    const maxYear = maxYearRaw
      ? Number(maxYearRaw)
      : undefined;

    const currentYear = new Date().getFullYear();

    if (
      minYear !== undefined &&
      (!Number.isInteger(minYear) ||
        minYear < 1901 ||
        minYear > currentYear)
    ) {
      return res.status(400).json({
        success: false,
        message: "Tahun minimum tidak valid",
      });
    }

    if (
      maxYear !== undefined &&
      (!Number.isInteger(maxYear) ||
        maxYear < 1901 ||
        maxYear > currentYear)
    ) {
      return res.status(400).json({
        success: false,
        message: "Tahun maksimum tidak valid",
      });
    }

    if (
      minYear !== undefined &&
      maxYear !== undefined &&
      minYear > maxYear
    ) {
      return res.status(400).json({
        success: false,
        message:
          "Tahun minimum tidak boleh lebih besar dari tahun maksimum",
      });
    }

    const transmission =
      typeof req.query.transmission === "string"
        ? req.query.transmission.trim()
        : "";

    const fuelType =
      typeof req.query.fuelType === "string"
        ? req.query.fuelType.trim()
        : "";

    const condition =
      typeof req.query.condition === "string"
        ? req.query.condition.trim().toLowerCase()
        : "";

    const allowedConditions = [
      "excellent",
      "good",
      "fair",
      "needs_repair",
    ];

    if (
      condition &&
      !allowedConditions.includes(condition)
    ) {
      return res.status(400).json({
        success: false,
        message: "Kondisi kendaraan tidak valid",
        allowedConditions,
      });
    }

    const sort =
      typeof req.query.sort === "string"
        ? req.query.sort.trim().toLowerCase()
        : "newest";

    const allowedSorts = [
      "newest",
      "oldest",
      "price_asc",
      "price_desc",
    ];

    if (!allowedSorts.includes(sort)) {
      return res.status(400).json({
        success: false,
        message: "Pilihan sorting tidak valid",
        allowedSorts,
      });
    }

    const orderBy =
      sort === "price_asc"
        ? { price: "asc" as const }
        : sort === "price_desc"
          ? { price: "desc" as const }
          : sort === "oldest"
            ? { created_at: "asc" as const }
            : { created_at: "desc" as const };

    const where = {
      deleted_at: null,
      status: "available",

      AND: [
        ...(search
          ? [
              {
                OR: [
                  {
                    title: {
                      contains: search,
                    },
                  },
                  {
                    vehicle_code: {
                      contains: search,
                    },
                  },
                  {
                    vehicle_models: {
                      brands: {
                        name: {
                          contains: search,
                        },
                      },
                    },
                  },
                ],
              },
            ]
          : []),

        ...(category
          ? [
              {
                vehicle_models: {
                  categories: {
                    slug: category,
                  },
                },
              },
            ]
          : []),

        ...(minPrice !== undefined
          ? [{ price: { gte: minPrice } }]
          : []),

        ...(maxPrice !== undefined
          ? [{ price: { lte: maxPrice } }]
          : []),

        ...(minYear !== undefined
          ? [{ year: { gte: minYear } }]
          : []),

        ...(maxYear !== undefined
          ? [{ year: { lte: maxYear } }]
          : []),

        ...(transmission
          ? [{ transmission: { equals: transmission } }]
          : []),

        ...(fuelType
          ? [{ fuel_type: { equals: fuelType } }]
          : []),

        ...(condition
          ? [{ vehicle_condition: { equals: condition } }]
          : []),
      ],
    };

    const [vehicles, total] = await Promise.all([
      prisma.vehicles.findMany({
        where,
        include: {
          vehicle_models: {
            include: {
              brands: true,
              categories: true,
            },
          },
          vehicle_images: {
            orderBy: [
              { is_primary: "desc" },
              { sort_order: "asc" },
            ],
          },
        },
        orderBy,
        skip,
        take: limit,
      }),

      prisma.vehicles.count({ where }),
    ]);

    const vehicleData = serializeBigInt(vehicles);
    const totalPages = Math.ceil(total / limit);

    return res.status(200).json({
      success: true,
      message: "Data kendaraan berhasil diambil",

      pagination: {
        page,
        limit,
        total,
        totalPages,
      },

      filters: {
        search: search || null,
        category: category || null,
        minPrice: minPrice ?? null,
        maxPrice: maxPrice ?? null,
        minYear: minYear ?? null,
        maxYear: maxYear ?? null,
        transmission: transmission || null,
        fuelType: fuelType || null,
        condition: condition || null,
        sort,
      },

      data: vehicleData,
    });
  } catch (error) {
    console.error("Get vehicles error:", error);

    return res.status(500).json({
      success: false,
      message: "Gagal mengambil data kendaraan",
    });
  }
});

// ==========================================
// POST /api/v1/vehicles
// Menambahkan kendaraan baru
// ADMIN / OWNER
// ==========================================

router.post(
  "/",
  verifyFirebaseToken,
  authorizeRoles("admin", "owner"),
  async (req, res) => {
    try {
      if (
        !req.body ||
        typeof req.body !== "object" ||
        Array.isArray(req.body)
      ) {
        return res.status(400).json({
          success: false,
          message: "Format body tidak valid",
        });
      }

      const body = req.body as Record<string, unknown>;

      const getOptionalText = (
        value: unknown,
        fieldName: string,
        maxLength: number,
        allowEmpty = true
      ): string | null => {
        if (value === undefined || value === null) {
          return null;
        }

        if (typeof value !== "string") {
          throw new InputValidationError(
            `${fieldName} harus berupa teks`
          );
        }

        const result = value.trim();

        if (result.length === 0) {
          if (allowEmpty) {
            return null;
          }

          throw new InputValidationError(
            `${fieldName} tidak boleh kosong`
          );
        }

        if (result.length > maxLength) {
          throw new InputValidationError(
            `${fieldName} maksimal ${maxLength} karakter`
          );
        }

        return result;
      };

      const modelIdRaw = body.model_id;

      if (
        !(
          typeof modelIdRaw === "string" ||
          typeof modelIdRaw === "number"
        )
      ) {
        return res.status(400).json({
          success: false,
          message: "model_id wajib diisi",
        });
      }

      const modelIdText = String(modelIdRaw).trim();

      if (!/^[1-9]\d*$/.test(modelIdText)) {
        return res.status(400).json({
          success: false,
          message: "model_id tidak valid",
        });
      }

      const modelId = BigInt(modelIdText);

      const vehicleCode = getOptionalText(
        body.vehicle_code,
        "vehicle_code",
        30,
        false
      );

      if (!vehicleCode) {
        return res.status(400).json({
          success: false,
          message: "Kode kendaraan wajib diisi",
        });
      }

      const title = getOptionalText(
        body.title,
        "title",
        150,
        false
      );

      if (!title) {
        return res.status(400).json({
          success: false,
          message: "Nama kendaraan wajib diisi",
        });
      }

      const year = Number(body.year);
      const currentYear = new Date().getFullYear();

      if (
        !Number.isInteger(year) ||
        year < 1901 ||
        year > currentYear
      ) {
        return res.status(400).json({
          success: false,
          message:
            `Tahun kendaraan harus antara 1901 dan ${currentYear}`,
        });
      }

      const price = Number(body.price);

      if (
        body.price === undefined ||
        body.price === null ||
        body.price === "" ||
        !Number.isFinite(price) ||
        price <= 0 ||
        price > 9999999999999.99
      ) {
        return res.status(400).json({
          success: false,
          message: "Harga kendaraan tidak valid",
        });
      }

      const mileage =
        body.mileage === undefined ||
        body.mileage === null ||
        body.mileage === ""
          ? null
          : Number(body.mileage);

      if (
        mileage !== null &&
        (!Number.isInteger(mileage) ||
          mileage < 0 ||
          mileage > 4294967295)
      ) {
        return res.status(400).json({
          success: false,
          message: "Kilometer kendaraan tidak valid",
        });
      }

      const engineCapacity =
        body.engine_capacity === undefined ||
        body.engine_capacity === null ||
        body.engine_capacity === ""
          ? null
          : Number(body.engine_capacity);

      if (
        engineCapacity !== null &&
        (!Number.isInteger(engineCapacity) ||
          engineCapacity < 0 ||
          engineCapacity > 4294967295)
      ) {
        return res.status(400).json({
          success: false,
          message: "Kapasitas mesin tidak valid",
        });
      }

      const transmission = getOptionalText(
        body.transmission,
        "transmission",
        30
      );

      const fuelType = getOptionalText(
        body.fuel_type,
        "fuel_type",
        30
      );

      const color = getOptionalText(
        body.color,
        "color",
        50
      );

      const engineNumber = getOptionalText(
        body.engine_number,
        "engine_number",
        100,
        false
      );

      const chassisNumber = getOptionalText(
        body.chassis_number,
        "chassis_number",
        100,
        false
      );

      const licensePlate = getOptionalText(
        body.license_plate,
        "license_plate",
        20
      );

      const description = getOptionalText(
        body.description,
        "description",
        65535
      );

      const vehicleCondition =
        body.vehicle_condition === undefined
          ? "good"
          : typeof body.vehicle_condition === "string"
            ? body.vehicle_condition.trim().toLowerCase()
            : "";

      const allowedConditions = [
        "excellent",
        "good",
        "fair",
        "needs_repair",
      ];

      if (!allowedConditions.includes(vehicleCondition)) {
        return res.status(400).json({
          success: false,
          message: "Kondisi kendaraan tidak valid",
          allowedConditions,
        });
      }

      const isFeatured =
        body.is_featured === undefined
          ? false
          : body.is_featured;

      if (typeof isFeatured !== "boolean") {
        return res.status(400).json({
          success: false,
          message:
            "is_featured harus bernilai true atau false",
        });
      }

      const vehicle = await prisma.$transaction(async (tx) => {
        const existingModel =
          await tx.vehicle_models.findUnique({
            where: {
              id: modelId,
            },
          });

        if (!existingModel) {
          throw new ModelNotFoundError();
        }

        const createdVehicle = await tx.vehicles.create({
          data: {
            model_id: modelId,
            vehicle_code: vehicleCode,
            title,
            year,
            price: price.toString(),
            mileage,
            transmission,
            fuel_type: fuelType,
            color,
            engine_capacity: engineCapacity,
            engine_number: engineNumber,
            chassis_number: chassisNumber,
            license_plate: licensePlate,
            description,
            vehicle_condition: vehicleCondition,
            status: "available",
            is_featured: isFeatured,
          },

          include: {
            vehicle_models: {
              include: {
                brands: true,
                categories: true,
              },
            },
            vehicle_images: true,
          },
        });

        await tx.activity_logs.create({
          data: {
            ...getRequestAudit(req),
           user_id: BigInt((req as AuthenticatedRequest).user!.id),
            action: "create",
            entity_type: "vehicle",
            entity_id: createdVehicle.id,
            old_values: undefined,
            new_values: {
              vehicle_code: createdVehicle.vehicle_code,
              title: createdVehicle.title,
              year: createdVehicle.year,
              price: createdVehicle.price.toString(),
              status: createdVehicle.status,
            },
          },
        });

        return createdVehicle;
      });

      return res.status(201).json({
        success: true,
        message: "Kendaraan berhasil ditambahkan",
        data: serializeBigInt(vehicle),
      });
    } catch (error) {
      console.error("Create vehicle error:", error);

      if (error instanceof ModelNotFoundError) {
        return res.status(404).json({
          success: false,
          message: "Model kendaraan tidak ditemukan",
        });
      }

      if (error instanceof InputValidationError) {
        return res.status(400).json({
          success: false,
          message: error.message,
        });
      }

      if (
        typeof error === "object" &&
        error !== null &&
        "code" in error &&
        error.code === "P2002"
      ) {
        return res.status(409).json({
          success: false,
          message:
            "Kode kendaraan, nomor mesin, atau nomor rangka sudah digunakan",
        });
      }

      if (
        typeof error === "object" &&
        error !== null &&
        "code" in error &&
        error.code === "P2003"
      ) {
        return res.status(400).json({
          success: false,
          message: "Relasi data kendaraan tidak valid",
        });
      }

      return res.status(500).json({
        success: false,
        message: "Gagal menambahkan kendaraan",
      });
    }
  }
);

// ==========================================
// PATCH /api/v1/vehicles/:id
// Mengubah sebagian data kendaraan
// ADMIN / OWNER
// ==========================================

router.patch(
  "/:id",
  verifyFirebaseToken,
  authorizeRoles("admin", "owner"),
  async (req, res) => {
    try {
      const vehicleId = String(req.params.id);

      if (!/^[1-9]\d*$/.test(vehicleId)) {
        return res.status(400).json({
          success: false,
          message: "ID kendaraan tidak valid",
        });
      }

      if (
        !req.body ||
        typeof req.body !== "object" ||
        Array.isArray(req.body)
      ) {
        return res.status(400).json({
          success: false,
          message: "Format body tidak valid",
        });
      }

      const body = req.body as Record<string, unknown>;
      const id = BigInt(vehicleId);

      const existingVehicle = await prisma.vehicles.findFirst({
        where: {
          id,
          deleted_at: null,
        },
      });

      if (!existingVehicle) {
        return res.status(404).json({
          success: false,
          message: "Kendaraan tidak ditemukan",
        });
      }

      const data: Record<string, any> = {};

      const hasField = (field: string) =>
        Object.prototype.hasOwnProperty.call(body, field);

      if (hasField("model_id")) {
        const modelIdRaw = body.model_id;

        if (
          typeof modelIdRaw !== "string" &&
          typeof modelIdRaw !== "number"
        ) {
          throw new InputValidationError("model_id tidak valid");
        }

        const modelIdText = String(modelIdRaw).trim();

        if (!/^[1-9]\d*$/.test(modelIdText)) {
          throw new InputValidationError("model_id tidak valid");
        }

        const modelId = BigInt(modelIdText);

        const existingModel =
          await prisma.vehicle_models.findUnique({
            where: { id: modelId },
          });

        if (!existingModel) {
          throw new ModelNotFoundError();
        }

        data.model_id = modelId;
      }

      const validateText = (
        field: string,
        maxLength: number,
        allowEmpty = true
      ) => {
        if (!hasField(field)) return;

        const value = body[field];

        if (value === null) {
          data[field] = null;
          return;
        }

        if (typeof value !== "string") {
          throw new InputValidationError(
            `${field} harus berupa teks`
          );
        }

        const result = value.trim();

        if (!result && !allowEmpty) {
          throw new InputValidationError(
            `${field} tidak boleh kosong`
          );
        }

        if (result.length > maxLength) {
          throw new InputValidationError(
            `${field} maksimal ${maxLength} karakter`
          );
        }

        data[field] = result || null;
      };

      validateText("vehicle_code", 30, false);
      validateText("title", 150, false);
      validateText("transmission", 30);
      validateText("fuel_type", 30);
      validateText("color", 50);
      validateText("engine_number", 100);
      validateText("chassis_number", 100);
      validateText("license_plate", 20);
      validateText("description", 65535);

      if (hasField("year")) {
        const year = Number(body.year);
        const currentYear = new Date().getFullYear();

        if (
          !Number.isInteger(year) ||
          year < 1901 ||
          year > currentYear
        ) {
          throw new InputValidationError(
            `Tahun kendaraan harus antara 1901 dan ${currentYear}`
          );
        }

        data.year = year;
      }

      if (hasField("price")) {
        const price = Number(body.price);

        if (
          body.price === null ||
          body.price === "" ||
          !Number.isFinite(price) ||
          price <= 0 ||
          price > 9999999999999.99
        ) {
          throw new InputValidationError(
            "Harga kendaraan tidak valid"
          );
        }

        data.price = price.toString();
      }

      if (hasField("mileage")) {
        const mileage =
          body.mileage === null || body.mileage === ""
            ? null
            : Number(body.mileage);

        if (
          mileage !== null &&
          (!Number.isInteger(mileage) ||
            mileage < 0 ||
            mileage > 4294967295)
        ) {
          throw new InputValidationError(
            "Kilometer kendaraan tidak valid"
          );
        }

        data.mileage = mileage;
      }

      if (hasField("engine_capacity")) {
        const capacity =
          body.engine_capacity === null ||
          body.engine_capacity === ""
            ? null
            : Number(body.engine_capacity);

        if (
          capacity !== null &&
          (!Number.isInteger(capacity) ||
            capacity < 0 ||
            capacity > 4294967295)
        ) {
          throw new InputValidationError(
            "Kapasitas mesin tidak valid"
          );
        }

        data.engine_capacity = capacity;
      }

      if (hasField("vehicle_condition")) {
        const condition =
          typeof body.vehicle_condition === "string"
            ? body.vehicle_condition.trim().toLowerCase()
            : "";

        const allowedConditions = [
          "excellent",
          "good",
          "fair",
          "needs_repair",
        ];

        if (!allowedConditions.includes(condition)) {
          throw new InputValidationError(
            "Kondisi kendaraan tidak valid"
          );
        }

        data.vehicle_condition = condition;
      }

      if (hasField("is_featured")) {
        if (typeof body.is_featured !== "boolean") {
          throw new InputValidationError(
            "is_featured harus bernilai true atau false"
          );
        }

        data.is_featured = body.is_featured;
      }

      if (Object.keys(data).length === 0) {
        return res.status(400).json({
          success: false,
          message: "Tidak ada data kendaraan yang diubah",
        });
      }

      const updatedVehicle = await prisma.$transaction(async (tx) => {
        const updated = await tx.vehicles.update({
          where: { id },
          data,
          include: {
            vehicle_models: {
              include: {
                brands: true,
                categories: true,
              },
            },
            vehicle_images: {
              orderBy: [
                { is_primary: "desc" },
                { sort_order: "asc" },
              ],
            },
          },
        });

        const changedFields = Object.keys(data);

        const toLogValue = (value: any) => {
          if (typeof value === "bigint") {
            return value.toString();
          }

          if (value !== null && typeof value === "object") {
            return value.toString();
          }

          return value;
        };

        const oldValues = Object.fromEntries(
          changedFields.map((field) => [
            field,
            toLogValue(
              (existingVehicle as unknown as Record<string, any>)[field]
            ),
          ])
        );

        const newValues = Object.fromEntries(
          changedFields.map((field) => [
            field,
            toLogValue(
              (updated as unknown as Record<string, any>)[field]
            ),
          ])
        );

        await tx.activity_logs.create({
          data: {
            ...getRequestAudit(req),
            user_id: BigInt((req as AuthenticatedRequest).user!.id),
            action: "update",
            entity_type: "vehicle",
            entity_id: updated.id,
            old_values: oldValues,
            new_values: newValues,
          },
        });

        return updated;
      });

      return res.status(200).json({
        success: true,
        message: "Data kendaraan berhasil diperbarui",
        data: serializeBigInt(updatedVehicle),
      });
    } catch (error) {
      console.error("Update vehicle error:", error);

      if (error instanceof ModelNotFoundError) {
        return res.status(404).json({
          success: false,
          message: "Model kendaraan tidak ditemukan",
        });
      }

      if (error instanceof InputValidationError) {
        return res.status(400).json({
          success: false,
          message: error.message,
        });
      }

      if (
        typeof error === "object" &&
        error !== null &&
        "code" in error &&
        error.code === "P2002"
      ) {
        return res.status(409).json({
          success: false,
          message:
            "Kode kendaraan, nomor mesin, atau nomor rangka sudah digunakan",
        });
      }

      if (
        typeof error === "object" &&
        error !== null &&
        "code" in error &&
        error.code === "P2003"
      ) {
        return res.status(400).json({
          success: false,
          message: "Relasi data kendaraan tidak valid",
        });
      }

      return res.status(500).json({
        success: false,
        message: "Gagal memperbarui data kendaraan",
      });
    }
  }
);

// ==========================================
// PUT /api/v1/vehicles/:id
// Mengganti seluruh data kendaraan
// ADMIN / OWNER
// ==========================================

router.put(
  "/:id",
  verifyFirebaseToken,
  authorizeRoles("admin", "owner"),
  async (req, res) => {
    try {
      const vehicleId = String(req.params.id);

      if (!/^[1-9]\d*$/.test(vehicleId)) {
        return res.status(400).json({
          success: false,
          message: "ID kendaraan tidak valid",
        });
      }

      if (
        !req.body ||
        typeof req.body !== "object" ||
        Array.isArray(req.body)
      ) {
        return res.status(400).json({
          success: false,
          message: "Format body tidak valid",
        });
      }

      const body = req.body as Record<string, unknown>;
      const id = BigInt(vehicleId);

      const existingVehicle = await prisma.vehicles.findFirst({
        where: {
          id,
          deleted_at: null,
        },
      });

      if (!existingVehicle) {
        return res.status(404).json({
          success: false,
          message: "Kendaraan tidak ditemukan",
        });
      }

      const getText = (
        field: string,
        maxLength: number,
        required = false
      ): string | null => {
        const value = body[field];

        if (value === undefined || value === null) {
          if (required) {
            throw new InputValidationError(
              `${field} wajib diisi`
            );
          }

          return null;
        }

        if (typeof value !== "string") {
          throw new InputValidationError(
            `${field} harus berupa teks`
          );
        }

        const result = value.trim();

        if (!result) {
          if (required) {
            throw new InputValidationError(
              `${field} tidak boleh kosong`
            );
          }

          return null;
        }

        if (result.length > maxLength) {
          throw new InputValidationError(
            `${field} maksimal ${maxLength} karakter`
          );
        }

        return result;
      };

      const modelIdRaw = body.model_id;

      if (
        typeof modelIdRaw !== "string" &&
        typeof modelIdRaw !== "number"
      ) {
        throw new InputValidationError(
          "model_id wajib diisi"
        );
      }

      const modelIdText = String(modelIdRaw).trim();

      if (!/^[1-9]\d*$/.test(modelIdText)) {
        throw new InputValidationError(
          "model_id tidak valid"
        );
      }

      const modelId = BigInt(modelIdText);

      const existingModel = await prisma.vehicle_models.findUnique({
        where: {
          id: modelId,
        },
      });

      if (!existingModel) {
        throw new ModelNotFoundError();
      }

      const vehicleCode = getText(
        "vehicle_code",
        30,
        true
      );

      const title = getText(
        "title",
        150,
        true
      );

      const year = Number(body.year);
      const currentYear = new Date().getFullYear();

      if (
        body.year === undefined ||
        body.year === null ||
        body.year === "" ||
        !Number.isInteger(year) ||
        year < 1901 ||
        year > currentYear
      ) {
        throw new InputValidationError(
          `Tahun kendaraan harus antara 1901 dan ${currentYear}`
        );
      }

      const price = Number(body.price);

      if (
        body.price === undefined ||
        body.price === null ||
        body.price === "" ||
        !Number.isFinite(price) ||
        price <= 0 ||
        price > 9999999999999.99
      ) {
        throw new InputValidationError(
          "Harga kendaraan tidak valid"
        );
      }

      const mileage =
        body.mileage === undefined ||
        body.mileage === null ||
        body.mileage === ""
          ? null
          : Number(body.mileage);

      if (
        mileage !== null &&
        (!Number.isInteger(mileage) ||
          mileage < 0 ||
          mileage > 4294967295)
      ) {
        throw new InputValidationError(
          "Kilometer kendaraan tidak valid"
        );
      }

      const engineCapacity =
        body.engine_capacity === undefined ||
        body.engine_capacity === null ||
        body.engine_capacity === ""
          ? null
          : Number(body.engine_capacity);

      if (
        engineCapacity !== null &&
        (!Number.isInteger(engineCapacity) ||
          engineCapacity < 0 ||
          engineCapacity > 4294967295)
      ) {
        throw new InputValidationError(
          "Kapasitas mesin tidak valid"
        );
      }

      const transmission = getText("transmission", 30);
      const fuelType = getText("fuel_type", 30);
      const color = getText("color", 50);
      const engineNumber = getText("engine_number", 100);
      const chassisNumber = getText("chassis_number", 100);
      const licensePlate = getText("license_plate", 20);
      const description = getText("description", 65535);

      const vehicleCondition =
        body.vehicle_condition === undefined
          ? "good"
          : typeof body.vehicle_condition === "string"
            ? body.vehicle_condition.trim().toLowerCase()
            : "";

      const allowedConditions = [
        "excellent",
        "good",
        "fair",
        "needs_repair",
      ];

      if (!allowedConditions.includes(vehicleCondition)) {
        throw new InputValidationError(
          "Kondisi kendaraan tidak valid"
        );
      }

      const isFeatured =
        body.is_featured === undefined
          ? false
          : body.is_featured;

      if (typeof isFeatured !== "boolean") {
        throw new InputValidationError(
          "is_featured harus bernilai true atau false"
        );
      }

      const updatedVehicle = await prisma.$transaction(async (tx) => {
        const updated = await tx.vehicles.update({
          where: {
            id,
          },

          data: {
            model_id: modelId,
            vehicle_code: vehicleCode!,
            title: title!,
            year,
            price: price.toString(),
            mileage,
            transmission,
            fuel_type: fuelType,
            color,
            engine_capacity: engineCapacity,
            engine_number: engineNumber,
            chassis_number: chassisNumber,
            license_plate: licensePlate,
            description,
            vehicle_condition: vehicleCondition,
            is_featured: isFeatured,
          },

          include: {
            vehicle_models: {
              include: {
                brands: true,
                categories: true,
              },
            },
            vehicle_images: {
              orderBy: [
                { is_primary: "desc" },
                { sort_order: "asc" },
              ],
            },
          },
        });

        await tx.activity_logs.create({
          data: {
            ...getRequestAudit(req),
            user_id: BigInt((req as AuthenticatedRequest).user!.id),
            action: "replace",
            entity_type: "vehicle",
            entity_id: updated.id,

            old_values: {
              model_id: existingVehicle.model_id.toString(),
              vehicle_code: existingVehicle.vehicle_code,
              title: existingVehicle.title,
              year: existingVehicle.year,
              price: existingVehicle.price.toString(),
              mileage: existingVehicle.mileage,
              transmission: existingVehicle.transmission,
              fuel_type: existingVehicle.fuel_type,
              color: existingVehicle.color,
              engine_capacity: existingVehicle.engine_capacity,
              engine_number: existingVehicle.engine_number,
              chassis_number: existingVehicle.chassis_number,
              license_plate: existingVehicle.license_plate,
              description: existingVehicle.description,
              vehicle_condition: existingVehicle.vehicle_condition,
              status: existingVehicle.status,
              is_featured: existingVehicle.is_featured,
            },

            new_values: {
              model_id: updated.model_id.toString(),
              vehicle_code: updated.vehicle_code,
              title: updated.title,
              year: updated.year,
              price: updated.price.toString(),
              mileage: updated.mileage,
              transmission: updated.transmission,
              fuel_type: updated.fuel_type,
              color: updated.color,
              engine_capacity: updated.engine_capacity,
              engine_number: updated.engine_number,
              chassis_number: updated.chassis_number,
              license_plate: updated.license_plate,
              description: updated.description,
              vehicle_condition: updated.vehicle_condition,
              status: updated.status,
              is_featured: updated.is_featured,
            },
          },
        });

        return updated;
      });

      return res.status(200).json({
        success: true,
        message: "Seluruh data kendaraan berhasil diperbarui",
        data: serializeBigInt(updatedVehicle),
      });
    } catch (error) {
      console.error("Replace vehicle error:", error);

      if (error instanceof ModelNotFoundError) {
        return res.status(404).json({
          success: false,
          message: "Model kendaraan tidak ditemukan",
        });
      }

      if (error instanceof InputValidationError) {
        return res.status(400).json({
          success: false,
          message: error.message,
        });
      }

      if (
        typeof error === "object" &&
        error !== null &&
        "code" in error &&
        error.code === "P2002"
      ) {
        return res.status(409).json({
          success: false,
          message:
            "Kode kendaraan, nomor mesin, atau nomor rangka sudah digunakan",
        });
      }

      if (
        typeof error === "object" &&
        error !== null &&
        "code" in error &&
        error.code === "P2003"
      ) {
        return res.status(400).json({
          success: false,
          message: "Relasi data kendaraan tidak valid",
        });
      }

      return res.status(500).json({
        success: false,
        message: "Gagal mengganti data kendaraan",
      });
    }
  }
);

// ==========================================
// GET /api/v1/vehicles/:id
// Detail kendaraan
// PUBLIC
// ==========================================

router.get("/:id", async (req, res) => {
  try {
    const vehicleId = String(req.params.id);

    if (!/^[1-9]\d*$/.test(vehicleId)) {
      return res.status(400).json({
        success: false,
        message: "ID kendaraan tidak valid",
      });
    }

    const vehicle = await prisma.vehicles.findFirst({
      where: {
        id: BigInt(vehicleId),
        deleted_at: null,
        status: "available",
      },

      include: {
        vehicle_models: {
          include: {
            brands: true,
            categories: true,
          },
        },

        vehicle_images: {
          orderBy: [
            { is_primary: "desc" },
            { sort_order: "asc" },
          ],
        },
      },
    });

    if (!vehicle) {
      return res.status(404).json({
        success: false,
        message: "Kendaraan tidak ditemukan",
      });
    }

    const vehicleData = serializeBigInt(vehicle);

    return res.status(200).json({
      success: true,
      message: "Detail kendaraan berhasil diambil",
      data: vehicleData,
    });
  } catch (error) {
    console.error("Get vehicle detail error:", error);

    return res.status(500).json({
      success: false,
      message: "Gagal mengambil detail kendaraan",
    });
  }
});

// ==========================================
// DELETE /api/v1/vehicles/:id
// Soft delete kendaraan + Activity Logs
// ADMIN / OWNER
// ==========================================

router.delete(
  "/:id",
  verifyFirebaseToken,
  authorizeRoles("admin", "owner"),
  async (req, res) => {
    try {
      const vehicleId = String(req.params.id);

      if (!/^[1-9]\d*$/.test(vehicleId)) {
        return res.status(400).json({
          success: false,
          message: "ID kendaraan tidak valid",
        });
      }

      const id = BigInt(vehicleId);

      const existingVehicle = await prisma.vehicles.findFirst({
        where: {
          id,
          deleted_at: null,
        },
      });

      if (!existingVehicle) {
        return res.status(404).json({
          success: false,
          message: "Kendaraan tidak ditemukan atau sudah dihapus",
        });
      }

      await prisma.$transaction(async (tx) => {
        const deletedAt = new Date();

        await tx.vehicles.update({
          where: { id },
          data: {
            deleted_at: deletedAt,
          },
        });

        await tx.activity_logs.create({
          data: {
            ...getRequestAudit(req),
            user_id: BigInt((req as AuthenticatedRequest).user!.id),
            action: "delete",
            entity_type: "vehicle",
            entity_id: id,

            old_values: {
              vehicle_code: existingVehicle.vehicle_code,
              title: existingVehicle.title,
              year: existingVehicle.year,
              price: existingVehicle.price.toString(),
              status: existingVehicle.status,
              vehicle_condition: existingVehicle.vehicle_condition,
              is_featured: existingVehicle.is_featured,
              deleted_at: null,
            },

            new_values: {
              deleted_at: deletedAt.toISOString(),
            },
          },
        });
      });

      return res.status(200).json({
        success: true,
        message: "Kendaraan berhasil dihapus",
      });
    } catch (error) {
      console.error("Delete vehicle error:", error);

      return res.status(500).json({
        success: false,
        message: "Gagal menghapus kendaraan",
      });
    }
  }
);

export default router;
