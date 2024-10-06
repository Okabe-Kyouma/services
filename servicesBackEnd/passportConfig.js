const LocalStrategy = require("passport-local").Strategy;
const bcrypt = require('bcrypt');
const mongoose = require('mongoose');
const User  = require("./database/data");

exports.initializingPassport = (passport) => {
  passport.use(
    new LocalStrategy(async (username, password, done) => {
      try {
        const user = await User.findOne({username});

        if (!user) return done(null, false);

        console.log("passwrod: " + password);
        console.log("saved Pass: " + user.password);

        const isMatch = await bcrypt.compare(password, user.password);
      if (!isMatch) return done(null, false, { message: "Invalid password" });


        return done(null, user);
      } catch (e) {
        return done(e, false);
      }
    })
  );

  passport.serializeUser((user,done)=>{
    done(null,user.id);
  })
  
  passport.deserializeUser(async(id,done)=>{
    try{
        const user = await User.findById(id);

        done(null,user);
    }
    catch(e){
        done(error,false);
    }
  })


};
