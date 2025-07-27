import request from "supertest";
import mongoose from "mongoose";
import app from "../testApp.js";
import Training from "../models/training.model.js";

beforeAll(async () => {
  await mongoose.connect("mongodb://localhost:27017/tabulo_test", {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  });
});

afterEach(async () => {
  await Training.deleteMany();
});

afterAll(async () => {
  await mongoose.connection.close();
});

describe("POST /api/trainings", () => {
  it("sauvegarde un entraînement avec succès", async () => {
    const trainingData = {
      selectedTables: [3, 4],
      operations: [
        {
          expression: "3×4",
          userAnswer: "12",
          isCorrect: true,
        },
        {
          expression: "4×5",
          userAnswer: "19",
          isCorrect: false,
          correction: "20",
        },
      ],
      score: 5.0,
      finishedAt: new Date(),
    };

    const response = await request(app)
      .post("/api/trainings")
      .send(trainingData);

    expect(response.status).toBe(201);
    expect(response.body.selectedTables).toEqual([3, 4]);
    expect(response.body.score).toBe(5.0);
  });
});
