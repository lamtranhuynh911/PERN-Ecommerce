require("dotenv").config();
const { Pool } = require("pg");

const isProduction = process.env.NODE_ENV === "production";
const isTest = process.env.NODE_ENV === "test";

let connectionString;

// 1. Determine the connection string based on the environment
if (isTest) {
  if (!process.env.TEST_DB_URL) {
    throw new Error(
      "TEST_DB_URL environment variable is missing in test environment!"
    );
  }
  connectionString = process.env.TEST_DB_URL;
} else {
  const PWD = encodeURIComponent(process.env.POSTGRES_PASSWORD);
  const database = process.env.POSTGRES_DB;
  connectionString = `postgresql://${process.env.POSTGRES_USER}:${PWD}@${process.env.POSTGRES_HOST}:${process.env.POSTGRES_PORT}/${database}`;
}

// 2. Initialize the connection pool
const pool = new Pool({
  connectionString,
  ssl: isProduction ? { rejectUnauthorized: false } : false,
});

module.exports = {
  query: (text, params) => pool.query(text, params),
  end: () => pool.end(),
};
