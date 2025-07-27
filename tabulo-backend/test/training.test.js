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
      userId: "user123",
      score: 9.5,
      finishedAt: new Date(),
      selectedTables: [6, 7],
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
    expect(res.body.userId).toBe("user123");
  });
});

describe("GET /api/trainings/:id", () => {
  it("récupère un entraînement par ID", async () => {
    const savedTraining = await Training.create({
      userId: "user456",
      score: 8.2,
      finishedAt: new Date(),
      selectedTables: [4, 5],
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
    expect(res.body.userId).toBe("user456");
  });
});

describe("GET /api/trainings?userId=", () => {
  it("récupère tous les entraînements d'un utilisateur donné", async () => {
    const userId = "user789";

    await Training.create([
      {
        userId,
        score: 7.5,
        finishedAt: new Date(),
        selectedTables: [2, 3],
        operations: [
          {
            expression: "2 x 3",
            userAnswer: "6",
            isCorrect: true,
          },
        ],
      },
      {
        userId,
        score: 10,
        finishedAt: new Date(),
        selectedTables: [9],
        operations: [
          {
            expression: "9 x 1",
            userAnswer: "9",
            isCorrect: true,
          },
        ],
      },
    ]);

    const res = await request(app)
      .get(`/api/trainings?userId=${userId}`)
      .expect(200);

    expect(res.body).toHaveLength(2);
    res.body.forEach((t) => {
      expect(t.userId).toBe(userId);
    });
  });
});
