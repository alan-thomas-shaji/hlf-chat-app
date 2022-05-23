require("dotenv").config();
const app = require("express")();
const http = require("http").createServer(app);
const io = require("socket.io")(http, {
  cors: { origin: "*:*" },
  serveClient: false,
});

app.get("/", (req, res) => {
  res.send("Server running.");
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
    io.emit("receive_message", {
      content: message,
      senderChatID: senderChatID,
      receiverChatID: receiverChatID,
    });
  });
});

const PORT = process.env.PORT || 3001;

http.listen(PORT, () => {
  console.log(`Server up and running on port: ${PORT}`);
});
