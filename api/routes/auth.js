const express = require("express");
const authController = require("../controllers/auth");

const router = express.Router();

router.route("/signup").post(authController.register);

router.route("/login").post(authController.login);

module.exports = router;
