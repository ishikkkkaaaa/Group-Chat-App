import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Comments {
  final String postId;
  final String sender;
  final String message;
  final String id;
  Comments({
    @required this.postId,
    @required this.sender,
    @required this.message,
    this.id,
  });

  Comments copyWith({
    String postId,
    String sender,
    String message,
    String id,
  }) {
    return Comments(
      postId: postId ?? this.postId,
      sender: sender ?? this.sender,
      message: message ?? this.message,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'sender': sender,
      'message': message,
    };
  }

  factory Comments.fromMap(Map<String, dynamic> map) {
    return Comments(
      postId: map['postId'] ?? '',
      sender: map['sender'] ?? 'Teacher',
      message: map['message'] ?? '',
      id: map['id'] ?? '',
    );
  }

  factory Comments.fromFirebase(DocumentSnapshot doc) {
    final map = doc.data;
    return Comments(
      postId: map['postId'] ?? '',
      sender: map['sender'] ?? 'Teacher',
      message: map['message'] ?? '',
      id: doc.documentID,
    );
  }

  String toJson() => json.encode(toMap());

  factory Comments.fromJson(String source) =>
      Comments.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Comments(postId: $postId, sender: $sender, message: $message, id: $id)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Comments &&
        other.postId == postId &&
        other.sender == sender &&
        other.message == message &&
        other.id == id;
  }

  @override
  int get hashCode {
    return postId.hashCode ^ sender.hashCode ^ message.hashCode ^ id.hashCode;
  }
}
