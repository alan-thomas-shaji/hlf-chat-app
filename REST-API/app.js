require("dotenv").config();
const express = require("express");
const mongoose = require("mongoose");
var bodyParser = require("body-parser");
const { msgSchema, userSchema, chatIDSchema } = require("./schemas/schema.js");
const app = express();

//Connecting MongoDB
mongoose.connect(
  "mongodb://localhost:27017/msgDB",
  //   "mongodb+srv://admin-nkes:" +
  //     process.env.MONGODB_PASSWD +
  //     "@cluster0.wx7lg.mongodb.net/msgDB",
  { useNewUrlParser: true }
);

//Creating Mongoose Models
const Message = mongoose.model("Message", msgSchema);
const User = mongoose.model("User", userSchema);
const Chat = mongoose.model("Chat", chatIDSchema);

//Middlewares
app.use(bodyParser.urlencoded({ extended: true }));

//Routes
//Home Route
app.get("/", (req, res) => {
  res.send("API Server running.");
});

//Creating a new user
app.post("/users", (req, res) => {
  const newUser = new User({
    email: req.body.email,
    username: req.body.username,
  });
  newUser.save();

  res.send(`Successfully added user: ${newUser}`);
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
      timestamp: req.body.timestamp,
      isMedia: req.body.isMedia,
    });

    foundChat.messages.push(newMessage);
    foundChat.save();
    res.send(
      `New message: ${newMessage} added to chatID: ${req.params.chatId}`
    );
  });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server up and running at port: ${PORT}`);
});
