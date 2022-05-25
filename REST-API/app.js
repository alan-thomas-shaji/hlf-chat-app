require("dotenv").config();
var log4js = require("log4js");
var logger = log4js.getLogger();
const express = require("express");
const axios = require("axios");
const mongoose = require("mongoose");
var bodyParser = require("body-parser");
var cors = require("cors");
const { parse, stringify, toJSON, fromJSON } = require("flatted");
const { msgSchema, userSchema, chatIDSchema } = require("./schemas/schema.js");
const { nanoid } = require("nanoid");
const app = express();

logger.level = "debug";

//Connecting MongoDB
mongoose.connect(
  "mongodb://localhost:27017/msgDB",
  // "mongodb+srv://admin-nkes:" +
  //   process.env.MONGODB_PASSWD +
  //   "@cluster0.wx7lg.mongodb.net/msgDB",
  { useNewUrlParser: true }
);

//Creating Mongoose Models
const Message = mongoose.model("Message", msgSchema);
const User = mongoose.model("User", userSchema);
const Chat = mongoose.model("Chat", chatIDSchema);

//Middlewares
app.use(bodyParser.urlencoded({ extended: true }));
app.use(cors());

let token =
  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2NTM0ODc0ODEsInVzZXJuYW1lIjoiTW9udSIsIm9yZ05hbWUiOiJPcmcxIiwiaWF0IjoxNjUzNDUxNDgxfQ.i2hIHG1nnAYW4fniCLC4ZFwB4OWmW9t6-pSdCt1fBaU";

//Routes
//Home Route
app.get("/", (req, res) => {
  res.send("API Server running.");
});

//Creating a new user
app.post("/users", (req, res) => {
  const newUser = new User({
    _id: req.body.uuid, //req.body.uuid
    email: req.body.email,
    username: req.body.username,
  });
  newUser.save();

  const config = {
    headers: { Authorization: `Bearer ${token}` },
  };

  axios
    .post(
      process.env.NGROK_URL + "/users",
      {
        username:
          String(req.body.uuid) +
          "_" +
          String(req.body.email) +
          "_" +
          String(req.body.username),
        orgName: "Org1",
      },
      config
    )
    .then((response) => {
      const token = toJSON(response)[37].replaceAll(`"`, "");
      logger.info("Use enrollment success with JWT token: " + token);
    })
    .catch((error) => {
      logger.debug("Error: " + stringify(error));
    });

  const response = {
    userObject: newUser,
    token: token,
  };

  res.send(JSON.stringify(response));
});

//Getting a user of userId
app.get("/users/:userId", (req, res) => {
  User.find({ username: req.params.userId }, (err, foundUser) => {
    if (err) {
      res.send(err);
    }
    res.send(foundUser);
  });
});

//Deleting a user of userId
app.delete("/users/:userId", (req, res) => {
  User.deleteOne({ username: req.params.userId }, (err, foundUser) => {
    if (err || foundUser.deletedCount == 0) {
      res.send("Requested user does not exist!");
    } else {
      res.send(`Successfully deleted user!`);
    }
  });
});

//Initialising Chat Room : returns ChatID of the room
app.post("/messages/chat-id/init", (req, res) => {
  let participants = [];
  participants.push(req.body.sender);
  participants.push(req.body.reciever);

  User.find(
    {
      username: {
        $in: participants,
      },
    },
    (err, foundUsers) => {
      if (err) {
        res.send(err);
      }

      const newChat = new Chat({ participants: foundUsers });
      newChat.save();
      res.send(newChat._id);
    }
  );
});

app.get("/message/:messageId", (req, res) => {
  Message.findOne({ _id: req.params.messageId }, (err, foundMessage) => {
    if (err) {
      res.send(err);
    }
    res.send(foundMessage);
  });
});

//Getting the ID of the chat by chatId
app.get("/messages/:chatId", (req, res) => {
  Chat.find({ _id: req.params.chatId }, (err, foundChat) => {
    if (err) {
      res.send(err);
    }
    res.send(foundChat[0].messages);
  });
});

//Creating a message in the requested chatId
app.post("/messages/:chatId", (req, res) => {
  Chat.findOne({ _id: req.params.chatId }, (err, foundChat) => {
    if (err) {
      res.send(err);
    }

    const newMessage = new Message({
      sender: req.body.sender,
      receiver: req.body.receiver,
      content: req.body.content,
      deviceMAC: req.body.deviceMAC,
      timestamp: req.body.timestamp,
      isMedia: req.body.isMedia,
    });

    foundChat.messages.push(newMessage);
    foundChat.save();
    newMessage.save();

    logger.info("Message ID: " + newMessage._id);

    axios
      .post(
        process.env.NGROK_URL +
          "/channels/mychannel/chaincodes/messagecontract",
        {
          fcn: "createMessage",
          peers: ["peer0.org1.example.com"],
          chaincodeName: "messagecontract",
          channelName: "mychannel",
          args: [
            String(newMessage._id),
            String(req.body.sender),
            String(req.body.deviceMAC),
            String(req.body.receiver),
            String(req.body.content),
            String(req.body.timestamp),
          ],
        },
        {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        }
      )
      .then((response) => {
        logger.debug(stringify(response));
      })
      .catch((error) => {
        logger.debug(stringify(error));
      });

    res.send(
      `New message: ${newMessage} added to chatID: ${req.params.chatId}`
    );
  });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server up and running at port: ${PORT}`);
});
