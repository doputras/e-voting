import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailCategory extends StatefulWidget {
  const DetailCategory({Key? key, required this.namakategori, required this.id})
      : super(key: key);
  final int id;
  final String namakategori;

  @override
  State<DetailCategory> createState() => _DetailCategoryState();
}

class _DetailCategoryState extends State<DetailCategory> {
  List<Candidate> _candidates = [];
  List<Candidate> calon = [];

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('candidates')
        .snapshots()
        .listen((event) {
      if (event.docs.isNotEmpty) {
        setState(() {
          _candidates = event.docs
              .map((doc) => Candidate.fromDocumentSnapshot(doc))
              .toList();
        });
      }
    });
  }

  void _voteForCandidate(Candidate candidate) {
    FirebaseFirestore.instance
        .collection('candidates')
        .doc(candidate.name)
        .update({
      'votes': candidate.votes + 1,
    }).then((_) {
      setState(() {
        // Update the local _candidates list with the updated vote count
        final index = _candidates.indexWhere((c) => c.name == candidate.name);
        if (index != -1) {
          _candidates[index].votes += 1;
        }
      });
    }).catchError((error) {
      print('Failed to update vote count: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    int jumlahCandidate = 0;

    // Calculate jumlahCandidate
    for (int i = 0; i < _candidates.length; i++) {
      if (_candidates[i].catID == widget.id) {
        calon.add(_candidates[i]);
        jumlahCandidate++;
      }
    }

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 189, 32, 32),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () async {
                      await Future.delayed(Duration(milliseconds: 300));
                      Navigator.pop(context);
                    },
                    child: Ink(
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromARGB(255, 255, 255, 255),
                              width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_outlined,
                          color: Color.fromARGB(255, 255, 255, 255),
                          size: 15,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text('${widget.namakategori}',
                        style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600)),
                  ),
                  Container(
                    width: 30,
                    height: 35,
                  ),
                ],
              ),
            ),
            Container(margin: EdgeInsets.only(top: 20.0)),
            Text("Candidates",
                style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 33,
                    fontWeight: FontWeight.w700)),
            Center(
              child: Container(
                padding:
                    EdgeInsets.fromLTRB(20.0, 20.0 * 2, 20.0, 20.0 * 20.222),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(50.0)),
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                child: Container(
                  margin: EdgeInsets.all(0),
                  height: 240, // Update the height
                  width: 400.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  child: ListView.builder(
                    itemCount:
                        jumlahCandidate, // Use jumlahCandidate as the itemCount
                    itemBuilder: (context, index) {
                      final candidate = calon[index];
                      return Column(
                        children: [
                          ListTile(
                            leading: Container(
                              alignment: Alignment.topLeft,
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(candidate.avatar),
                                ),
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: Colors.white,
                                  style: BorderStyle.solid,
                                  width: 2,
                                ),
                              ),
                            ),
                            title: Text(
                              candidate.name,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text('${candidate.votes} votes'),
                            trailing: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Color.fromARGB(255, 189, 32, 32),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15))),
                              onPressed: () {
                                _voteForCandidate(candidate);
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Vote Sukses'),
                                      content:
                                          Text("Berhasil Menambahkan vote!"),
                                      backgroundColor: Colors.grey[200],
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      actions: [
                                        TextButton(
                                          child: Text(
                                            'Close',
                                            style: GoogleFonts.montserrat(
                                                color: Color.fromARGB(
                                                    255, 189, 32, 32),
                                                fontSize: 14),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // Close the dialog
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Text(
                                'Vote',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(
                              height: 10), // Tambahkan SizedBox di dalam Column
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Candidate {
  final String name;
  int votes;
  final int catID;
  final String avatar;

  Candidate(
      {required this.name,
      required this.votes,
      required this.catID,
      required this.avatar});

  factory Candidate.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    final data = documentSnapshot.data() as Map<String, dynamic>;
    final name = documentSnapshot.id;
    final votes = data['votes'] ?? 0;
    final catID = data['catID'] ?? 0;
    final avatar = data['avatar'] ?? '';
    return Candidate(name: name, votes: votes, catID: catID, avatar: avatar);
  }
}
