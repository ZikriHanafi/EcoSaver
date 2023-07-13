import 'package:cloud_firestore/cloud_firestore.dart';

class RecyclingCenterModel {
  final String id;
  final String name;
  final String address;
  final String phone;
  final GeoPoint location;

  RecyclingCenterModel({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.location,
  });

  factory RecyclingCenterModel.fromDocument(DocumentSnapshot documentSnapshot) {
    return RecyclingCenterModel(
      id: documentSnapshot['id'],
      name: documentSnapshot['name'],
      address: documentSnapshot['address'],
      phone: documentSnapshot['phone'],
      location: documentSnapshot['location'],
    );
  }
}
