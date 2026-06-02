
import dotenv from "dotenv"
import connectDB from "./database/index.js";
import connectionDB from "./database/index.js";

// const app = express() ; 
// const port = process.env.PORT || 3000

// ;( async () =>{
//     try {
//         await mongoose.connect(`${process.env.MONGODB_URI}/${DB_NAME}`) ; 
//         app.on("error" , (error)=>{
//             console.log("Error: "  , error) ; 
//             throw error 
//         })

//         app.listen(port , ()=>{
//             console.log(`Listening on port : ${port}`)
//         })

//     }catch(error){
//         console.error("Error: " , error)
//         throw err 
//     }
// })()
dotenv.config()
console.log("DATABASE URI VALUE:", process.env.MONGODB_URI);


connectionDB()