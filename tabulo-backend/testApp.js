import express from "express";
import cors from "cors";
import trainingRoutes from "./routes/training.routes.js";

const app = express();
app.use(cors());
app.use(express.json());
app.use("/api/trainings", trainingRoutes);

export default app;
