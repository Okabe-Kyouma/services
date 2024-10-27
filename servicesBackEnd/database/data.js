const mongoose = require('mongoose');

const { Schema } = mongoose;

const userSchema = new Schema({

    profilePictureUrl:{
        type:String,
        required:false,
    },
    username:{
        type:String,
        required:true,
        unique:true,
        minlength:6
    },
    fullname: {
        type: String,
        required: true,
        trim: true
    },
    phoneNumber: {
        type: String,
        required: true,
        unique: true,
    },
    email: {
        type: String,
        required: true,
        unique: true,
        lowercase: true,
    },
    password: {
        type: String,
        required: true,
        minlength: 8,
    },
    service: {
        type: String,
        trim: true,
    },
    exp: {
        type: String,
    },
    currentLocation: {
        type: {
            type: String,
            enum: ['Point'],  
            required: true,
        },
        coordinates: {
            type: [Number],  
        }
    },
}, {
    timestamps: true,  
});

const User = mongoose.model('User', userSchema);

module.exports = User;
