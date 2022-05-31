require("dotenv").config();
var log4js = require("log4js");
var logger = log4js.getLogger();
const express = require("express");
const axios = require("axios");
const mongoose = require("mongoose");
var cors = require("cors");
const { createMessageBlock } = require("./API/lib/message");
const { parse, stringify, toJSON, fromJSON } = require("flatted");
const { msgSchema, userSchema, chatIDSchema } = require("./schemas/schema.js");
const { nanoid } = require("nanoid");
const { getJWT, updateJWT, refreshJWT } = require("./API/tokenService");
const axiosClient = require("./API/apiClient");
const app = express();

if (typeof localStorage === "undefined" || localStorage === null) {
  var LocalStorage = require("node-localstorage").LocalStorage;
  localStorage = new LocalStorage("./scratch");
}

logger.level = "debug";

//Connecting MongoDB
if (Boolean(process.env.PRODUCTION)) {
  //Checking if production env or not
  mongoose.connect(
    "mongodb+srv://admin-nkes:" +
      process.env.MONGODB_PASSWD +
      "@cluster0.wx7lg.mongodb.net/msgDB",
    { useNewUrlParser: true }
  );
} else {
  mongoose.connect("mongodb://localhost:27017/msgDB", {
    useNewUrlParser: true,
  });
}

//Creating Mongoose Models
const Message = mongoose.model("Message", msgSchema);
const User = mongoose.model("User", userSchema);
const Chat = mongoose.model("Chat", chatIDSchema);

//Middlewares
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cors());

let token = getJWT();

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
  newUser.save((err) => {
    if (err) {
      res.send(err);
    }
    if (!err) {
      res.send(JSON.stringify(newUser));
    }
  });
});

app.get("/users", (req, res) => {
  User.find((err, users) => {
    if (err) {
      res.send(err);
    }

    res.send(users);
  });
});

//Getting a user of userId
app.get("/users/:userId", (req, res) => {
  User.find({ _id: req.params.userId }, (err, foundUser) => {
    if (err) {
      res.send(err);
    }
    if (!err) {
      res.send(foundUser);
    }
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

app.get("/messages", (req, res) => {
  Message.find((err, messages) => {
    if (err) {
      res.send(err);
    }
    res.send(messages);
  });
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

//Getting all messages by userId
app.get("/messages/all/:userId", (req, res) => {
  Message.find(
    { $or: [{ sender: req.params.userId }, { receiver: req.params.userId }] },
    (err, foundMessages) => {
      if (err) {
        res.send(err);
      }
      if (!err) {
        res.send(foundMessages);
      }
    }
  );
});

app.post("/messages/create", (req, res) => {
  const newMessage = new Message({
    sender: req.body.sender,
    receiver: req.body.receiver,
    content: req.body.content,
    deviceMAC: req.body.deviceMAC,
    timestamp: req.body.timestamp,
    isMedia: req.body.isMedia,
    isForwarded: req.body.isForwarded,
  });
  //Initialising message object

  if (req.body.isMedia === true) {
    token = getJWT();

    if (token === "") {
      const refreshUser = {
        username: "admin",
        orgName: "Org1",
      };
      axiosClient
        .post("/users", refreshUser)
        .then((response) => {
          console.log("Interceptor token recived: " + response.data.token);
          updateJWT(response.data.token);
          token = getJWT();
        })
        .catch((error) =>
          console.error("Interceptor JWT refresh error: " + error)
        );
    }

    console.log("Invoking API with token: " + token);

    const header = { Authorization: `Bearer ${token}` };

    const id = req.body.content.split("/")[3].split(".")[0];

    if (req.body.isForwarded === true) {
      const forwardInvokeCC = {
        fcn: "forwardMessage",
        peers: ["peer0.org1.example.com"],
        chaincodeName: "messagecontract",
        channelName: "mychannel",
        args: [
          String(id),
          String(req.body.sender),
          String(req.body.receiver),
          String(req.body.timestamp),
        ],
      };

      createMessageBlock(forwardInvokeCC, header)
        .then((response) => {
          // console.log("token: " + getJWT());
          console.info(response.data);
        })
        .catch((error) => {
          if (error.response.status === 401) {
            console.log("token: " + getJWT());
            error.config.headers["Authorization"] = "Bearer " + getJWT();
            axiosClient.request(error.config);
          }
        });
    } else {
      const invokeCC = {
        fcn: "createMessage",
        peers: ["peer0.org1.example.com"],
        chaincodeName: "messagecontract",
        channelName: "mychannel",
        args: [
          String(id),
          String(req.body.sender),
          String(req.body.deviceMAC),
          String(req.body.receiver),
          String(req.body.content),
          String(req.body.timestamp),
        ],
      };

      createMessageBlock(invokeCC, header)
        .then((response) => {
          // console.log("token: " + getJWT());
          console.info(response.data);
        })
        .catch((error) => {
          if (error.response.status === 401) {
            console.log("token: " + getJWT());
            error.config.headers["Authorization"] = "Bearer " + getJWT();
            axiosClient.request(error.config);
          }
        });
    }
  }

  newMessage.save((err) => {
    if (err) {
      res.send(err);
    }
    if (!err) {
      res.send(newMessage);
    }
  });
  //Message saved to MongoDB
});

app.patch("/messages/update/:messageId", (req, res) => {
  Message.findByIdAndUpdate(
    req.params.messageId,
    { $set: req.body },
    (err, updatedMessages) => {
      if (err) {
        res.send(err);
      }
      res.send(updatedMessages);
    }
  );
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

    // logger.info("Message ID: " + newMessage._id);
  });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server up and running at port: ${PORT}`);
});
