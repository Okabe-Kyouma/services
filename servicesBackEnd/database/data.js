const mongoose = require('mongoose');

const { Schema } = mongoose;

const userSchema = new Schema({
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
    aadhar:{
        type:String,
        required:true,
        unique:true,
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
    homeLocation: {
        type: {
            type: String,
            enum: ['Point'],  
            required: true,
        },
        coordinates: {
            type: [Number],  
            required: true,
        }
    }
}, {
    timestamps: true,  
});

const User = mongoose.model('User', userSchema);

module.exports = User;
