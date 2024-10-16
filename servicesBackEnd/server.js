const express = require("express");
const connectMongo = require("./database/db");
const User = require("./database/data");
const passport = require("passport");
const { initializingPassport } = require("./passportConfig");
const expressSession = require("express-session");
const MongoStore = require("connect-mongo");
const bcrypt = require("bcrypt");
const cors = require("cors");
const cookieParser = require("cookie-parser");
const { default: mongoose } = require("mongoose");

const app = express();

connectMongo();

initializingPassport(passport);

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use(cookieParser());

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
    name: "kek",
  })
);

app.use(passport.initialize());
app.use(passport.session());

app.get("/", (req, res) => {
  res.send("hemlo");
});

app.get("/userList/:text", async (req, res, next) => {
  if (req.isAuthenticated()) {
    const text = req.params.text;

    const currentUserId = req.user._id;

    console.log("my user: " + currentUserId);

    const userList = await User.find({
      service: text,
      _id: { $ne: currentUserId },
    });

    console.log("userlist: " + userList);

    return res.status(202).send(userList);
  } else {
    res.status(404).send("user not authenticated");
  }
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
      return res.status(202).json({
        message: "Logged In",
        sessionId: req.sessionID,
      });
    });
  })(req, res, next);
});

app.get("/ping", (req, res) => {
  if (req.isAuthenticated()) {
    res.status(200).send("is authenticated");
  } else {
    res.status(404).send("not authenticated");
  }
});

app.post("/logout", (req, res) => {
  if (req.isAuthenticated()) {
    const sessionId = req.sessionID;

    req.session.destroy((err) => {
      if (err) {
        return res.status(405).send("Logout failed");
      }

      sessionStore.destroy(expressSession.Cookie);

      return res.status(202).send("Logged out");
    });
  } else {
    return res.status(404).send("user not authenticated");
  }
});

app.listen(4000, () => {
  console.log("server started at port 4000");
});
