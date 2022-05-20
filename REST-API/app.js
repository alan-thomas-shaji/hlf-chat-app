const express = require("express");
const mongoose = require("mongoose")
var bodyParser = require('body-parser')
const {msgSchema,userSchema,chatIDSchema} = require("./schemas/schema.js");
const req = require("express/lib/request");


const app = express();
mongoose.connect("mongodb://localhost:27017/msgdb");


app.use(bodyParser.urlencoded({extended: true}));
const Message = mongoose.model("Message",msgSchema);
const User = mongoose.model("User",userSchema);
const Chat = mongoose.model("Chat",chatIDSchema);
app.get("/",(req,res)=>{
   res.send("Hello world");
});
app.post("/",(req,res)=>
{
  console.log(req.body);
  console.log(req.body.title);
});
app.post("/users",(req,res)=>{

    const newUser = new User({
            email: req.body.email,
            username: req.body.username
        });
        
        newUser.save();
        res.send("user added ");
});
 

app.get("/users/:userId", (req, res)=>{

    User.find({username: req.params.userId}, (err, foundUser) => {
        if (err){
            res.send(err);
        }
        res.send(foundUser);
    })
})
app.delete("/users/:userId",(req,res)=>{
      User.deleteOne(
          {username:req.params.userId},(err,result)=>{
              //console.log(haa);
          if(err || result.deletedCount==0 )
          {
              res.send("doesnot exist");
        }
        else
        res.send("Successfully deleted");
        });
});


app.post("/messages/chat-id/init",(req,res)=>{
    console.log(req.body);
    var unni;

    let participants = []
    participants.push(req.body.sender);
    participants.push(req.body.reciever);
    console.log(participants);

    User.find({
        username: {
            $in: participants
        } 
    }, (err, foundUsers) => {
        const newChat = new Chat({participants: foundUsers})
            newChat.save();
            res.send(newChat);
        })
});
app.get("/messages/:chatID",(req,res)=>
{
    Chat.find({_id:req.params.chatID},(err,foundChat)=>
    {
        if(err)
        res.send(err);
        res.send(foundChat[0].messages);
    });
});

app.listen(3000,()=> {
    console.log("Server up and running ");
});
