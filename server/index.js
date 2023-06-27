const express = require("express");
const mongoose = require("mongoose");

const authRouter = require("./routes/auth.js");

const PORT = 3000;
const app = express();
const DB = "mongodb+srv://areebasgar02:areeb123@cluster0.gjigh5h.mongodb.net/?retryWrites=true&w=majority";

app.use(express.json());
app.use(authRouter);
mongoose
  .connect(DB)
  .then(() => {
    console.log("Connection Successful");
  })
  .catch((e) => {
    console.log(e);
  });

app.get("/hello-world", (req, res) => {
    res.send("Hello World ");
})

app.listen(PORT ,"0.0.0.0", () => {
    console.log(`Connected at port ${PORT}`);
})