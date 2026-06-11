import { Router } from "express"; 
import { loginUser, registerUser } from "../controllers/user.controller.js";
import { upload } from "../middleware/multer.middleware.js";

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

export default router;