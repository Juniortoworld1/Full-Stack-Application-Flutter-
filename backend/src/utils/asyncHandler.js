// const asyncHandler = () =>{}


export {asyncHandler}

const asyncHandler =  (fn)=> async (req ,res , next ) =>{
    try{
        await fn(req , res , next )

    }catch{
        res.status(err.code || 500).json({
            success: flase ,
            message: error.message
        })
    }

}