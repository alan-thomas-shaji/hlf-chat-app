const axiosClient = require("../apiClient");

function getAllUsers() {
  return axiosClient.get("/users");
}

function getUser(userID) {
  return axiosClient.get("/users/" + userID);
}

module.exports = {
  getAllUsers: getAllUsers,
  //   getUser: getUser(),
};
