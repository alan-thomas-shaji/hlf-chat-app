const axios = require("axios");
const { updateJWT, getJWT } = require("./tokenService");

const axiosClient = axios.create({
  baseURL: "https://6660-116-68-98-136.in.ngrok.io",
});

axiosClient.interceptors.response.use((error) => {
  if (error.response.status === 401) {
    const refreshUser = {
      username: "admin",
      orgName: "Org1",
    };
    axiosClient
      .post("/users", refreshUser)
      .then((response) => {
        console.log("Interceptor token recived: " + response.data.token);
        updateJWT(response.data.token);
      })
      .catch((error) =>
        console.error("Interceptor JWT refresh error: " + error)
      );
  }
  Promise.reject(error);
});

module.exports = axiosClient;
