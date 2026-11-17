
import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import helmet from "helmet";
import { prisma } from "./config/database.js";
import vehicleRoutes from "./routes/vehicle.routes.js";
import catalogRoutes from "./routes/catalog.routes.js";
import vehicleImageRoutes from "./routes/vehicle-image.routes.js";
import vehicleCostRoutes from "./routes/vehicle-cost.routes.js";
import transactionRoutes from "./routes/transaction.routes.js";
import profitRoutes from "./routes/profit.routes.js";
import testDriveRoutes from "./routes/test-drive.routes.js";
import authRoutes from "./routes/auth.routes.js";
import activityRoutes from "./routes/activity.routes.js";
import "./config/firebase.js";
import {
  verifyFirebaseToken,
  authorizeRoles,
  type AuthenticatedRequest,
} from "./middlewares/auth.middleware.js";
dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(helmet());
app.use(cors());
app.use(express.json());
app.use("/api/v1", authRoutes);
app.use("/api/v1/vehicles", vehicleRoutes);
app.use("/api/v1", catalogRoutes);
app.use("/api/v1", vehicleImageRoutes);
app.use("/api/v1", vehicleCostRoutes);
app.use("/api/v1", transactionRoutes);
app.use("/api/v1", profitRoutes);
app.use("/api/v1", testDriveRoutes);
app.use("/api/v1", activityRoutes);

// Test Firebase Authentication
app.get(
  "/api/v1/auth-test",
  verifyFirebaseToken,
  (req, res) => {
    const authReq = req as AuthenticatedRequest;

    res.status(200).json({
      success: true,
      message: "Autentikasi Firebase berhasil!",
      user: authReq.user,
    });
  }
);
// Health check
app.get("/api/v1/health", (req, res) => {
  res.status(200).json({
    success: true,
    message: "Backend SecondHand berhasil berjalan!",
    data: {
      status: "OK",
    },
  });
});

app.get("/api/v1/db-health", async (req, res) => {
  try {
    await prisma.$queryRaw`SELECT 1`;

    res.status(200).json({
      success: true,
      message: "Koneksi database SecondHand berhasil!",
      database: "db_secondhand",
    });
  } catch (error) {
    console.error("Database error:", error);

    res.status(500).json({
      success: false,
      message: "Koneksi database gagal!",
    });
  }
});

// Jalankan server
app.listen(PORT, () => {
  console.log(`================================`);
  console.log(`SecondHand Backend`);
  console.log(`Server berjalan di port ${PORT}`);
  console.log(`http://localhost:${PORT}/api/v1/health`);
  console.log(`================================`);
});

// Test akses khusus Customer
app.get(
  "/api/v1/auth-test/user",
  verifyFirebaseToken,
  authorizeRoles("user"),
  (req, res) => {
    const authReq = req as AuthenticatedRequest;

    res.status(200).json({
      success: true,
      message: "Akses Customer berhasil!",
      user: authReq.user,
    });
  }
);

// Test akses khusus Admin dan Owner
app.get(
  "/api/v1/auth-test/admin",
  verifyFirebaseToken,
  authorizeRoles("admin", "owner"),
  (req, res) => {
    const authReq = req as AuthenticatedRequest;

    res.status(200).json({
      success: true,
      message: "Akses Admin berhasil!",
      user: authReq.user,
    });
  }
);