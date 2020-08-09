import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  final String id;
  final String title;
  final String content;
  final Timestamp createdAt;

  Item(this.id, this.title, this.content, this.createdAt);

  // https://codelabs.developers.google.com/codelabs/flutter-firebase/index.html#4
  // 1. Using "Named constructors"
  // 2. Using "Initializer list"
  Item.fromFirestore(DocumentSnapshot document)
      : id = document.documentID,
        title = document['title'],
        content = document['content'],
        createdAt = document['createdAt'];
}
