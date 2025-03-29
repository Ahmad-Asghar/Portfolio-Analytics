import 'package:cloud_firestore/cloud_firestore.dart';

class ContactMessagesModel {
  final String visitorId; // New field for document ID
  final String? name;
  final String? email;
  final String? message;
  final Timestamp? timestamp;

  ContactMessagesModel({
    required this.visitorId, // Make it required
    this.name,
    this.email,
    this.message,
    this.timestamp,
  });

  // Convert JSON to Model
  factory ContactMessagesModel.fromJson(Map<String, dynamic> json,String id) {
    return ContactMessagesModel(
      visitorId: id, // Assign Firestore document ID
      name: json['name'] as String?,
      email: json['email'] as String?,
      message: json['messageBody'] as String?,
      timestamp: json['timestamp'] as Timestamp?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'messageBody': message,
      'timestamp': timestamp,
    };
  }
}
