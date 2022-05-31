import 'dart:convert';

class Message {
  final String? id;
  final String? text;
  final String? senderID;
  final String? receiverID;
  final String? deviceMAC;
  final bool? isMedia;
  final DateTime? timestamp;

  Message({
    this.id,
    this.text,
    this.senderID,
    this.receiverID,
    this.deviceMAC,
    this.isMedia,
    this.timestamp,
  });

  factory Message.fromRawJson(String str) => Message.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json["_id"],
        text: json["content"],
        senderID: json["sender"],
        receiverID: json["receiver"],
        deviceMAC: json["deviceMAC"],
        isMedia: json["isMedia"],
        timestamp: DateTime.parse(json["timestamp"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "text": text,
        "senderID": senderID,
        "receiverID": receiverID,
        "deviceMAC": deviceMAC,
        "isMedia": isMedia,
        "timestamp": timestamp!.toIso8601String(),
      };
}
