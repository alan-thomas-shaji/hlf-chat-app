const mongoose = require('mongoose');

const msgSchema = mongoose.Schema({
    sender: {
        type: String,
        required: [true, "Specify the sender"]
    },
    reciever: {
        type: String,
        required: [true, "Specify the reciever"]
    },
    content: {
        type: String,
        required: [true, "No message content recieved"]
    },
    timestamp: {
        type: Date,
        required: [true, "Specify the date and time of the message"]
    },
    isMedia: {
        type: Boolean,
        required: [true, "Specify if the message contains media or not"]
    }
})

const userSchema = mongoose.Schema({
    email: {
        type: String,
        required: [true, "Specify the email ID"]
    },
    username: {
        type: String,
        required: [true, "Specify the user's name"]
    }
});

module.exports = {
    msgSchema: msgSchema,
    userSchema: userSchema
}