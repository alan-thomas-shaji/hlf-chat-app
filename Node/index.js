require("dotenv").config();
const app = require("express")();
const axios = require("axios");
const Logger = require("nodemon/lib/utils/log");
const http = require("http").createServer(app);
const { uploadImage } = require("./aws-upload");
const io = require("socket.io")(http, {
  cors: { origin: "*:*" },
  serveClient: false,
});

const createMessage = (data) => {
  console.log(data);
  axios
    .post(process.env.REST_API_URL + "messages/" + chatID, {
      sender: data.senderChatID,
      receiver: data.receiverChatID,
      content: data.message,
      timestamp: data.timestamp,
      isMedia: false,
    })
    .then((response) => {
      console.log(response);
    })
    .catch((error) => {
      console.log(error);
    });

  //Send message to only that particular room
  io.emit("receive_message", {
    content: data.message,
    senderChatID: data.senderChatID,
    receiverChatID: data.receiverChatID,
  });
};

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

  socket.on("media", (data) => {
    const mediaUrl = uploadImage(data.image);
    axios
      .post(process.env.REST_API_URL + "messages/" + chatID, {
        sender: data.senderChatID,
        receiver: data.receiverChatID,
        content: mediaUrl,
        timestamp: data.timestamp,
        isMedia: false,
      })
      .then((response) => {
        console.log(response);
      })
      .catch((error) => {
        console.log(error);
      });

    io.emit("receive_message", {
      content: mediaUrl,
      senderChatID: data.senderChatID,
      receiverChatID: data.receiverChatID,
    });
  });

  //Send message to only a particular user
  socket.on("message", createMessage(data));

  socket.on("forward", (data) => {
    axios
      .get(process.env.REST_API_URL + "message/" + data.messageID)
      .then((resMessage) => {
        resMessage.forwardCount += 1;
        //some more code that is unaffecting to the chat to be added here.
        createMessage(data);
      })
      .catch((error) => {
        console.log(error);
      });
  });
});

const PORT = process.env.PORT || 3001;

http.listen(PORT, () => {
  console.log(`Server up and running on port: ${PORT}`);
});
