import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:convert';
import 'dart:io';
import 'LoginPage.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ImageProvider<Object>? _imageProvider;
  String _displayname = '';
  String _email = '';
  String _uid = '';
  String _imagePath = '';

  File? _image;

  final picker = ImagePicker();

  Future getImage(ImageSource media) async {
    final XFile? img = await picker.pickImage(source: media);

    if (img != null) {
      setState(() {
        _image = File(img.path);
        _imageProvider = FileImage(_image!);
      });
    }
  }

  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Please choose media to select'),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.image),
                        Text('From Gallery'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera),
                        Text('From Camera'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<String> getDisplayName(String userId) async {
    String displayName = '';

    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

        if (data != null && data.containsKey('displayName')) {
          displayName = data['displayName'];
        }
      }
    } catch (error) {
      print('Error fetching display name: $error');
    }

    return displayName;
  }

  Future<String> getImageAsBase64(String imagePath) async {
    File imageFile = File(imagePath);
    List<int> imageBytes = await imageFile.readAsBytes();
    String base64Image = base64Encode(imageBytes);
    return base64Image;
  }

  Future<String> getEmail(String userId) async {
    String email = '';

    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

        if (data != null && data.containsKey('email')) {
          email = data['email'];
        }
      }
    } catch (error) {
      print('Error fetching display name: $error');
    }

    return email;
  }

  Future<String> getUserID(String userId) async {
    String uid = '';

    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

        if (data != null && data.containsKey('uid')) {
          uid = data['uid'];
        }
      }
    } catch (error) {
      print('Error fetching display name: $error');
    }

    return uid;
  }

  Future<void> fetchCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String displayName = await getDisplayName(user.uid);
      String email = await getEmail(user.uid);
      String uid = await getUserID(user.uid);

      setState(() {
        _displayname = displayName;
        _email = email;
        _uid = uid;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 189, 32, 32),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 60),
            CircleAvatar(
              radius: 100,
              backgroundImage: _imageProvider != null
                  ? _imageProvider!
                  : NetworkImage(_imagePath),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: myAlert,
              child: Text('Change Profile Picture'),
            ),
            SizedBox(height: 20),
            Text('$_displayname',
                style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w600)),
            SizedBox(height: 10),
            Text(
              'WNI',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.fromLTRB(20.0, 20.0 * 2, 20.0, 190.5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(50.0)),
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              child: Column(children: [
                ListTile(
                  leading: Icon(Icons.email),
                  title: Text('$_email'),
                ),
                ListTile(
                  leading: Icon(Icons.card_membership_rounded),
                  title: Text('$_uid'),
                ),
                SizedBox(height: 40),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
