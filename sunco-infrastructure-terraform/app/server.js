const express = require("express");

const app = express();

const PORT = process.env.PORT || 8080;

app.get("/", (req, res) => {
  res.json({
    application: "Sunco",
    message: "Sunco application is running",
    environment: process.env.ENVIRONMENT || "development"
  });
});

app.get("/health", (req, res) => {
  res.status(200).json({
    status: "healthy"
  });
});

app.listen(PORT, "0.0.0.0", () => {
  console.log(`Sunco application listening on port ${PORT}`);
});
