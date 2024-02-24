import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreDatabase {
  User? user = FirebaseAuth.instance.currentUser;

  Future<String> checkUser() async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('Users');
      QuerySnapshot querySnapshot =
          await users.where('email', isEqualTo: user!.email).get();

      if (querySnapshot.docs.isNotEmpty) {
        String role = querySnapshot.docs.first['role'];
        return role;
      } else {
        return 'User tidak ditemukan';
      }
    } catch (e) {
      print('Error: $e');
      return 'Terjadi kesalahan';
    }
  }

  // Future<String> checkCreator(String postId) async {
  //   try {
  //     CollectionReference users =
  //         FirebaseFirestore.instance.collection('Users');
  //     QuerySnapshot querySnapshot =
  //         await users.where('postId', isEqualTo: postId).get();

  //     if (querySnapshot.docs.isNotEmpty) {
  //       String userId = querySnapshot.docs.first['userId'];
  //       return userId;
  //     } else {
  //       return 'User tidak ditemukan';
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //     return 'Terjadi kesalahan';
  //   }
  // }

  final CollectionReference messages =
      FirebaseFirestore.instance.collection('Messages');

  Stream<QuerySnapshot> getMessagesStream() {
    final messagesStream = FirebaseFirestore.instance
        .collection("Messages")
        .orderBy("timeStamp")
        .snapshots();

    return messagesStream;
  }

  Stream<QuerySnapshot> getMessagesGroupStream(String groupId) {
    final messagesStream = FirebaseFirestore.instance
        .collection("Rooms")
        .doc(groupId)
        .collection("messages")
        .orderBy("timeStamp")
        .snapshots();

    return messagesStream;
  }

  Stream<QuerySnapshot> getIdeasStream(String groupId) {
    final ideasStream = FirebaseFirestore.instance
        .collection("Rooms")
        .doc(groupId)
        .collection("ideas")
        .orderBy("timeStamp")
        .snapshots();

    return ideasStream;
  }

  Stream<QuerySnapshot> getRoomsStream() {
    final roomsStream = FirebaseFirestore.instance
        .collection("Rooms")
        .orderBy("createdAt")
        .snapshots();

    return roomsStream;
  }

  Future<void> addNewRoom(String groupName) async {
    CollectionReference rooms = FirebaseFirestore.instance.collection('Rooms');
    DocumentReference newGroupRef = rooms.doc();

    await newGroupRef.set({
      'groupId': newGroupRef.id,
      'groupName': groupName,
      'createdAt': Timestamp.now()
    });
    CollectionReference members = newGroupRef.collection('members');

    await members.doc(user!.uid).set({
      'username': user!.displayName,
      'userId': user!.uid,
      'role': 'admin',
    });
  }

  Stream<QuerySnapshot> getPostsStream() {
    final postsStream = FirebaseFirestore.instance
        .collection("Posts")
        .orderBy("timeStamp", descending: true)
        .snapshots();

    return postsStream;
  }

  Future<void> editPost(postId, title, content) async {
    DocumentReference posts =
        FirebaseFirestore.instance.collection('Annoucements').doc(postId);
    DocumentSnapshot postSnapshot = await posts.get();
    print(postSnapshot.data());
    if (postSnapshot.exists) {
      Map<String, dynamic> postData =
          postSnapshot.data() as Map<String, dynamic>;

      // Now you have the current data, and you can modify it as needed.
      // For example, you can update the 'title' field.
      postData['title'] = title;
      postData['content'] = content;

      // Perform the update
      await posts.update(postData);
    } else {
      print('Post does not exist');
    }
  }

  // Stream<QuerySnapshot> getLikesStream(String postId) {
  //   final likesStream = FirebaseFirestore.instance
  //       .collection("Posts")
  //       .doc(postId)
  //       .collection("Likes")
  //       .snapshots();

  //   return likesStream;
  // }

  // Stream<QuerySnapshot> getCommentsStream(String postId) {
  //   final commentsStream = FirebaseFirestore.instance
  //       .collection("Posts")
  //       .doc(postId)
  //       .collection("Comments")
  //       .snapshots();

  //   return commentsStream;
  // }

  Future<void> addPost(String content) async {
    final CollectionReference postsCollection =
        FirebaseFirestore.instance.collection('Posts');

    final DocumentReference newPostRef = postsCollection.doc();

    await newPostRef.set({
      'postId': newPostRef.id,
      'username': user!.displayName,
      'userId': user!.uid,
      'content': content,
      'likes': 0,
      'comments': 0,
      'timeStamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> addEvent(String title, String address, String description, String date) async {
    final CollectionReference eventsCollection =
        FirebaseFirestore.instance.collection('Events');

    final DocumentReference newEventRef = eventsCollection.doc();

    await newEventRef.set({
      'postId': newEventRef.id,
      'title': title,
      'address': address,
      'desc': description,
      'date': date,
      'timeStamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> addAnnouncement(String content, String title) async {
    final CollectionReference postsCollection =
        FirebaseFirestore.instance.collection('Announcements');

    final DocumentReference newPostRef = postsCollection.doc();

    await newPostRef.set({
      'postId': newPostRef.id,
      'title': title,
      'content': content,
      'timeStamp': FieldValue.serverTimestamp(),
    });
  }

  Future<DocumentReference> addMessage(String message) async {
    return messages.add({
      'username': user!.displayName,
      'senderId': user!.uid,
      'message': message,
      'timeStamp': Timestamp.now(),
    });
  }

  Future<void> addMessageToGroup(String groupId, String messageText) async {
    CollectionReference groupMessages = FirebaseFirestore.instance
        .collection('Rooms')
        .doc(groupId)
        .collection('messages');

    await groupMessages.add({
      'username': user!.displayName,
      'senderId': user!.uid,
      'message': messageText,
      'timeStamp': Timestamp.now(),
      // tambahkan properti lain sesuai kebutuhan
    });
  }

  Future<void> addIdeasToGroup(
      String groupId, String ideaText, String title) async {
    CollectionReference groupIdeas = FirebaseFirestore.instance
        .collection('Rooms')
        .doc(groupId)
        .collection('ideas');

    final DocumentReference newIdeaRef = groupIdeas.doc();

    await groupIdeas.add({
      'id': newIdeaRef.id,
      'username': user!.displayName,
      'userId': user!.uid,
      'title': title,
      'idea': ideaText,
      'timeStamp': Timestamp.now(),
    });
  }

  Future<void> toggleLikePost(String postId, String userId) async {
    final DocumentReference postRef =
        FirebaseFirestore.instance.collection('Posts').doc(postId);

    final CollectionReference likesCollection = postRef.collection('Likes');

    // Mengecek apakah pengguna sudah menyukai postingan
    final DocumentSnapshot likeSnapshot =
        await likesCollection.doc(userId).get();

    if (likeSnapshot.exists) {
      await likesCollection.doc(userId).delete();

      await postRef.update({'likes': FieldValue.increment(-1)});
    } else {
      await likesCollection.doc(userId).set({'liked': true});

      // Menambah jumlah "like" di dokumen postingan
      await postRef.update({'likes': FieldValue.increment(1)});
    }
  }

  Future<void> addComment(String postId, String commentText) async {
    final CollectionReference commentsCollection = FirebaseFirestore.instance
        .collection('Posts')
        .doc(postId)
        .collection('Comments');

    final DocumentReference newCommentRef = commentsCollection.doc();

    await newCommentRef.set({
      'commentId': newCommentRef.id,
      'username': user!.displayName,
      'userId': user!.uid,
      'comment': commentText,
      'likes': 0,
      'timeStamp': FieldValue.serverTimestamp(),
    });

    final DocumentReference postRef =
        FirebaseFirestore.instance.collection('Posts').doc(postId);
    await postRef.update({'comments': FieldValue.increment(1)});
  }
}
