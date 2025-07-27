// C:\tabulo\tabulo-backend\index.js
import express from "express";
import mongoose from "mongoose";
import dotenv from "dotenv";
import cors from "cors";

import trainingRoutes from "./routes/training.routes.js";

dotenv.config();

const app = express();
app.use(cors());
app.use(express.json());

app.use("/api/trainings", trainingRoutes);

const PORT = process.env.PORT || 5000;
const MONGO_URI = process.env.MONGO_URI || "mongodb://localhost:27017/tabulo";

// Connexion à MongoDB et démarrage du serveur
if (process.env.NODE_ENV !== "test") {
  mongoose
    .connect(MONGO_URI)
    .then(() => {
      console.log("✅ Connecté à MongoDB");
      app.listen(PORT, () => {
        console.log(`✅ Backend running on port ${PORT}`);
      });
    })
    .catch((err) => {
      console.error("❌ Erreur de connexion à MongoDB :", err.message);
      process.exit(1); // Arrêt en cas d’échec de connexion
    });
}

export default app;
