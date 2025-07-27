import request from "supertest";
import mongoose from "mongoose";
import app from "../index.js";
import Training from "../models/training.model.js";

beforeAll(async () => {
  await mongoose.connect("mongodb://localhost:27017/tabulo_test");
});

afterEach(async () => {
  await Training.deleteMany();
});

afterAll(async () => {
  await mongoose.connection.close();
});

describe("POST /api/trainings", () => {
  it("sauvegarde un entraînement avec succès", async () => {
    const newTraining = {
      score: 9.5,
      finishedAt: new Date(),
      operations: [
        {
          expression: "6 x 7",
          userAnswer: "42",
          isCorrect: true,
        },
      ],
    };

    const res = await request(app)
      .post("/api/trainings")
      .send(newTraining)
      .expect(201);

    expect(res.body._id).toBeDefined();
    expect(res.body.score).toBe(9.5);
    expect(res.body.operations.length).toBe(1);
  });
});

describe("GET /api/trainings/:id", () => {
  it("récupère un entraînement par ID", async () => {
    const savedTraining = await Training.create({
      score: 8.2,
      finishedAt: new Date(),
      operations: [
        {
          expression: "4 x 5",
          userAnswer: "20",
          isCorrect: true,
        },
      ],
    });

    const res = await request(app)
      .get(`/api/trainings/${savedTraining._id}`)
      .expect(200);

    expect(res.body._id).toBe(savedTraining._id.toString());
    expect(res.body.score).toBeCloseTo(8.2);
    expect(res.body.operations[0].expression).toBe("4 x 5");
  });
});
