function getJWT() {
  return localStorage.getItem("token");
}

function updateJWT(token) {
  localStorage.setItem("token", token);
}

module.exports = { getJWT: getJWT, updateJWT: updateJWT };
