
import { Router, type Request } from "express";
import { prisma } from "../config/database.js";
import cloudinary from "../config/cloudinary.js";
import upload, {
  hasValidImageSignature,
} from "../middlewares/upload.middleware.js";
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
// HELPER
// ==========================================

// Mengubah BigInt menjadi string agar bisa dikirim sebagai JSON
function serializeBigInt(data: any): any {
  return JSON.parse(
    JSON.stringify(data, (_key, value) =>
      typeof value === "bigint" ? value.toString() : value
    )
  );
}

// Mengunci baris kendaraan selama transaksi.
// Semua endpoint yang mengubah foto harus menggunakan lock ini.
async function lockActiveVehicle(tx: any, vehicleId: bigint) {
  const vehicles = await tx.$queryRaw<Array<{ id: bigint }>>`
    SELECT id
    FROM vehicles
    WHERE id = ${vehicleId}
      AND deleted_at IS NULL
    FOR UPDATE
  `;

  return vehicles.length > 0;
}

// ==========================================
// UPLOAD GAMBAR KE CLOUDINARY
// ==========================================

function uploadToCloudinary(
  file: Express.Multer.File,
  vehicleId: number
): Promise<{
  url: string;
  public_id: string;
}> {
  return new Promise((resolve, reject) => {
    const stream = cloudinary.uploader.upload_stream(
      {
        folder: `secondhand/vehicles/${vehicleId}`,
        resource_type: "image",
      },
      (error, result) => {
        if (error || !result) {
          return reject(error || new Error("Upload gagal"));
        }

        resolve({
          url: result.secure_url,
          public_id: result.public_id,
        });
      }
    );

    stream.end(file.buffer);
  });
}

// ==========================================
// HAPUS FILE DARI CLOUDINARY
// ==========================================

async function deleteCloudinaryImage(publicId: string) {
  return cloudinary.uploader.destroy(publicId, {
    resource_type: "image",
  });
}

// ==========================================
// UPLOAD FOTO KENDARAAN
// POST /api/v1/vehicles/:vehicleId/images/upload
// ==========================================

router.post(
  "/vehicles/:vehicleId/images/upload",
  verifyFirebaseToken,
  authorizeRoles("admin", "owner"),
  (req, res, next) => {
    upload.array("images", 10)(req, res, (error) => {
      if (error) {
        return res.status(400).json({
          success: false,
          message: error.message,
        });
      }

      const files = req.files as Express.Multer.File[];

      const invalidFile = files?.some(
        (file) => !hasValidImageSignature(file)
      );

      if (invalidFile) {
        return res.status(400).json({
          success: false,
          message:
            "File tidak valid. Pastikan file benar-benar gambar JPG, PNG, atau WebP.",
        });
      }

      next();
    });
  },
  async (req, res) => {
    const uploadedImages: {
      url: string;
      public_id: string;
    }[] = [];

    try {
      const vehicleId = Number(req.params.vehicleId);

      if (!Number.isSafeInteger(vehicleId) || vehicleId <= 0) {
        return res.status(400).json({
          success: false,
          message: "ID kendaraan tidak valid",
        });
      }

      const vehicle = await prisma.vehicles.findFirst({
        where: {
          id: BigInt(vehicleId),
          deleted_at: null,
        },
      });

      if (!vehicle) {
        return res.status(404).json({
          success: false,
          message: "Kendaraan tidak ditemukan",
        });
      }

      const files = req.files as Express.Multer.File[];

      if (!files || files.length === 0) {
        return res.status(400).json({
          success: false,
          message: "Pilih minimal satu foto untuk diupload",
        });
      }

      // Upload gambar ke Cloudinary
      for (const file of files) {
        const uploaded = await uploadToCloudinary(file, vehicleId);
        uploadedImages.push(uploaded);
      }

      // Simpan foto dan Activity Logs dalam satu transaksi
      const savedImages = await prisma.$transaction(async (tx) => {
        const vehicleLocked = await lockActiveVehicle(
          tx,
          BigInt(vehicleId)
        );

        if (!vehicleLocked) {
          throw new Error("VEHICLE_NOT_FOUND");
        }

        // Hitung ulang setelah lock diperoleh
        const existingImages = await tx.vehicle_images.findMany({
          where: {
            vehicle_id: BigInt(vehicleId),
          },
          orderBy: [
            { sort_order: "desc" },
            { id: "desc" },
          ],
          take: 1,
        });

        const imageCount = await tx.vehicle_images.count({
          where: {
            vehicle_id: BigInt(vehicleId),
          },
        });

        const startOrder =
          existingImages.length > 0
            ? existingImages[0].sort_order + 1
            : 0;

        const result = [];

        for (let i = 0; i < uploadedImages.length; i++) {
          const uploaded = uploadedImages[i];

          const newImage = await tx.vehicle_images.create({
            data: {
              vehicle_id: BigInt(vehicleId),
              image_url: uploaded.url,
              public_id: uploaded.public_id,
              is_primary: imageCount === 0 && i === 0,
              sort_order: startOrder + i,
            },
          });

          await tx.activity_logs.create({
data: {
  ...getRequestAudit(req),
  user_id: BigInt(
                (req as AuthenticatedRequest).user!.id
              ),
              action: "create",
              entity_type: "vehicle_image",
              entity_id: newImage.id,
              new_values: {
                vehicle_id: vehicleId.toString(),
                image_url: newImage.image_url,
                public_id: newImage.public_id,
                is_primary: newImage.is_primary,
                sort_order: newImage.sort_order,
              },
            },
          });

          result.push(newImage);
        }

        return result;
      });

      return res.status(201).json({
        success: true,
        message: "Foto kendaraan berhasil diupload",
        total_uploaded: savedImages.length,
        data: serializeBigInt(savedImages),
      });
    } catch (error) {
      console.error("UPLOAD vehicle images error:", error);

      // Bersihkan file Cloudinary jika transaksi gagal
      for (const image of uploadedImages) {
        try {
          await deleteCloudinaryImage(image.public_id);
        } catch (deleteError) {
          console.error(
            "Gagal membersihkan gambar Cloudinary:",
            deleteError
          );
        }
      }

      if (
        error instanceof Error &&
        error.message === "VEHICLE_NOT_FOUND"
      ) {
        return res.status(404).json({
          success: false,
          message: "Kendaraan tidak ditemukan",
        });
      }

      return res.status(500).json({
        success: false,
        message: "Gagal mengupload foto kendaraan",
      });
    }
  }
);

// ==========================================
// GET FOTO KENDARAAN
// GET /api/v1/vehicles/:vehicleId/images
// ==========================================

router.get(
  "/vehicles/:vehicleId/images",
  async (req, res) => {
    try {
      const vehicleId = Number(req.params.vehicleId);

      if (!Number.isSafeInteger(vehicleId) || vehicleId <= 0) {
        return res.status(400).json({
          success: false,
          message: "ID kendaraan tidak valid",
        });
      }

      const vehicle = await prisma.vehicles.findFirst({
        where: {
          id: BigInt(vehicleId),
          deleted_at: null,
        },
      });

      if (!vehicle) {
        return res.status(404).json({
          success: false,
          message: "Kendaraan tidak ditemukan",
        });
      }

      const images = await prisma.vehicle_images.findMany({
        where: {
          vehicle_id: BigInt(vehicleId),
        },
        orderBy: [
          { is_primary: "desc" },
          { sort_order: "asc" },
          { id: "asc" },
        ],
      });

      return res.status(200).json({
        success: true,
        message: "Foto kendaraan berhasil diambil",
        data: serializeBigInt(images),
      });
    } catch (error) {
      console.error("GET vehicle images error:", error);

      return res.status(500).json({
        success: false,
        message: "Gagal mengambil foto kendaraan",
      });
    }
  }
);

// ==========================================
// POST TAMBAH FOTO DENGAN URL
// POST /api/v1/vehicles/:vehicleId/images
// ==========================================

router.post(
  "/vehicles/:vehicleId/images",
  verifyFirebaseToken,
  authorizeRoles("admin", "owner"),
  async (req, res) => {
    try {
      const vehicleId = Number(req.params.vehicleId);

      if (!Number.isSafeInteger(vehicleId) || vehicleId <= 0) {
        return res.status(400).json({
          success: false,
          message: "ID kendaraan tidak valid",
        });
      }

      const { image_url, is_primary, sort_order } = req.body;

      if (
        typeof image_url !== "string" ||
        image_url.trim() === "" ||
        image_url.trim().length > 500
      ) {
        return res.status(400).json({
          success: false,
          message: "URL foto wajib diisi dan maksimal 500 karakter",
        });
      }

      try {
        const parsedUrl = new URL(image_url.trim());

        if (!["http:", "https:"].includes(parsedUrl.protocol)) {
          throw new Error("URL tidak valid");
        }
      } catch {
        return res.status(400).json({
          success: false,
          message: "Format URL foto tidak valid",
        });
      }

      if (
        is_primary !== undefined &&
        typeof is_primary !== "boolean"
      ) {
        return res.status(400).json({
          success: false,
          message: "is_primary harus berupa boolean",
        });
      }

      const finalSortOrder =
        sort_order === undefined ? 0 : sort_order;

      if (
        !Number.isInteger(finalSortOrder) ||
        finalSortOrder < 0 ||
        finalSortOrder > 4294967295
      ) {
        return res.status(400).json({
          success: false,
          message: "Urutan foto tidak valid",
        });
      }

      const newImage = await prisma.$transaction(async (tx) => {
        const vehicleLocked = await lockActiveVehicle(
          tx,
          BigInt(vehicleId)
        );

        if (!vehicleLocked) {
          return null;
        }

        // Hitung setelah lock diperoleh
        const imageCount = await tx.vehicle_images.count({
          where: {
            vehicle_id: BigInt(vehicleId),
          },
        });

        const shouldBePrimary =
          is_primary === true || imageCount === 0;

        if (shouldBePrimary) {
          const oldPrimaryImages = await tx.vehicle_images.findMany({
            where: {
              vehicle_id: BigInt(vehicleId),
              is_primary: true,
            },
          });

          await tx.vehicle_images.updateMany({
            where: {
              vehicle_id: BigInt(vehicleId),
            },
            data: {
              is_primary: false,
            },
          });

          for (const oldImage of oldPrimaryImages) {
            await tx.activity_logs.create({
              data: {
                ...getRequestAudit(req),
                user_id: BigInt(
                  (req as AuthenticatedRequest).user!.id
                ),
                action: "update",
                entity_type: "vehicle_image",
                entity_id: oldImage.id,
                old_values: {
                  is_primary: true,
                },
                new_values: {
                  is_primary: false,
                },
              },
            });
          }
        }

        const createdImage = await tx.vehicle_images.create({
          data: {
            vehicle_id: BigInt(vehicleId),
            image_url: image_url.trim(),
            public_id: null,
            is_primary: shouldBePrimary,
            sort_order: finalSortOrder,
          },
        });

        await tx.activity_logs.create({
          data: {
            ...getRequestAudit(req),
            user_id: BigInt(
              (req as AuthenticatedRequest).user!.id
            ),
            action: "create",
            entity_type: "vehicle_image",
            entity_id: createdImage.id,
            new_values: {
              vehicle_id: vehicleId.toString(),
              image_url: createdImage.image_url,
              public_id: createdImage.public_id,
              is_primary: createdImage.is_primary,
              sort_order: createdImage.sort_order,
            },
          },
        });

        return createdImage;
      });

      if (!newImage) {
        return res.status(404).json({
          success: false,
          message: "Kendaraan tidak ditemukan",
        });
      }

      return res.status(201).json({
        success: true,
        message: "Foto kendaraan berhasil ditambahkan",
        data: serializeBigInt(newImage),
      });
    } catch (error) {
      console.error("POST vehicle image error:", error);

      return res.status(500).json({
        success: false,
        message: "Gagal menambahkan foto kendaraan",
      });
    }
  }
);

// ==========================================
// PATCH UPDATE FOTO KENDARAAN
// PATCH /api/v1/vehicle-images/:imageId
// ==========================================

router.patch(
  "/vehicle-images/:imageId",
  verifyFirebaseToken,
  authorizeRoles("admin", "owner"),
  async (req, res) => {
    try {
      const imageId = Number(req.params.imageId);

      if (!Number.isSafeInteger(imageId) || imageId <= 0) {
        return res.status(400).json({
          success: false,
          message: "ID foto tidak valid",
        });
      }

      const existingImage = await prisma.vehicle_images.findUnique({
        where: {
          id: BigInt(imageId),
        },
      });

      if (!existingImage) {
        return res.status(404).json({
          success: false,
          message: "Foto kendaraan tidak ditemukan",
        });
      }

      const { is_primary, sort_order } = req.body;

      if (
        is_primary === undefined &&
        sort_order === undefined
      ) {
        return res.status(400).json({
          success: false,
          message: "Tidak ada data yang ingin diperbarui",
        });
      }

      if (
        is_primary !== undefined &&
        typeof is_primary !== "boolean"
      ) {
        return res.status(400).json({
          success: false,
          message: "is_primary harus berupa boolean",
        });
      }

      if (
        sort_order !== undefined &&
        (
          !Number.isInteger(sort_order) ||
          sort_order < 0 ||
          sort_order > 4294967295
        )
      ) {
        return res.status(400).json({
          success: false,
          message: "Urutan foto tidak valid",
        });
      }

      const result = await prisma.$transaction(async (tx) => {
        const vehicleLocked = await lockActiveVehicle(
          tx,
          existingImage.vehicle_id
        );

        if (!vehicleLocked) {
          return { status: "not_found" as const };
        }

        // Ambil ulang foto setelah lock diperoleh
        const currentImage = await tx.vehicle_images.findUnique({
          where: {
            id: BigInt(imageId),
          },
        });

        if (!currentImage) {
          return { status: "not_found" as const };
        }

        // Foto utama tidak boleh dinonaktifkan langsung
        if (
          is_primary === false &&
          currentImage.is_primary === true
        ) {
          return { status: "primary_blocked" as const };
        }

        if (is_primary === true) {
          const oldPrimaryImages = await tx.vehicle_images.findMany({
            where: {
              vehicle_id: currentImage.vehicle_id,
              is_primary: true,
              id: {
                not: BigInt(imageId),
              },
            },
          });

          await tx.vehicle_images.updateMany({
            where: {
              vehicle_id: currentImage.vehicle_id,
              is_primary: true,
              id: {
                not: BigInt(imageId),
              },
            },
            data: {
              is_primary: false,
            },
          });

          for (const oldImage of oldPrimaryImages) {
            await tx.activity_logs.create({
              data: {
                ...getRequestAudit(req),
                user_id: BigInt(
                  (req as AuthenticatedRequest).user!.id
                ),
                action: "update",
                entity_type: "vehicle_image",
                entity_id: oldImage.id,
                old_values: {
                  is_primary: true,
                },
                new_values: {
                  is_primary: false,
                },
              },
            });
          }
        }

        const updated = await tx.vehicle_images.update({
          where: {
            id: BigInt(imageId),
          },
          data: {
            ...(is_primary !== undefined && { is_primary }),
            ...(sort_order !== undefined && { sort_order }),
          },
        });

        await tx.activity_logs.create({
          data: {
            ...getRequestAudit(req),
            user_id: BigInt(
              (req as AuthenticatedRequest).user!.id
            ),
            action: "update",
            entity_type: "vehicle_image",
            entity_id: updated.id,
            old_values: {
              is_primary: currentImage.is_primary,
              sort_order: currentImage.sort_order,
            },
            new_values: {
              is_primary: updated.is_primary,
              sort_order: updated.sort_order,
            },
          },
        });

        return {
          status: "success" as const,
          image: updated,
        };
      });

      if (result.status === "not_found") {
        return res.status(404).json({
          success: false,
          message: "Kendaraan atau foto kendaraan tidak ditemukan",
        });
      }

      if (result.status === "primary_blocked") {
        return res.status(400).json({
          success: false,
          message:
            "Foto utama tidak bisa dinonaktifkan. Pilih foto lain sebagai foto utama terlebih dahulu.",
        });
      }

      return res.status(200).json({
        success: true,
        message: "Foto kendaraan berhasil diperbarui",
        data: serializeBigInt(result.image),
      });
    } catch (error) {
      console.error("PATCH vehicle image error:", error);

      return res.status(500).json({
        success: false,
        message: "Gagal memperbarui foto kendaraan",
      });
    }
  }
);

// ==========================================
// DELETE FOTO KENDARAAN
// DELETE /api/v1/vehicle-images/:imageId
// ==========================================

router.delete(
  "/vehicle-images/:imageId",
  verifyFirebaseToken,
  authorizeRoles("admin", "owner"),
  async (req, res) => {
    try {
      const imageId = Number(req.params.imageId);

      if (!Number.isSafeInteger(imageId) || imageId <= 0) {
        return res.status(400).json({
          success: false,
          message: "ID foto tidak valid",
        });
      }

      const existingImage = await prisma.vehicle_images.findUnique({
        where: {
          id: BigInt(imageId),
        },
      });

      if (!existingImage) {
        return res.status(404).json({
          success: false,
          message: "Foto kendaraan tidak ditemukan",
        });
      }

      const result = await prisma.$transaction(async (tx) => {
        const vehicleLocked = await lockActiveVehicle(
          tx,
          existingImage.vehicle_id
        );

        if (!vehicleLocked) {
          return null;
        }

        // Ambil ulang foto setelah lock diperoleh
        const currentImage = await tx.vehicle_images.findUnique({
          where: {
            id: BigInt(imageId),
          },
        });

        if (!currentImage) {
          return null;
        }

        await tx.vehicle_images.delete({
          where: {
            id: BigInt(imageId),
          },
        });

        await tx.activity_logs.create({
          data: {
            ...getRequestAudit(req),
            user_id: BigInt(
              (req as AuthenticatedRequest).user!.id
            ),
            action: "delete",
            entity_type: "vehicle_image",
            entity_id: currentImage.id,
            old_values: {
              vehicle_id: currentImage.vehicle_id.toString(),
              image_url: currentImage.image_url,
              public_id: currentImage.public_id,
              is_primary: currentImage.is_primary,
              sort_order: currentImage.sort_order,
            },
            new_values: {
              deleted: true,
            },
          },
        });

        let newPrimaryImage = null;

        // Jika foto yang dihapus adalah foto utama
        if (currentImage.is_primary) {
          const nextImage = await tx.vehicle_images.findFirst({
            where: {
              vehicle_id: currentImage.vehicle_id,
            },
            orderBy: [
              { sort_order: "asc" },
              { id: "asc" },
            ],
          });

          if (nextImage) {
            newPrimaryImage = await tx.vehicle_images.update({
              where: {
                id: nextImage.id,
              },
              data: {
                is_primary: true,
              },
            });

            await tx.activity_logs.create({
              data: {
                ...getRequestAudit(req),
                user_id: BigInt(
                  (req as AuthenticatedRequest).user!.id
                ),
                action: "update",
                entity_type: "vehicle_image",
                entity_id: newPrimaryImage.id,
                old_values: {
                  is_primary: false,
                },
                new_values: {
                  is_primary: true,
                },
              },
            });
          }
        }

        return {
          deletedImage: currentImage,
          newPrimaryImage,
        };
      });

      if (!result) {
        return res.status(404).json({
          success: false,
          message: "Kendaraan atau foto kendaraan tidak ditemukan",
        });
      }

      // Hapus file Cloudinary setelah transaksi database berhasil
      let cloudinaryDeleted = false;
      let cloudinaryWarning = null;

      if (result.deletedImage.public_id) {
        try {
          const cloudinaryResult = await deleteCloudinaryImage(
            result.deletedImage.public_id
          );

          cloudinaryDeleted =
            cloudinaryResult.result === "ok" ||
            cloudinaryResult.result === "not found";

          if (!cloudinaryDeleted) {
            cloudinaryWarning =
              "Data foto terhapus, tetapi file Cloudinary belum berhasil dihapus";
          }
        } catch (cloudinaryError) {
          console.error(
            "CLOUDINARY DELETE ERROR:",
            cloudinaryError
          );

          cloudinaryWarning =
            "Data foto terhapus, tetapi terjadi kesalahan saat menghapus file Cloudinary";
        }
      }

      return res.status(200).json({
        success: true,
        message: "Foto kendaraan berhasil dihapus",
        cloudinary_deleted: result.deletedImage.public_id
          ? cloudinaryDeleted
          : null,
        ...(cloudinaryWarning && {
          warning: cloudinaryWarning,
        }),
        data: {
          deleted_image_id: imageId.toString(),
          new_primary_image: serializeBigInt(
            result.newPrimaryImage
          ),
        },
      });
    } catch (error) {
      console.error("DELETE vehicle image error:", error);

      return res.status(500).json({
        success: false,
        message: "Gagal menghapus foto kendaraan",
      });
    }
  }
);

export default router;
