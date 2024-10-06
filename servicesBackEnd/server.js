const express = require("express");
const connectMongo = require("./database/db");

const app = express();


connectMongo();


app.use(express.json());


app.get("/", (req, res) => {
  res.send("hemlo");

});

app.listen(4000, () => {
  console.log("server started at port 4000");
});
