const supertest = require("supertest");
const app = require("../../app");
const api = supertest(app);
const pool = require("../../config");

beforeEach(async () => {
  // Use TRUNCATE CASCADE to clean all related tables (like cart) automatically
  await pool.query("TRUNCATE TABLE users CASCADE");
});

describe("/api/auth/signup", () => {
  it("should create an account for user", async () => {
    const res = await api.post("/api/auth/signup").send({
      email: "email@email.com",
      password: "secret",
      fullname: "test db",
      username: "test",
    });

    expect(res.statusCode).toBe(201);
    expect(res.body).toHaveProperty("token");
    expect(res.body).toHaveProperty("user");
    expect(res.body.user).toHaveProperty("user_id");
  });

  describe("return error if username or email is taken", () => {
    beforeEach(async () => {
      await pool.query("TRUNCATE TABLE users CASCADE");
      // FIX BUG 3: Create user using API so that related tables (Cart) are created correctly
      await api.post("/api/auth/signup").send({
        email: "email@email.com",
        password: "secret",
        fullname: "test db",
        username: "test",
      });
    });

    it("should return error if username is taken", async () => {
      const res = await api
        .post("/api/auth/signup")
        .send({
          email: "odunsiolakunbi@yahoo.com",
          password: "secret",
          fullname: "test db",
          username: "test", // existing username
        })
        .expect(401);

      expect(res.body).toHaveProperty("status", "error");
      expect(res.body.message).toMatch(/username taken/i);
    });

    it("should return error if email is taken", async () => {
      const res = await api
        .post("/api/auth/signup")
        .send({
          email: "email@email.com", // existing email
          password: "secret",
          fullname: "test db",
          username: "newtest",
        })
        .expect(401);

      expect(res.body).toHaveProperty("status", "error");
      expect(res.body.message).toMatch(/email taken/i);
    });
  });
});

describe("/api/auth/login", () => {
  beforeEach(async () => {
    await pool.query("TRUNCATE TABLE users CASCADE");
    // Ensure user is created properly before trying to log in
    await api.post("/api/auth/signup").send({
      email: "email@email.com",
      password: "secret",
      fullname: "test db",
      username: "test",
    });
  });

  it("should login a user", async () => {
    const res = await api
      .post("/api/auth/login")
      .send({ email: "email@email.com", password: "secret" })
      .expect(200);

    expect(res.body).toHaveProperty("token");
    expect(res.body).toHaveProperty("user");
  });

  it("should return error if invalid credentials is entered", async () => {
    const res = await api
      .post("/api/auth/login")
      .send({ email: "wrong@email.com", password: "wrongpassword" })
      .expect(403);

    expect(res.body).toHaveProperty("status", "error");
  });
});

afterAll(async () => {
  await pool.end();
});
