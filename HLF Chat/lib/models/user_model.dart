class User {
  String? name;
  bool? isOnline;

  List<Message>? messages;

  User({this.name, this.isOnline, this.messages});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    isOnline = json['isOnline'];
    messages = json['messages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['isOnline'] = this.isOnline;
    data['messages'] = this.messages;
    return data;
  }
}

class Message {
  String? content;
  DateTime? timestamp;
  bool? isMe;

  Message({
    this.content,
    this.timestamp,
    this.isMe,
  });

  Message.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    isMe = json['isMe'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content'] = this.content;
    data['timestamp'] = this.timestamp;
    data['isMe'] = this.isMe;
    return data;
  }
}
