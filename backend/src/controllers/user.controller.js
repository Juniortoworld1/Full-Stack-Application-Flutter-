import { asyncHandler } from "../utils/asyncHandler.js";
import { ApiError } from "../utils/apiError.js";
import { ApiResponse } from "../utils/apiResponse.js"; // Make sure to import this!
import {User} from "../models/user.model.js"
import { uploadOnCloudinary } from "../utils/cloudinary.js";
import bcrypt from 'bcrypt'
import cookie from 'cookie-parser'

const generateAccessRefreshTokens = async (userId) => {
    try {
        const user = await User.findById(userId);
        
        if (!user) {
            throw new ApiError(404, "User not found");
        }

        // 1. Generate tokens using the methods defined on your Schema
        const accessToken = user.generateAccessToken(); 
        const refreshToken = user.generateRefreshToken();

        // 2. Assign the singular string token to the singular property on your model
        user.refreshToken = refreshToken;

        // 3. Save the document without validating the password field again
        await user.save({ validateBeforeSave: false });

        // 4. Return them matching your expected destruction naming
        return { accessTokens: accessToken, refreshTokens: refreshToken };

    } catch (error) {
        throw new ApiError(500 , 'Token not injucted')
        
    
    }
}






const registerUser = asyncHandler(async (req, res) => {
    // 1. Destructure the data from the Flutter frontend request body
    const { fullName, email, username, password } = req.body;

    // 2. Validation: Check if ANY field is empty or missing
    if (!fullName || !email || !username || !password) {
        throw new ApiError(400, "All fields (fullName, email, username, password) are required");
    }

    // 3. Validation: Check if email format is invalid
    if (!email.includes("@")) {
        throw new ApiError(400, "Invalid email format");
    }

    const existedUser =await  User.findOne({$or:[{username} , {email}]})

    if(existedUser){
        throw new ApiError(409 , "User Existed" , false)
    }

    const avatarLocalPath = req.files?.avatar[0]?.path ; 
     
    let coverImageLocalPath ;

    if(!req.files?.coverImage?.path){
        const coverImageLocalPath=""
    }else{
        const coverImageLocalPath = req.files?.coverImage[0]?.path ;

    }
    

    if (!avatarLocalPath){
        throw new ApiError(400 , "Avatar is required " , false ) 
    }

    const avatar = await uploadOnCloudinary(avatarLocalPath) ;
    const coverImage = await uploadOnCloudinary(coverImageLocalPath) ; 


    if (!avatar){
        throw new ApiError(400 , "avatar is required")
    }

    const user  = await User.create({
        fullName , 
        avatar: avatar.url , 
        coverImage: coverImage?.url||"" , 
        email , 
        password , 
        username: username.toLowerCase() 
    })

    const createdUser = await User.findById(user._id).select(
        "-password -refreshToken"
    )

    console.log(`\n\n\nUser: ${createdUser}`)

    if(!createdUser){
        throw new ApiError(500 , "failed registering the user !!!!")
        
    } 

    

    
    return res.status(201).json(
        new ApiResponse(200 , createdUser , "User registered Successfully")
    )





});

const loginUser = asyncHandler(async (req , res)=>{
    const {username, password} = req.body ; 
    if(!username) throw new ApiError(400 , "username required")  ; 
    if(!password) throw new ApiError(400 , "password required")  ; 

    const UserExist = await User.findOne({username})
    console.log(User.findOne({username}))

    if(!UserExist) throw new ApiError(400 , "username doesn't exist ") ;
    const isMatch = await UserExist.isPasswordCorrect(password)
    

    if(!isMatch) throw new ApiError(400  , "Incorrect Password"); 


    const {accessTokens , refreshTokens} = await generateAccessRefreshTokens(UserExist._id)

    const loggedIn = await User.findOne({username})
    const createdUser = await User.findById(loggedIn._id).select(
    "-password -refreshToken");

    const options = {
    httpOnly: true,
    secure: true
    };

// 🟢 FIX: Use the lowercase 'options' variable
    return res
    .status(200)
    .cookie("accessToken", accessTokens, options)
    .cookie("refreshToken", refreshTokens, options)
    .json(
        new ApiResponse(200, { createdUser}, "Logged In Successfully")
    );

    
    
//     return res.status(200).json(
//     new ApiResponse(200, createdUser, "LoggedIn")
// )






})



export { registerUser , loginUser };