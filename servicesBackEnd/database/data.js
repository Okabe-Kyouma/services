const mongoose = require('mongoose');

const {Schema} = mongoose;

const userSchema = new mongoose.Schema({
    fullname:{
        type:String,
        required : true,
        trim: true
    },
    phoneNumber:{
        type : String,
        required : true,
        unique: true,
        match:[/^\d{10}$/, 'Please enter a valid phone number']
        
    },
    email:{
        type:String,
        required: true,
        unique: true,
        lowercase:true,
        match:[/.+\@.+\..+/, 'Please enter a valid email address']
        
    },
    password:{
        type:String,
        required:true,
        minlength:8,
    },
    service:{
        type:String,
        required:true,

    },
    exp:{
        type:Number,
        min: 0,
    },
    currentLocation:{
        type:{
            type:String,
            enum:['point'],
            required:true,
        },
        coordinates:{
            tpye:[Number],
            required:true,
        }
    },
    homeLocaion:{
        type:{
            type:String,
            enum:['point'],
            required:true,
        },
        coordinates:{
            tpye:[Number],
            required:true,
        }
    },

    timestamps:true,

});

const User = mongoose.model('User',userSchema);

module.exports = User;