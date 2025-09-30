import express from "express";
import bodyParser from "body-parser";
import { MongoClient } from "mongodb";

const app = express();
const port = process.env.PORT || 3000;

// Middleware
app.use(bodyParser.json());

// MongoDB connection
const mongoUri = process.env.MONGODB_URI || //add mongo uri here;
const client = new MongoClient(mongoUri);

let db, stepsCollection;

async function connectToMongo() {
  try {
    await client.connect();
    db = client.db("stepsDB"); // database name
    stepsCollection = db.collection("step_logs"); // collection name
    console.log("✅ Connected to MongoDB successfully");
  } catch (err) {
    console.error("❌ Error connecting to MongoDB:", err);
  }
}

connectToMongo();

// Endpoint to receive steps
app.post("/steps", async (req, res) => {
  try {
    const { date, steps } = req.body; // Expect JSON like { "date": "2025-09-27", "steps": 4567 }

    if (!date || !steps) {
      return res.status(400).json({ error: "Missing date or steps" });
    }

    await stepsCollection.insertOne({ date, steps });

    res.status(201).json({ message: "Steps saved successfully" });
  } catch (error) {
    console.error("Error saving steps:", error);
    res.status(500).json({ error: "Server error" });
  }
});

// Endpoint to fetch steps
app.get("/steps", async (req, res) => {
  try {
    const result = await stepsCollection.find().sort({ date: -1 }).toArray();
    res.json(result);
  } catch (error) {
    console.error("Error fetching steps:", error);
    res.status(500).json({ error: "Server error" });
  }
});

// Start server
app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
