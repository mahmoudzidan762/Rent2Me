class Message {
  final String message;
  final String id;
  final String imageUrl;
  final String to;
  Message(this.message, this.id, this.imageUrl, this.to);
  factory Message.fromjeson(data) {
    return Message(data['message'], data['id'],data['imageUrl'],data['to']);
  }
}
