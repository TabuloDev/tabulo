import express from "express";
import Training from "../models/training.model.js";

const router = express.Router();

// POST /api/trainings
router.post("/", async (req, res) => {
  try {
    const training = new Training(req.body);
    await training.save();
    res.status(201).json(training);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

// GET /api/trainings/:id
router.get("/:id", async (req, res) => {
  try {
    const training = await Training.findById(req.params.id);
    if (!training) {
      return res.status(404).json({ message: "Entraînement non trouvé" });
    }
    res.json(training);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// GET /api/trainings?userId=...
router.get("/", async (req, res) => {
  try {
    const { userId } = req.query;
    if (!userId) {
      return res.status(400).json({ error: "Paramètre userId requis" });
    }

    const trainings = await Training.find({ userId }).sort({ finishedAt: -1 });
    res.status(200).json(trainings);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// GET /api/trainings/:userId/history
router.get("/:userId/history", async (req, res) => {
  try {
    const { userId } = req.params;

    const trainings = await Training.find({ userId }).sort({ finishedAt: -1 });

    res.status(200).json(trainings);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

export default router;
