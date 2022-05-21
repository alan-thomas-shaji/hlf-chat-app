class User1 {
  String? name;
  bool? isOnline;

  List<Message1>? messages;

  User1({this.name, this.isOnline, this.messages});

  User1.fromJson(Map<String, dynamic> json) {
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

class Message1 {
  String? content;
  DateTime? timestamp;
  bool? isMe;

  Message1({
    this.content,
    this.timestamp,
    this.isMe,
  });

  Message1.fromJson(Map<String, dynamic> json) {
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
