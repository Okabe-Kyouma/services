const mongoose = require('mongoose');

const dbURI = 'mongodb://localhost:27017/services';

const connectMongo = async () => {
    try{
        await mongoose.connect(dbURI);
        console.log('MongoDB connected Successfully');
    }
    catch(error){
        console.log('Mongodb connection error: ', error.message);
        process.exit(1);
    }
};

module.exports = connectMongo;

