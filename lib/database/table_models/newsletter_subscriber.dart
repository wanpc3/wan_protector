import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wan_protector/wan_protector/wan_protector.dart';

class NewsLetter_Subscriber {
  final int? newsletter_id;
  final String email;
  final String newsletter;
  final Timestamp created_at;

  NewsLetter_Subscriber({
    this.newsletter_id,
    required this.email,
    required this.newsletter,
    required this.created_at,
  });

  NewsLetter_Subscriber.fromJson(Map<String, Object?> json)
    : this(
      newsletter_id: json['newsletter_id']! as int?,
      email: json['email']! as String,
      newsletter: json['newsletter']! as String,
      created_at: json['created_at']! as Timestamp,
  );

  NewsLetter_Subscriber copyWith({
    int? newsletter_id,
    String? email,
    String? newsletter,
    Timestamp? created_at,
  }) {
    return NewsLetter_Subscriber(
      newsletter_id: newsletter_id ?? this.newsletter_id,
      email: email ?? this.email,
      newsletter: newsletter ?? this.newsletter,  
      created_at: created_at ?? this.created_at);
  }

  Map<String, Object?> toJson({bool includeId = false}) {
    final Map<String, Object?> WanProtectorUser = {
      'email': email,
      'newsletter': newsletter,
      'created_at': created_at,
    };
    if (includeId && newsletter_id != null) {
      WanProtectorUser['newsletter_id'] = newsletter_id as Object?;
    }
    return WanProtectorUser;
  }
}