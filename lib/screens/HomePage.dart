import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tubesuts/screens/profile_page.dart';
import 'package:tubesuts/widgets/category.dart';
import 'package:google_fonts/google_fonts.dart';

import 'LoginPage.dart';
import 'MapPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Candidate> _candidates = [];
  List<CategoryPemilihan> _categoryPemilihan = [];
  List<CategoryPemilihan> _filteredCategoryPemilihan = [];
  String _displayname = '';
  String keyword = ' ';

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

  Future<void> fetchCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String displayName = await getDisplayName(user.uid);
      setState(() {
        _displayname = displayName;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCurrentUser();
    FirebaseFirestore.instance
        .collection('categoryPemilihan')
        .snapshots()
        .listen((event) {
      if (event.docs.isNotEmpty) {
        setState(() {
          _categoryPemilihan = event.docs
              .map((doc) => CategoryPemilihan.fromDocumentSnapshot(doc))
              .toList();
          _filteredCategoryPemilihan = _categoryPemilihan;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Container(
                    height: 140,
                    width: double.infinity,
                    color: Color.fromARGB(255, 189, 32, 32)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Row(
                              children: [
                                Container(
                                    alignment: Alignment.topLeft,
                                    height: 50,
                                    width: 45,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                "https://studiolorier.com/wp-content/uploads/2018/10/Profile-Round-Sander-Lorier.jpg")),
                                        borderRadius: BorderRadius.circular(25),
                                        border: Border.all(
                                            color: Colors.white,
                                            style: BorderStyle.solid,
                                            width: 2))),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Halo $_displayname, Selamat Datang !",
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white, fontSize: 18),
                                )
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.logout,
                                color: Color.fromARGB(255, 255, 255, 255)),
                            onPressed: () async {
                              await FirebaseAuth.instance.signOut();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Color(0xFFF5F5F7),
                            borderRadius: BorderRadius.circular(30)),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              keyword = value;
                              _filteredCategoryPemilihan = _categoryPemilihan
                                  .where((category) => category.nama
                                      .toLowerCase()
                                      .contains(keyword.toLowerCase()))
                                  .toList();
                            });
                          },
                          cursorHeight: 20,
                          autofocus: false,
                          decoration: InputDecoration(
                              hintText: "Cari Pemilihan",
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey, width: 2),
                                  borderRadius: BorderRadius.circular(30))),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child:
                  Text("Category", style: GoogleFonts.montserrat(fontSize: 17)),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 182, 29, 18),
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MapPage()),
                      );
                    },
                    icon: Icon(Icons.map),
                    label: Text('KPU Terdekat'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text("Daftar Pemilihan",
                  style: GoogleFonts.montserrat(fontSize: 17)),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: keyword.isEmpty
                  ? _categoryPemilihan.length
                  : _filteredCategoryPemilihan.length,
              itemBuilder: (context, index) {
                CategoryPemilihan category;
                if (keyword.isEmpty) {
                  category = _categoryPemilihan[index];
                } else {
                  category = _filteredCategoryPemilihan[index];
                }
                return Category(
                  imagePath: category.imagepath,
                  categoryName: category.nama,
                  id: category.id,
                );
              },
            ),
          ],
        )),
      ),
    );
  }
}

class Candidate {
  final String name;
  final int votes;
  final int catID;

  Candidate({required this.name, required this.votes, required this.catID});

  factory Candidate.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    final data = documentSnapshot.data() as Map<String, dynamic>;
    final name = documentSnapshot.id;
    final votes = data['votes'] ?? 0;
    final catID = data['catID'] ?? 0;
    return Candidate(name: name, votes: votes, catID: catID);
  }
}

class CategoryPemilihan {
  final int id;
  final String nama;
  final String imagepath;

  CategoryPemilihan(
      {required this.id, required this.nama, required this.imagepath});

  factory CategoryPemilihan.fromDocumentSnapshot(
      DocumentSnapshot documentSnapshot) {
    final data = documentSnapshot.data() as Map<String, dynamic>;
    final nama = data['nama'] ?? '';
    final id = data['id'] ?? 0;
    final imagepath = data['imagepath'] ?? '';
    return CategoryPemilihan(id: id, nama: nama, imagepath: imagepath);
  }
}
