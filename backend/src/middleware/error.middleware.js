// src/middlewares/error.middleware.js

export const errorHandler = (err, req, res, next) => {
    // 1. Extract status code and message from your ApiError (fallback to 500 if undefined)
    const statusCode = err.statusCode || 500;
    const message = err.message || "Internal Server Error";

    // 2. Send the response back strictly as JSON
    return res.status(statusCode).json({
        success: false,
        statusCode: statusCode,
        message: message,
        errors: err.errors || [],
        // Optional: Only show stack trace during local development debugging
        ...(process.env.NODE_ENV === "development" && { stack: err.stack })
    });
};