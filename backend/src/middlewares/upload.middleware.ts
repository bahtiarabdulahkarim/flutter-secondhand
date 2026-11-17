
import multer from "multer";

// Format gambar yang diperbolehkan
const allowedMimeTypes = [
  "image/jpeg",
  "image/png",
  "image/webp",
];

// Memeriksa format asli berdasarkan signature file
export function hasValidImageSignature(
  file: Express.Multer.File
): boolean {
  const buffer = file.buffer;

  if (!buffer || buffer.length < 12) {
    return false;
  }

  // JPEG signature: FF D8 FF
  const isJpeg =
    buffer[0] === 0xff &&
    buffer[1] === 0xd8 &&
    buffer[2] === 0xff;

  // PNG signature
  const isPng = buffer
    .subarray(0, 8)
    .equals(
      Buffer.from([
        0x89, 0x50, 0x4e, 0x47,
        0x0d, 0x0a, 0x1a, 0x0a,
      ])
    );

  // WebP signature: RIFF....WEBP
  const isWebp =
    buffer.toString("ascii", 0, 4) === "RIFF" &&
    buffer.toString("ascii", 8, 12) === "WEBP";

  // Pastikan signature sesuai dengan MIME type
  return (
    (isJpeg && file.mimetype === "image/jpeg") ||
    (isPng && file.mimetype === "image/png") ||
    (isWebp && file.mimetype === "image/webp")
  );
}

// Konfigurasi upload
const upload = multer({
  storage: multer.memoryStorage(),

  limits: {
    fileSize: 5 * 1024 * 1024,
    files: 10,
  },

  fileFilter: (_req, file, cb) => {
    if (!allowedMimeTypes.includes(file.mimetype)) {
      return cb(
        new Error("Format gambar harus JPG, JPEG, PNG, atau WebP")
      );
    }

    cb(null, true);
  },
});

export default upload;
