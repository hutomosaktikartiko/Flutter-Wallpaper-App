import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wallyapp/config/config.dart';
import 'package:wallyapp/pages/add_wallpaper_page.dart';
import 'package:wallyapp/pages/wallpaper_detail_page.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser _user;

  final Firestore _db = Firestore.instance;

  @override
  void initState() {
    fetchUserData();
    super.initState();
  }

  void fetchUserData() async {
    FirebaseUser u = await _auth.currentUser();
    setState(() {
      _user = u;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: _user != null
            ? Column(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: FadeInImage(
                      width: 200,
                      height: 200,
                      placeholder: AssetImage("assets/placeholder.jpg"),
                      image: NetworkImage("${_user.photoUrl}"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("${_user.displayName}"),
                  RaisedButton(
                    onPressed: () {
                      _auth.signOut();
                    },
                    child: Text("Logout"),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("My Wallpapers"),
                        IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddWallpaperPage(),
                                      fullscreenDialog: true));
                            })
                      ],
                    ),
                  ),
                  StreamBuilder(
                      stream: _db
                          .collection("wallpapers")
                          .where("uploaded_by", isEqualTo: _user.uid)
                          .orderBy("date", descending: true)
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                                          builder: (context) =>
                                              WallpaperDetailPage(
                                                image: snapshot
                                                    .data
                                                    .documents[index]
                                                    .data['url'],
                                              )));
                                },
                                child: Hero(
                                  tag: snapshot
                                      .data.documents[index].data['url'],
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
              )
            : LinearProgressIndicator(),
      ),
    );
  }
}
