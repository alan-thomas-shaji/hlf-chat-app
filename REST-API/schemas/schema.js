const mongoose = require("mongoose");
const msgSchema = mongoose.Schema(
  {
    sender: {
      type: String,
      required: [true, "Sender who ?"],
    },
    receiver: {
      type: String,
      required: [true, "who is it"],
    },
    content: {
      type: String,
      required: [true, "where content"],
    },
    timestamp: {
      type: Date,
      required: [true, "where is the time "],
    },
    isMedia: {
      type: Boolean,
      required: [true, "Ok "],
    },
  },
  {
    timestamps: true,
  }
);

const userSchema = mongoose.Schema(
  {
    email: {
      type: String,
      required: [true, "email where"],
    },
    username: {
      type: String,
      required: [true, "Name where "],
    },
  },
  {
    timestamps: true,
  }
);
const chatIDSchema = mongoose.Schema(
  {
    participants: [userSchema],
    messages: [msgSchema],
  },
  {
    timestamps: true,
  }
);
module.exports = {
  msgSchema: msgSchema,
  userSchema: userSchema,
  chatIDSchema: chatIDSchema,
};
