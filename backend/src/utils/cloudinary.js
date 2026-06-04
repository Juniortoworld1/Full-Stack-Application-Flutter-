import {v2 as cloudinary} from "cloudinary"
import fs from "fs"

cloudinary.config({ 
  cloud_name: `${process.env.CLOUDINARY_NAME}`, 
  api_key: `${process.env.CLOUDINARY_API}`, 
  api_secret: `${process.env.CLOUDINARY_SECRET}`
});

const uploadOnCloudinary = async (localFilePath)=>{
    try{
        if(!localFilePath) return console.log("could't find the path")
        
        const response  = await cloudinary.uploader.upload(localFilePath , {
            resource_type: "auto"

        })

        console.log('file is uploaded on ' , response.url)

        return response

        

    }catch(erro){
        fs.unlinkSync(localFilePath) // remove the locally saved temprary file as the upload operation got failed 
        return null;

    }
}

export {uploadOnCloudinary}