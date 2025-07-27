import mongoose from "mongoose";

const operationSchema = new mongoose.Schema({
  expression: { type: String, required: true },
  userAnswer: { type: String, required: true },
  isCorrect: { type: Boolean, required: true },
  correction: { type: String, required: false },
});

const trainingSchema = new mongoose.Schema({
  userId: { type: String, required: true },
  selectedTables: { type: [Number], required: true },
  operations: { type: [operationSchema], required: true },
  score: { type: Number, required: true },
  finishedAt: { type: Date, required: true },
});

export default mongoose.model("Training", trainingSchema);
