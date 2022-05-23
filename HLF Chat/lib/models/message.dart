class Message {
  final String? text;
  final String? senderID;
  final String? receiverID;
  final bool? isMedia;
  final DateTime? timestamp;

  Message({
    this.text,
    this.senderID,
    this.receiverID,
    this.isMedia,
    this.timestamp,
  });
}
