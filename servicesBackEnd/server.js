const express = require("express");
const connectMongo = require("./database/db");
const User = require("./database/data");
const passport = require("passport");
const { initializingPassport } = require("./passportConfig");
const expressSession = require("express-session");
const MongoStore = require("connect-mongo");
const bcrypt = require("bcrypt");
const cors = require("cors");

const app = express();

connectMongo();

initializingPassport(passport);

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

const sessionStore = MongoStore.create({
  mongoUrl: "mongodb://127.0.0.1:27017/services",
  collectionName: "sessions",
  ttl: 300 * 24 * 60 * 60,
});

app.use(
  expressSession({
    secret: "secret",
    resave: false,
    saveUninitialized: false,
    store: sessionStore,
  })
);

app.use(passport.initialize());
app.use(passport.session());

app.get("/", (req, res) => {
  res.send("hemlo");
});

app.post("/signup", async (req, res) => {
  try {
    const existingUser = await User.findOne({ email: req.body.email });
    if (existingUser) return res.status(400).send("User already exists");

    const hashedPassword = await bcrypt.hash(req.body.password, 10);

    const newUser = await User.create({
      ...req.body,
      password: hashedPassword,
    });

    res.status(201).send(newUser);
  } catch (error) {
    res.status(404).send("Server error: " + error.message);
  }
});

// app.post("/login", async (req, res, next) => {
//   passport.authenticate("local", (err, user, info) => {
//     if (err) return res.status(405).send("error");

//     if (!user) return res.status(404).send("user not found");

//     res.status(202).send("LoggedIn");
//   });
// });

app.post("/login", (req, res, next) => {
  passport.authenticate("local", (err, user, info) => {
    if (err) {
      return res.status(405).send("error");
    }

    if (!user) {
      return res.status(404).send(info ? info.message : "user not found");
    }

    req.logIn(user, (err) => {
      if (err) {
        return res.status(404).send("Login failed");
      }
      return res.status(202).send("LoggedIn");
    });
  })(req, res, next);
});


app.listen(4000, () => {
  console.log("server started at port 4000");
});
