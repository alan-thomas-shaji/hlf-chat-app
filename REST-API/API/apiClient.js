const axios = require("axios");
const { updateJWT, getJWT, refreshJWT } = require("./tokenService");

const axiosClient = axios.create({
  baseURL: "https://268a-116-68-103-117.in.ngrok.io",
});

// axiosClient.interceptors.response.use((error) => {
//   if (error.response.status === 401) {
//     refreshJWT();
//   }
//   Promise.reject(error);
// });

module.exports = axiosClient;
