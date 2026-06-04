
import dotenv from "dotenv"
import connectDB from "./database/index.js";
import connectionDB from "./database/index.js";
import { app } from "./app.js";

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

connectionDB()
.them(()=>{
    try{
        app.listen(process.env.PORT||8000 , ()=>{
        console.log(`server is running at port :  ${process.env.PORT||8000}`)
    })

    }catch{
        app.on("error" , (error)=>{
            console.log(`\n\n getting error of ${error}`)
        })
    }
})
.catch((error)=>{
    console.log("\n\nMONGO db connection failed !!!!" , error)
})