const express = require("express");
require("express-async-errors");
const cors = require("cors");
const morgan = require("morgan");
const cookieParser = require("cookie-parser");
const routes = require("./routes");
const helmet = require("helmet");
const compression = require("compression");
const unknownEndpoint = require("./middleware/unKnownEndpoint");
const { handleError } = require("./helpers/error");

const app = express();

app.set("trust proxy", 1);
app.use(cors({ credentials: true, origin: true }));
app.use(express.json());
app.use(morgan("dev"));
app.use(compression());
app.use(helmet());
app.use(cookieParser());

app.use("/api", routes);

app.get("/", (req, res) =>
  res.send("<h1 style='text-align: center'>E-COMMERCE API</h1>")
);

const db = require("./config");
// Express.js example
app.get("/health", async (req, res) => {
  try {
    // Truy vấn đơn giản nhất để check kết nối
    await db.query("SELECT 1");

    res.status(200).send("OK");
  } catch (err) {
    res.status(500).send("Database connection failed");
  }
});

app.use(unknownEndpoint);
app.use(handleError);

module.exports = app;
