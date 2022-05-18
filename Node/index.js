require("dotenv").config();
const app = require("express")();
const http = require("http").createServer(app);
const io = require("socket.io")(http);
const mongoose = require("mongoose");
const { msgSchema, userSchema } = require("./mongodb/schema");

console.log(process.env.MONGODB_PASSWD);

mongoose.connect(
  "mongodb+srv://admin-nkes:" +
    process.env.MONGODB_PASSWD +
    "@cluster0.wx7lg.mongodb.net/msgDB",
  { useNewUrlParser: true }
);

const Message = mongoose.model("Message", msgSchema);
const User = mongoose.model("User", userSchema);

// const admin = new User({
//   email: "admin-user@gmail.com",
//   username: "admin"
// })

// admin.save();

app.get("/", (req, res) => {
  res.send("<h1>Hello world</h1>");
});

// io.on('connection', (socket) => {
//   const username = socket.handshake.query.username;

//   socket.on('message', (data) => {
//     console.log(data);
//   });
// });

io.on("connection", (socket) => {
  //Get the chatID of the user and join in a room of the same chatID
  chatID = socket.handshake.query.chatID;
  socket.join(chatID);

  //Leave the room if the user closes the socket
  socket.on("disconnect", () => {
    socket.leave(chatID);
  });

  //Send message to only a particular user
  socket.on("message", (data) => {
    receiverChatID = data.receiverChatID;
    senderChatID = data.senderChatID;
    content = "message.content";
    message = data.message;
    console.log(data);

    //Send message to only that particular room
    socket.emit("receive_message", {
      'content': message,
      'senderChatID': senderChatID,
      'receiverChatID': receiverChatID,
    });
  });
});

http.listen(3001, "0.0.0.0", () => {
  console.log("listening on: 3001");
});
