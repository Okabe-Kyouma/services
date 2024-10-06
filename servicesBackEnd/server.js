const express = require("express");

const app = express();

app.use(express.json);

app.use(express.static('public'));

app.use(express.json());

app.get("/", (req, res) => {
  res.send("hemlo");
});

app.listen(4000, () => {
  console.log("server started at port 4000");
});
