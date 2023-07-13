import 'package:cloud_firestore/cloud_firestore.dart';

class ArticlesModel {
  final String articleID;
  final String articleDescription;
  final String articleImage;
  final String articleLink;
  final String articlePostedDate;
  final String articleTitle;

  ArticlesModel({
    required this.articleID,
    required this.articleDescription,
    required this.articleImage,
    required this.articleLink,
    required this.articlePostedDate,
    required this.articleTitle,
  });

  factory ArticlesModel.fromDocument(DocumentSnapshot documentSnapshot) {
    return ArticlesModel(
      articleID: documentSnapshot['articleID'],
      articleDescription: documentSnapshot['articleDescription'],
      articleImage: documentSnapshot['articleImage'],
      articleLink: documentSnapshot['articleLink'],
      articlePostedDate: documentSnapshot['articlePostedDate'],
      articleTitle: documentSnapshot['articleTitle'],
    );
  }
}
