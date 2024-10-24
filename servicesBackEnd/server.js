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
const haversine = require("haversine-distance");

const app = express();

connectMongo();

initializingPassport(passport);

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use(cookieParser());

const sessionStore = MongoStore.create({
  mongoUrl: "mongodb://127.0.0.1:27017/services",
  //mongoUrl: "mongodb://192.168.29.163:27017/services",
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

app.get("/check/email/:email", async (req, res) => {
  const email = req.params.email;
  console.log("this is the mssg ?");
  try {
  
    const user = await User.findOne({ email: email });

    if (user) {
      return res.status(202).send("email-id already exists");
    } else {
      return res.status(200).send("email-id doesn't exists");
    }
  } catch (e) {
    return res.status(500).send("server is down");
  }
});

app.get("/check/username/:username", async (req, res) => {
  const username = req.params.username;

  try {
    const user = await User.findOne({ username: username });

    if (user) {
      return res.status(202).send("username already exists");
    } else {
      return res.status(200).send("username is available");
    }
  } catch (e) {
    return res.status(404).send("server Down");
  }
});

app.post("/update/location/:latitude/:longitude",(req,res)=>{

   if(req.isAuthenticated()){

     const latitude = parseFloat(req.params.latitude);
     const longitude = parseFloat(req.params.longitude);

     const currentUser = req.user;

     currentUser.currentLocation = {
       type:'Point',
       coordinates : [longitude,latitude],
     };

     currentUser.save()
     .then(()=>{
      res.status(200).send("location updated successfullly!");
     })
     .catch(()=>{
      res.status(202).send("Error updating location");
     });


   }
   else{
     res.status(404).send("unauthorized");
   }

});

app.get("/userList/:text/:latidue/:longitude", async (req, res, next) => {
  if (req.isAuthenticated()) {
    const text = req.params.text;
    const latidue = req.params.latidue;
    const longitude = req.params.longitude;

    const currentUserId = req.user._id;

    console.log(
      "my user: " +
        currentUserId +
        " and his latitude: " +
        latidue +
        " and his longitude: " +
        longitude
    );

    const userList = await User.find({
      service: text,
      _id: { $ne: currentUserId },
    });

    const currentUser = await User.findById(currentUserId);

    const currentLocation = {
      latidue: currentUser.currentLocation.coordinates[1],
      longitude: currentUser.currentLocation.coordinates[0],
    };

    const categorizedUsers = {
      under2km: [],
      under5km: [],
      under10km: [],
    };

    userList.forEach((user) => {
      const userLocation = {
        latidue: user.currentLocation.coordinates[1],
        longitude: user.currentLocation.coordinates[0],
      };

      console.log("user: " + user);

      const distance = haversine(currentLocation, userLocation);

      if (distance <= 2000) {
        categorizedUsers.under2km.push(user);
      } else if (distance <= 5000) {
        categorizedUsers.under5km.push(user);
      } else {
        categorizedUsers.under10km.push(user);
      }
    });

    const orderdUserList = [
      ...categorizedUsers.under2km,
      ...categorizedUsers.under5km,
      ...categorizedUsers.under10km,
    ];

    console.log("userlist: " + orderdUserList);

    return res.status(202).send(orderdUserList);
  } else {
    res.status(404).send("user not authenticated");
  }
});

app.post("/signup", async (req, res) => {
  try {
    const existingUser = await User.findOne({ username: req.body.username });

    if (existingUser) return res.status(202).send("User already exists");

    const hashedPassword = await bcrypt.hash(req.body.password, 10);

    const newUser = await User.create({
      ...req.body,
      password: hashedPassword,
    });

    res.status(200).send(newUser);
  } catch (error) {
    res.status(404).send("Server error: " + error.message);
  }
});

app.post("/login", (req, res, next) => {
  passport.authenticate("local", (err, user, info) => {
    if (err) {
      return res.status(404).send("error");
    }

    if (!user) {
      return res.status(202).send(info ? info.message : "user not found");
    }

    req.logIn(user, (err) => {
      if (err) {
        return res.status(404).send("Login failed");
      }
      return res.status(200).json({
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
