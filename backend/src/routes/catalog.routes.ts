
import { Router } from "express";
import { prisma } from "../config/database.js";

const router = Router();

// Mengubah BigInt menjadi string agar aman untuk JSON
function serializeBigInt(value: any): any {
  if (typeof value === "bigint") {
    return value.toString();
  }

  if (Array.isArray(value)) {
    return value.map(serializeBigInt);
  }

  if (
    value !== null &&
    typeof value === "object" &&
    Object.getPrototypeOf(value) === Object.prototype
  ) {
    return Object.fromEntries(
      Object.entries(value).map(([key, val]) => [
        key,
        serializeBigInt(val),
      ])
    );
  }

  return value;
}

// ==========================================
// GET SEMUA KATEGORI
// GET /api/v1/categories
// ==========================================

router.get("/categories", async (_req, res) => {
  try {
    const categories = await prisma.categories.findMany({
      orderBy: {
        id: "asc",
      },
    });

    return res.status(200).json({
      success: true,
      message: "Data kategori berhasil diambil",
      total: categories.length,
      data: serializeBigInt(categories),
    });
  } catch (error) {
    console.error("Error mengambil kategori:", error);

    return res.status(500).json({
      success: false,
      message: "Gagal mengambil data kategori",
    });
  }
});

// ==========================================
// GET SEMUA MEREK
// GET /api/v1/brands
// ==========================================

router.get("/brands", async (_req, res) => {
  try {
    const brands = await prisma.brands.findMany({
      orderBy: {
        name: "asc",
      },
    });

    return res.status(200).json({
      success: true,
      message: "Data merek berhasil diambil",
      total: brands.length,
      data: serializeBigInt(brands),
    });
  } catch (error) {
    console.error("Error mengambil merek:", error);

    return res.status(500).json({
      success: false,
      message: "Gagal mengambil data merek",
    });
  }
});

// ==========================================
// GET SEMUA MODEL KENDARAAN
// GET /api/v1/models
// ==========================================

router.get("/models", async (req, res) => {
  try {

const pageInput =
  req.query.page === undefined ? "1" : req.query.page;

const limitInput =
  req.query.limit === undefined ? "50" : req.query.limit;

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

// Pastikan nilai skip masih aman untuk JavaScript
if (!Number.isSafeInteger(skip)) {
  return res.status(400).json({
    success: false,
    message: "Parameter page terlalu besar",
  });
}



const categoryInput = req.query.category;
const brandIdRaw = req.query.brandId;
const searchInput = req.query.search;

// Validasi category
if (
  categoryInput !== undefined &&
  (
    typeof categoryInput !== "string" ||
    categoryInput.length > 50 ||
    !/^[a-zA-Z0-9-]+$/.test(categoryInput.trim())
  )
) {
  return res.status(400).json({
    success: false,
    message: "Parameter category tidak valid",
  });
}

// Validasi brandId
if (
  brandIdRaw !== undefined &&
  (
    typeof brandIdRaw !== "string" ||
    !/^[1-9]\d*$/.test(brandIdRaw) ||
    !Number.isSafeInteger(Number(brandIdRaw))
  )
) {
  return res.status(400).json({
    success: false,
    message: "brandId harus berupa angka positif yang valid",
  });
}

// Validasi search
if (
  searchInput !== undefined &&
  (
    typeof searchInput !== "string" ||
    searchInput.length > 100
  )
) {
  return res.status(400).json({
    success: false,
    message: "Parameter search maksimal 100 karakter",
  });
}

const category =
  typeof categoryInput === "string" ? categoryInput.trim() : "";

const brandIdInput =
  typeof brandIdRaw === "string" ? brandIdRaw : "";

const search =
  typeof searchInput === "string" ? searchInput.trim() : "";


    const where: any = {};

    // Filter berdasarkan kategori
    if (category) {
      where.categories = {
        slug: category.toLowerCase(),
      };
    }

    // Filter berdasarkan merek
    if (brandIdInput) {
      if (!/^[1-9]\d*$/.test(brandIdInput)) {
        return res.status(400).json({
          success: false,
          message: "brandId harus berupa angka positif",
        });
      }

      where.brand_id = BigInt(brandIdInput);
    }

    // Pencarian nama model atau merek
    if (search) {
      where.OR = [
        {
          model_name: {
            contains: search,
          },
        },
        {
          brands: {
            name: {
              contains: search,
            },
          },
        },
      ];
    }

    const [models, total] = await Promise.all([
      prisma.vehicle_models.findMany({
        where,
        include: {
          brands: true,
          categories: true,
        },
        orderBy: {
          model_name: "asc",
        },
        skip,
        take: limit,
      }),

      prisma.vehicle_models.count({
        where,
      }),
    ]);

    return res.status(200).json({
      success: true,
      message: "Data model kendaraan berhasil diambil",
      pagination: {
        page,
        limit,
        total,
        totalPages: Math.ceil(total / limit),
      },
      filters: {
        category: category || null,
        brandId: brandIdInput || null,
        search: search || null,
      },
      data: serializeBigInt(models),
    });
  } catch (error) {
    console.error("Error mengambil model kendaraan:", error);

    return res.status(500).json({
      success: false,
      message: "Gagal mengambil data model kendaraan",
    });
  }
});

// ==========================================
// GET DETAIL MODEL KENDARAAN
// GET /api/v1/models/:id
// ==========================================

router.get("/models/:id", async (req, res) => {
  try {
    const id = req.params.id;


if (
  !/^[1-9]\d*$/.test(id) ||
  BigInt(id) > 18446744073709551615n
) {
  return res.status(400).json({
    success: false,
    message: "ID model tidak valid",
  });
}


    const model = await prisma.vehicle_models.findUnique({
      where: {
        id: BigInt(id),
      },
      include: {
        brands: true,
        categories: true,
      },
    });

    if (!model) {
      return res.status(404).json({
        success: false,
        message: "Model kendaraan tidak ditemukan",
      });
    }

    return res.status(200).json({
      success: true,
      message: "Detail model kendaraan berhasil diambil",
      data: serializeBigInt(model),
    });
  } catch (error) {
    console.error("Error mengambil detail model:", error);

    return res.status(500).json({
      success: false,
      message: "Gagal mengambil detail model kendaraan",
    });
  }
});

export default router;
