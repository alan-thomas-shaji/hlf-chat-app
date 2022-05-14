const express = require("express");
const app = express();
const http = require("http");
const server = http.createServer(app);
const { Server } = require("socket.io");
const io = new Server(server);

app.get("/", (req, res) => {
  res.send("<h1>Hello world</h1>");
});

io.on("connection", (socket) => {
  const username = socket.handshake.query.username;
  socket.on("message", (data) => {
    console.log(data);
  });
});

io.on("message", (data) => {
  console.log(data);
  io.emit("message", data);
});

server.listen(3001, () => {
  console.log("listening on *:3001");
});
