require("dotenv").config();
const express = require("express");
const app = express();
const http = require("http");
const server = http.createServer(app);
const { Server } = require("socket.io");
const io = new Server(server);
const mongoose = require("mongoose");
const { msgSchema, userSchema } = require("./mongodb/schema");

console.log(process.env.MONGODB_PASSWD);

mongoose.connect("mongodb+srv://admin-nkes:" + process.env.MONGODB_PASSWD + "@cluster0.wx7lg.mongodb.net/msgDB", { useNewUrlParser: true });

const Message = mongoose.model('Message', msgSchema);
const User = mongoose.model('User', userSchema);

// const admin = new User({
//   email: "admin-user@gmail.com",
//   username: "admin"
// })

// admin.save();

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

  //MongoDB code starts here
  // const message = new Message({
  //   sender: data.sender,
  //   reciever: data.reciever,
  //   content: data.content,
  //   timestamp: Date.now(),
  //   isMedia: false,
  // })

  // message.save();
  //MongoDB code ends here

  io.emit("message", data);
});



server.listen(3001, () => {
  console.log("listening on *:3001");
});
