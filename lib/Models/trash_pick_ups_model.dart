import 'package:cloud_firestore/cloud_firestore.dart';

class TrashPickUpsModel {
  final String trashID;
  final String postedDate;
  final String trashName;
  final String trashDescription;
  final String trashImage;
  final List trashTypes;
  final String trashLocationAddress;
  final GeoPoint trashLocationLocation;
  final String startDate;
  final String returnDate;
  final String startTime;
  final String returnTime;

  TrashPickUpsModel({
    required this.trashID,
    required this.postedDate,
    required this.trashName,
    required this.trashDescription,
    required this.trashImage,
    required this.trashTypes,
    required this.trashLocationAddress,
    required this.trashLocationLocation,
    required this.startDate,
    required this.returnDate,
    required this.startTime,
    required this.returnTime,
  });

  factory TrashPickUpsModel.fromDocument(DocumentSnapshot documentSnapshot) {
    return TrashPickUpsModel(
      trashID: documentSnapshot['trashID'],
      postedDate: documentSnapshot['postedDate'],
      trashName: documentSnapshot['trashName'],
      trashDescription: documentSnapshot['trashDescription'],
      trashImage: documentSnapshot['trashImage'],
      trashTypes: documentSnapshot['trashTypes'],
      trashLocationAddress: documentSnapshot['trashLocationAddress'],
      trashLocationLocation: documentSnapshot['trashLocationLocation'],
      startDate: documentSnapshot['startDate'],
      returnDate: documentSnapshot['returnDate'],
      startTime: documentSnapshot['startTime'],
      returnTime: documentSnapshot['returnTime'],
    );
  }
}
