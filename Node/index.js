require("dotenv").config();
const app = require("express")();
const http = require("http").createServer(app);
const { uploadImage } = require("./aws-upload");
const {
  createMessage,
  getMessage,
  patchMessage,
} = require("./API/lib/message");
const io = require("socket.io")(http, {
  cors: { origin: "*:*" },
  serveClient: false,
});

// const msg = {
//   sender: "V1StGXR8_Z5jdHi6B-myc",
//   receiver: "V1StGXR8_Z5jdHi6B-myX",
//   content: "Greetings...",
//   timestamp: Date.now(),
//   deviceMAC: "20:a2:8c:10:4f",
//   isMedia: false,
// };

// createMessage(msg)
//   .then((response) => console.log(response.data))
//   .catch((error) => console.error(error));

// getMessage("6290cecbaf242394766b7167")
//   .then((response) => {
//     let message = response.data;
//     message.forwardCount += 1;
//     patchMessage("6290cecbaf242394766b7167", {
//       forwardCount: message.forwardCount,
//     })
//       .then((response) => console.log(message))
//       .catch((error) => console.error(error));
//   })
//   .catch((error) => console.log(error));

app.get("/", (req, res) => {
  res.send("Server running.");
});

io.on("connection", (socket) => {
  //Get the chatID of the user and join in a room of the same chatID
  chatID = socket.handshake.query.chatID;
  socket.join(chatID);

  //Leave the room if the user closes the socket
  socket.on("disconnect", () => {
    socket.leave(chatID);
  });

  socket.on("message", (data) => {
    const message = {
      sender: data.senderChatID,
      receiver: data.receiverChatID,
      content: data.message,
      timestamp: data.timestamp,
      deviceMAC: data.deviceMAC,
      isMedia: false,
      
    };

    createMessage(message)
      .then((response) => io.emit("receive_message", response.data))
      .catch((error) => console.error(error));
  });

  socket.on("media", (data) => {
    const mediaUrl = uploadImage(Buffer(data.image));
    const mediaMessage = {
      sender: data.senderChatID,
      receiver: data.receiverChatID,
      content: mediaUrl,
      deviceMAC: data.deviceMAC,
      timestamp: data.timestamp,
      isMedia: true,
    };

    createMessage(mediaMessage)
      .then((response) => io.emit("receive_message", response.data))
      .catch((error) => console.error(error));
  });

  socket.on("forward", (data) => {
    getMessage(data.messageID)
      .then((response) => {
        let message = response.data;
        message.forwardCount += 1;
        patchMessage(String(message._id), {
          forwardCount: message.forwardCount,
        })
          .then((response) => io.emit("receive_message", message))
          .catch((error) => console.error(error));
      })
      .catch((error) => console.log(error));
  });
});

const PORT = process.env.PORT || 3001;

http.listen(PORT, () => {
  console.log(`Server up and running on port: ${PORT}`);
});
