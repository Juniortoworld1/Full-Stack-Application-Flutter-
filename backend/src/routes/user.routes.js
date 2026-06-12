import { Router } from "express"; 
import { loginUser, registerUser , logOut , refresAcessToken } from "../controllers/user.controller.js";
import { upload } from "../middleware/multer.middleware.js";
import { verifyJWT } from "../middleware/auth.middleware.js";

const router = Router();

router.route("/register").post(
    // Added [ at the start and ] at the end of the fields list
    upload.fields([
        {
            name: "avatar",
            maxCount: 1
        }, 
        {
            name: "coverImage", 
            maxCount: 1 
        }
    ]), 
    registerUser
);

router.route("/login").post(
    // Added [ at the start and ] at the end of the fields list
    loginUser
);

router.route("/logout").post(
    verifyJWT , 
    logOut
    
)

router.route("/refresh-token").post(refresAcessToken)

export default router;