const axiosClient = require("../apiClient");

function getMessage(messageID) {
  return axiosClient.get("/message/" + messageID);
}

function createMessage(data) {
  return axiosClient.post("/messages/create", data);
}

function patchMessage(messageID, data) {
  return axiosClient.patch("/messages/update/" + messageID, data);
}

module.exports = {
  getMessage: getMessage,
  createMessage: createMessage,
  patchMessage: patchMessage,
};
