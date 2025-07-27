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

if (process.env.NODE_ENV !== "test") {
  mongoose
    .connect(process.env.MONGO_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    })
    .then(() => {
      app.listen(PORT, () => {
        console.log(`✅ Backend running on port ${PORT}`);
      });
    })
    .catch((err) => {
      console.error("❌ MongoDB connection error:", err.message);
    });
}

// 👇 Exporter l'application pour les tests
export default app;
