const axiosClient = require("../apiClient");

function createNetworkUser(data) {
  return axiosClient.post("/users", data);
}

module.exports = {
  createNetworkUser: createNetworkUser,
};
