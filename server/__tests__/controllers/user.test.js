const bcrypt = require("bcrypt");
const pool = require("../../config");
const supertest = require("supertest");
const app = require("../../app");
const api = supertest(app);
const jwt = require("jsonwebtoken");
const { usersInDb } = require("../../helpers/test_helper");

let adminAuth = {};
let customerAuth = {};

beforeEach(async () => {
  // Clear data safely
  await pool.query("TRUNCATE TABLE users CASCADE");

  const hashedPassword = await bcrypt.hash("secret", 1);

  // FIX BUG 1: Insert roles formatted as a Postgres Array '{role}'
  await pool.query(
    "INSERT INTO users(username, password, email, fullname, roles) VALUES($1, $2, $3, $4, $5) returning user_id",
    ["admin", hashedPassword, "admin@email.com", "admin", "{admin}"]
  );

  await pool.query(
    "INSERT INTO users(username, password, email, fullname, roles) VALUES($1, $2, $3, $4, $5) returning user_id",
    ["customer", hashedPassword, "customer@email.com", "customer", "{customer}"]
  );

  const adminLogin = await api.post("/api/auth/login").send({
    email: "admin@email.com",
    password: "secret",
  });
  const customerLogin = await api.post("/api/auth/login").send({
    email: "customer@email.com",
    password: "secret",
  });

  adminAuth.token = adminLogin.body.token;
  customerAuth.token = customerLogin.body.token;

  // Extract ID gracefully
  const decodedAdmin = jwt.decode(adminAuth.token);
  const decodedCustomer = jwt.decode(customerAuth.token);
  adminAuth.user_id = decodedAdmin
    ? decodedAdmin.id || decodedAdmin.user_id
    : null;
  customerAuth.user_id = decodedCustomer
    ? decodedCustomer.id || decodedCustomer.user_id
    : null;
});

afterEach(async () => {
  await pool.query("TRUNCATE TABLE users CASCADE");
});

describe("User controller", () => {
  describe("Add new user", () => {
    it("should create a new user if user is an admin", async () => {
      const usersAtStart = await usersInDb();
      const response = await api
        .post("/api/users")
        .send({
          fullname: "John Doe",
          password: "my_strong_password",
          username: "johnny",
          email: "johndoe@email.com",
        })
        .expect(201)
        .set("auth-token", adminAuth.token);

      const usersAtEnd = await api
        .get("/api/users")
        .set("auth-token", adminAuth.token);

      expect(response.body).toHaveProperty("status", "success");
      expect(response.body).toHaveProperty("user");
      expect(response.body.user).not.toHaveProperty("password");
      expect(usersAtEnd.body).toHaveLength(usersAtStart.length + 1);
    });

    it("should not create a new user if user is not an admin", async () => {
      const usersAtStart = await usersInDb();
      const response = await api
        .post("/api/users")
        .send({
          fullname: "John Doe",
          password: "my_strong_password",
          username: "johnny2",
          email: "johndoe2@email.com",
        })
        .expect(401)
        .set("auth-token", customerAuth.token);

      const usersAtEnd = await api
        .get("/api/users")
        .set("auth-token", adminAuth.token);

      expect(response.body).toHaveProperty("status", "error");
      expect(response.body.message).toMatch(/require admin role/i);
      expect(usersAtEnd.body).toHaveLength(usersAtStart.length);
    });
  });

  describe("Get user by id", () => {
    it("should return a user if user is an admin", async () => {
      const response = await api
        .get(`/api/users/${customerAuth.user_id}`)
        .expect(200)
        .set("auth-token", adminAuth.token);

      expect(response.body).toHaveProperty("username");
      expect(response.body).toHaveProperty("email");
      expect(response.body).not.toHaveProperty("password");
    });

    it("should return user if user is authorized", async () => {
      const response = await api
        .get(`/api/users/${customerAuth.user_id}`)
        .expect(200)
        .set("auth-token", customerAuth.token);

      expect(response.body).toHaveProperty("username");
      expect(response.body).toHaveProperty("email");
    });

    it("should not return user if user is not an admin or authorized", async () => {
      // Create a fresh user via API to avoid constraint errors
      await api.post("/api/auth/signup").send({
        email: "anotherCustomer@email.com",
        password: "secret",
        fullname: "test db",
        username: "another_test",
      });

      const anotherCustomer = await api.post("/api/auth/login").send({
        email: "anotherCustomer@email.com",
        password: "secret",
      });

      const response = await api
        .get(`/api/users/${customerAuth.user_id}`)
        .expect(401)
        .set("auth-token", anotherCustomer.body.token);

      expect(response.body).toHaveProperty("status", "error");
      expect(response.body.message).toMatch(/Unauthorized/i);
    });
  });

  describe("Get all users", () => {
    it("should return all users in database if user is an admin", async () => {
      const initialUsers = await usersInDb();
      const response = await api
        .get("/api/users")
        .expect(200)
        .set("auth-token", adminAuth.token);
      expect(response.body).toHaveLength(initialUsers.length);
    });

    it("should not return all users in database if user is not an admin", async () => {
      const response = await api
        .get("/api/users")
        .expect(401)
        .set("auth-token", customerAuth.token);
      expect(response.body).toHaveProperty("status", "error");
    });
  });

  describe("Update user", () => {
    it("should update a user if user is an admin", async () => {
      const usersAtStart = await usersInDb();
      const targetUser = usersAtStart.find((u) => u.username === "customer");

      const response = await api
        .put(`/api/users/${targetUser.user_id}`)
        .set("auth-token", adminAuth.token)
        .send({
          username: "newUsername",
          email: "newEmail@email.com",
          fullname: "new man",
        })
        .expect(201);

      expect(response.body).toHaveProperty("username", "newUsername");
      expect(response.body).toHaveProperty("email", "newEmail@email.com");
    });

    it("should update a user if user is authorized", async () => {
      const usersAtStart = await usersInDb();
      const targetUser = usersAtStart.find((u) => u.username === "customer");

      const response = await api
        .put(`/api/users/${targetUser.user_id}`)
        .set("auth-token", customerAuth.token)
        .send({
          username: "newcustUsername",
          email: "newcustEmail@email.com",
          fullname: "new man",
        })
        .expect(201);

      expect(response.body).toHaveProperty("username", "newcustUsername");
    });

    it("should return error if user is not authorized", async () => {
      const usersAtStart = await usersInDb();
      const targetUser = usersAtStart.find((u) => u.username === "admin");

      await api
        .put(`/api/users/${targetUser.user_id}`)
        .set("auth-token", customerAuth.token)
        .send({ username: "hack", email: "hack@email.com" })
        .expect(401);
    });
  });

  describe("delete user", () => {
    it("should delete a user if user is an admin", async () => {
      const usersAtStart = await usersInDb();
      const targetUser = usersAtStart.find((u) => u.username === "customer");

      await api
        .delete(`/api/users/${targetUser.user_id}`)
        .set("auth-token", adminAuth.token)
        .expect(200);

      const usersAtEnd = await usersInDb();
      expect(usersAtEnd).toHaveLength(usersAtStart.length - 1);
    });

    it("should delete a user if user is authorized", async () => {
      const usersAtStart = await usersInDb();
      const targetUser = usersAtStart.find((u) => u.username === "customer");

      await api
        .delete(`/api/users/${targetUser.user_id}`)
        .set("auth-token", customerAuth.token)
        .expect(200);

      const usersAtEnd = await usersInDb();
      expect(usersAtEnd).toHaveLength(usersAtStart.length - 1);
    });

    it("should return error if user is not authorized", async () => {
      const usersAtStart = await usersInDb();
      const targetAdmin = usersAtStart.find((u) => u.username === "admin");

      await api
        .delete(`/api/users/${targetAdmin.user_id}`)
        .set("auth-token", customerAuth.token)
        .expect(401);
    });
  });
});

afterAll(async () => {
  await pool.end();
});
