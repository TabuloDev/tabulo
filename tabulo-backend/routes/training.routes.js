import express from "express";
import Training from "../models/training.model.js";

const router = express.Router();

// POST /api/trainings
router.post("/", async (req, res) => {
  try {
    const training = new Training(req.body);
    const saved = await training.save();
    res.status(201).json(saved);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

export default router;
