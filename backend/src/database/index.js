// import mongoose from "mongoose";
// import { DB_NAME } from "../constants.js";
// import dotenv from "dotenv"
// const connectDB = async () => {
//     try {
//         // Added 'const' below and fixed lowercase '.connection.host'
//         const connectionInstance = await mongoose.connect(`${process.env.MONGODB_URI}/${DB_NAME}`); 
        
//         console.log(`\n MongoDB connected !! DB HOST : ${connectionInstance.connection.host}`); 
//     } catch (error) {
//         console.log("MONGODB connection error: ", error);
//         process.exit(1);
//     }
// };

// export default connectDB;


import mongoose from 'mongoose'
import { DB_NAME } from '../constants.js'

const conectionDB = async () =>{
    try{

        const connects = await mongoose.connect(`${process.env.MONGODB_URI}/${DB_NAME}`)
        console.log(`\nMongoDB connected !! DB HOST : ${connects.connection.host} \n\n\n Yes it's done bro `)

    }catch(error){
        console.log("getting error of : "  , error) ;
        process.exit(1) ; 
    }

} ;

export default conectionDB ; 