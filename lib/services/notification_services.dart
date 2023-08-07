import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationServices {
  Stream<QuerySnapshot> getNotifications({required String userId}) =>
      FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .orderBy('added_on', descending: true)
          .snapshots();
}
