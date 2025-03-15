import 'package:cloud_firestore/cloud_firestore.dart';

class VisitorModel {
  final String? ip;
  final String? city;
  final String? region;
  final String? country;
  final String? loc;
  final String? org;
  final String? postal;
  final String? timezone;
  final String? readme;
  final Timestamp? timestamp;

  VisitorModel({
    this.ip,
    this.city,
    this.region,
    this.country,
    this.loc,
    this.org,
    this.postal,
    this.timezone,
    this.readme,
    this.timestamp,
  });

  // Convert JSON to Model
  factory VisitorModel.fromJson(Map<String, dynamic> json) {
    return VisitorModel(
      ip: json['ip'] as String?,
      city: json['city'] as String?,
      region: json['region'] as String?,
      country: json['country'] as String?,
      loc: json['loc'] as String?,
      org: json['org'] as String?,
      postal: json['postal'] as String?,
      timezone: json['timezone'] as String?,
      readme: json['readme'] as String?,
      timestamp: json['timestamp'] as Timestamp,
    );
  }

  // Convert Model to JSON (for Firestore)
  Map<String, dynamic> toJson() {
    return {
      'ip': ip,
      'city': city,
      'region': region,
      'country': country,
      'loc': loc,
      'org': org,
      'postal': postal,
      'timezone': timezone,
      'readme': readme,
      'timestamp': timestamp,
    };
  }
}
