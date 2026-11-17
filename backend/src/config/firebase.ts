import { readFileSync } from "node:fs";
import { resolve } from "node:path";
import {
  cert,
  getApps,
  initializeApp,
} from "firebase-admin/app";
import { getAuth } from "firebase-admin/auth";

// Membaca Firebase Service Account
const serviceAccountPath = resolve(
  process.cwd(),
  "serviceAccountKey.json"
);

const serviceAccount = JSON.parse(
  readFileSync(serviceAccountPath, "utf8")
);

// Inisialisasi Firebase Admin
const firebaseApp =
  getApps().length > 0
    ? getApps()[0]
    : initializeApp({
        credential: cert(serviceAccount),
      });

// Firebase Authentication
export const firebaseAuth = getAuth(firebaseApp);

console.log(
  "Firebase Admin berhasil diinisialisasi:",
  firebaseApp.name
);