import 'package:cloud_firestore/cloud_firestore.dart';
import 'table_models/newsletter_subscriber.dart';

const String subscriber = 'newsletter_subscriber';

class CollectWPUser {
  final _firestore = FirebaseFirestore.instance;

  late final CollectionReference _NewsLetter_SubscriberRef;

  CollectWPUser() {
    _NewsLetter_SubscriberRef = _firestore.collection(subscriber).withConverter<NewsLetter_Subscriber>(
      fromFirestore: (snapshots, _) => NewsLetter_Subscriber.fromJson(
        snapshots.data()!,
      ),
      toFirestore: (NewsLetter_Subscriber, _) => NewsLetter_Subscriber.toJson());
  }

  Stream<QuerySnapshot> getNewsLetter_Subscriber() {
    return _NewsLetter_SubscriberRef.snapshots();
  }

  Future<void> addNewsLetter_Subscriber(NewsLetter_Subscriber NewsLetter_Subscriber) async {
    await _NewsLetter_SubscriberRef.add(NewsLetter_Subscriber);
  }
}