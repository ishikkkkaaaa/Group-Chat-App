import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_chat_app/models/announcement.dart';
import 'package:group_chat_app/models/comment.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference userCollection =
      Firestore.instance.collection('users');
  final CollectionReference groupCollection =
      Firestore.instance.collection('groups');

  Future updateUserData(String fullName, String email, String password) async {
    return await userCollection.document(uid).setData({
      'fullName': fullName,
      'email': email,
      'password': password,
      'groups': [],
      'profilePic': ''
    });
  }

  Future createGroup(String userName, String groupName) async {
    DocumentReference groupDocRef = await groupCollection.add({
      'groupName': groupName,
      'groupIcon': '',
      'admin': userName,
      'members': [],
      'groupId': '',
      'recentMessage': '',
      'recentMessageSender': ''
    });

    await groupDocRef.updateData({
      'members': FieldValue.arrayUnion([uid + '_' + userName]),
      'groupId': groupDocRef.documentID
    });

    DocumentReference userDocRef = userCollection.document(uid);
    return await userDocRef.updateData({
      'groups':
          FieldValue.arrayUnion([groupDocRef.documentID + '_' + groupName])
    });
  }

  Future togglingGroupJoin(
      String groupId, String groupName, String userName) async {
    DocumentReference userDocRef = userCollection.document(uid);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    DocumentReference groupDocRef = groupCollection.document(groupId);

    List<dynamic> groups = await userDocSnapshot.data['groups'];

    if (groups.contains(groupId + '_' + groupName)) {
      await userDocRef.updateData({
        'groups': FieldValue.arrayRemove([groupId + '_' + groupName])
      });

      await groupDocRef.updateData({
        'members': FieldValue.arrayRemove([uid + '_' + userName])
      });
    } else {
      await userDocRef.updateData({
        'groups': FieldValue.arrayUnion([groupId + '_' + groupName])
      });

      await groupDocRef.updateData({
        'members': FieldValue.arrayUnion([uid + '_' + userName])
      });
    }
  }

  Future<bool> isUserJoined(
      String groupId, String groupName, String userName) async {
    DocumentReference userDocRef = userCollection.document(uid);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    List<dynamic> groups = await userDocSnapshot.data['groups'];

    if (groups.contains(groupId + '_' + groupName)) {
      return true;
    } else {
      return false;
    }
  }

  Future getUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where('email', isEqualTo: email).getDocuments();
    print(snapshot.documents[0].data);
    return snapshot;
  }

  getUserGroups() async {
    return Firestore.instance.collection("users").document(uid).snapshots();
  }

  Future<void> addQuery(AskQuery announcement) async {
    Firestore.instance
        .collection('announcements')
        .document()
        .setData(announcement.toMap());
  }

  readAllQuery() {
    return Firestore.instance.collection('announcements').snapshots().map(
        (event) =>
            event.documents.map((e) => AskQuery.fromFirebase(e)).toList());
  }

  Stream<List<Comments>> getComments(String postId) => Firestore.instance
      .collection('comments')
      .where('postId', isEqualTo: postId)
      .snapshots()
      .map((event) =>
          event.documents.map((e) => Comments.fromFirebase(e)).toList());

  Future<void> comment({
    @required String postId,
    @required String message,
  }) async {
    final sender = await FirebaseAuth.instance.currentUser();
    final Comments comment = Comments(
      postId: postId,
      sender: sender.displayName,
      message: message,
    );
    await Firestore.instance.collection('comments').add(comment.toMap());
  }

  // send message
  sendMessage(String groupId, chatMessageData) {
    Firestore.instance
        .collection('groups')
        .document(groupId)
        .collection('messages')
        .add(chatMessageData);
    Firestore.instance.collection('groups').document(groupId).updateData({
      'recentMessage': chatMessageData['message'],
      'recentMessageSender': chatMessageData['sender'],
      'recentMessageTime': chatMessageData['time'].toString(),
    });
  }

  getChats(String groupId) async {
    return Firestore.instance
        .collection('groups')
        .document(groupId)
        .collection('messages')
        .orderBy('time')
        .snapshots();
  }

  searchByName(String groupName) {
    return Firestore.instance
        .collection("groups")
        .where('groupName', isEqualTo: groupName)
        .getDocuments();
  }
}
