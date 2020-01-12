class User {
  final String name;
  final int age;
  final String bio;
  final String id;
  final int gender;
  final String email;
  final int genderWant;
  final List<String> seen;
  final List<String> swiped;

  User({
    this.name,
    this.age,
    this.bio,
    this.id,
    this.email,
    this.gender,
    this.genderWant,
    this.seen,
    this.swiped,
  });
}

class Conversation {
  final double sentiment;
  final String id;
  final String user1;
  final String user2;

  Conversation({
    this.sentiment,
    this.id,
    this.user1,
    this.user2,
  });
}

class Message {
  final String content;
  final String sender;
  final int timestamp;
  final String id;
  final String conversationId;

  Message({
    this.content,
    this.sender,
    this.timestamp,
    this.id,
    this.conversationId,
  });
}
