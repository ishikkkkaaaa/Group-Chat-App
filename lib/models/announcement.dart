import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AskQuery {
  final String id;
  final String title;
  final String desc;
  final DateTime timestamp;
  AskQuery({
    this.id,
    @required this.title,
    @required this.desc,
    @required this.timestamp,
  });

  AskQuery copyWith({
    String id,
    String title,
    String desc,
    DateTime timestamp,
  }) {
    return AskQuery(
      id: id ?? this.id,
      title: title ?? this.title,
      desc: desc ?? this.desc,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'desc': desc,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  factory AskQuery.fromMap(Map<String, dynamic> map) {
    return AskQuery(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      desc: map['desc'] ?? '',
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
    );
  }

  factory AskQuery.fromFirebase(DocumentSnapshot docSnapshot) {
    final map = docSnapshot.data;
    return AskQuery(
      id: docSnapshot.documentID,
      title: map['title'] ?? 'Admin',
      desc: map['desc'] ?? '',
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
    );
  }

  String toJson() => json.encode(toMap());

  factory AskQuery.fromJson(String source) =>
      AskQuery.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Announcement(id: $id, title: $title, desc: $desc, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AskQuery &&
        other.id == id &&
        other.title == title &&
        other.desc == desc &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return id.hashCode ^ title.hashCode ^ desc.hashCode ^ timestamp.hashCode;
  }
}
