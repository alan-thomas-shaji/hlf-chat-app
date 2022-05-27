require("dotenv").config();
const axios = require("axios");

const axiosClient = axios.create({
  baseURL: "https://msg-restapi.herokuapp.com/",
});

module.exports = axiosClient;
