import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wallyapp/config/config.dart';
import 'package:wallyapp/pages/wallpaper_detail_page.dart';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  FirebaseUser user;

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  void _getUser() async {
    FirebaseUser u = await _auth.currentUser();
    setState(() {
      user = u;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(top: 5, left: 20, bottom: 20),
              child: Text(
                "Favorites",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
            ),
            if (user != null) ...[
              StreamBuilder(
                  stream: _db
                      .collection("users")
                      .document(user.uid)
                      .collection("favorites")
                      .orderBy("date", descending: true)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return StaggeredGridView.countBuilder(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        staggeredTileBuilder: (int index) =>
                            StaggeredTile.fit(1),
                        itemCount: snapshot.data.documents.length,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        itemBuilder: (ctx, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => WallpaperDetailPage(
                                            data:
                                                snapshot.data.documents[index],
                                          )));
                            },
                            child: Hero(
                              tag: snapshot.data.documents[index].data['url'],
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                // child: Image(image: NetworkImage(image[index]))
                                child: CachedNetworkImage(
                                    placeholder: (ctx, url) => Image(
                                        image: AssetImage(
                                            "assets/placeholder.jpg")),
                                    imageUrl: snapshot
                                        .data.documents[index].data['url']),
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return SpinKitChasingDots(
                      color: primaryColor,
                      size: 50,
                    );
                  }),
            ],
            SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}
