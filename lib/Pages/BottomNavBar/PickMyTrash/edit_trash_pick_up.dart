import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:EcoSaver/Generators/uui_generator.dart';
import 'package:EcoSaver/Models/user_model.dart';
import 'package:EcoSaver/Pages/BottomNavBar/PickMyTrash/pick_trash_location.dart';
import 'package:EcoSaver/Theme/theme_provider.dart';
import 'package:EcoSaver/Widgets/button_widgets.dart';
import 'dart:io';
import 'package:EcoSaver/Widgets/primary_app_bar_widget.dart';
import 'package:EcoSaver/Widgets/secondary_app_bar_widget.dart';
import 'package:EcoSaver/Widgets/toast_messages.dart';
import '../bottom_nav_bar.dart';

class EditTrashPickUp extends StatefulWidget {
  final String userID, trashID;

  EditTrashPickUp(this.userID, this.trashID);

  @override
  _EditTrashPickUpState createState() => _EditTrashPickUpState();
}

class _EditTrashPickUpState extends State<EditTrashPickUp> {
  final _formKey = GlobalKey<FormState>();
  String _trashName = '';
  String _trashDescription = '';
  // Add other fields as needed

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Trash Pick Up'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Trash Name'),
                initialValue: _trashName,
                onChanged: (value) {
                  setState(() {
                    _trashName = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a trash name';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Trash Description'),
                initialValue: _trashDescription,
                onChanged: (value) {
                  setState(() {
                    _trashDescription = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a trash description';
                  }
                  return null;
                },
              ),
              // Add other fields as needed
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Save data to firebase
                    FirebaseFirestore.instance
                        .collection("Users")
                        .doc(widget.userID)
                        .collection('Trash Pick Ups')
                        .doc(widget.trashID)
                        .update({
                          'trashName': _trashName,
                          'trashDescription': _trashDescription,
                          // Add other fields as needed
                        })
                        .then((_) => Navigator.pop(context))
                        .catchError((error) => print('Update failed: $error'));
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
