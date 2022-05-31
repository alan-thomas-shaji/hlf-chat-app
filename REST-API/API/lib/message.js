const axiosClient = require("../apiClient");

function createMessageBlock(data, header) {
  return axiosClient.post(
    "/channels/mychannel/chaincodes/messagecontract",
    data,
    { headers: header }
  );
}

module.exports = {
  createMessageBlock: createMessageBlock,
};
