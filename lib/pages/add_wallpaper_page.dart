import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class AddWallpaperPage extends StatefulWidget {
  @override
  _AddWallpaperPageState createState() => _AddWallpaperPageState();
}

class _AddWallpaperPageState extends State<AddWallpaperPage> {
  File _image;

  final ImageLabeler labeler = FirebaseVision.instance.imageLabeler();

  List<String> labelInString = [];

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  bool _isUploading = false;
  bool _isCompletedUploading = false;

  @override
  void dispose() {
    labeler.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Wallpaper"),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              InkWell(
                onTap: _loadImage,
                child: _image != null
                    ? Image.file(_image)
                    : Image(image: AssetImage("assets/placeholder.jpg")),
              ),
              SizedBox(
                height: 5,
              ),
              Text("Click on Image to upload wallpaper"),
              SizedBox(
                height: 15,
              ),
              labelInString.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Wrap(
                        spacing: 10,
                        children: labelInString.map((label) {
                          return Chip(
                            label: Text(label),
                          );
                        }).toList(),
                      ),
                    )
                  : Container(),
              SizedBox(height: 30),
              if (_isUploading) ...[Text('Uploading wallpaper...')],
              if (_isCompletedUploading) ...[Text("Upload Completed.")],
              SizedBox(height: 30),
              RaisedButton(
                onPressed: () {
                  _uploadWallpaper();
                },
                child: Text("Upload Wallpaper"),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _loadImage() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 30);

    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(image);

    List<ImageLabel> labels = await labeler.processImage(visionImage);

    labelInString = [];
    for (var label in labels) {
      labelInString.add(label.text);
    }

    setState(() {
      _image = image;
    });
  }

  void _uploadWallpaper() async {
    if (_image != null) {
      String fileName = path.basename(_image.path);
      print(fileName);

      FirebaseUser user = await _auth.currentUser();
      String uid = user.uid;

      StorageUploadTask task = _storage
          .ref()
          .child("wallpapers")
          .child(uid)
          .child(fileName)
          .putFile(_image);

      task.events.listen((event) {
        if (event.type == StorageTaskEventType.progress) {
          setState(() {
            _isUploading = true;
          });
        }
        if (event.type == StorageTaskEventType.success) {
          setState(() {
            _isCompletedUploading = true;
            _isUploading = false;
          });
          event.snapshot.ref.getDownloadURL().then((url) {
            _db.collection("wallpapers").add({
              "url": url,
              "date": DateTime.now(),
              "uploaded_by": uid,
              "tags": labelInString
            });
            Navigator.of(context).pop();
          });
        }
      });
    } else {
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              title: Text("Error"),
              content: Text('Select image to upload...'),
              actions: <Widget>[
                RaisedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Ok"),
                )
              ],
            );
          });
    }
  }
}
