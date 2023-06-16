import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tubesuts/screens/DetailCategory.dart';

class Category extends StatelessWidget {
  final String imagePath;
  final String categoryName;
  final int id;
  const Category(
      {Key? key,
      required this.imagePath,
      required this.categoryName,
      required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        height: 250,
        child: Stack(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailCategory(
                              id: id,
                              namakategori: categoryName,
                            )));
              },
              child: Ink(
                child: Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 10,
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 150,
                        child: Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Image.network(imagePath, fit: BoxFit.contain),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
                bottom: 0,
                left: 10,
                child: SizedBox(
                  height: 70,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(categoryName,
                            style: GoogleFonts.montserrat(
                                fontSize: 17, fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                )),
          ],
        ));
  }
}
