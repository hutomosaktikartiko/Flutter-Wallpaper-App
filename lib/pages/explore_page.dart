import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wallyapp/config/config.dart';
import 'package:wallyapp/pages/wallpaper_detail_page.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ExplorePage extends StatefulWidget {
  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  // var image = [
  //   "https://images.unsplash.com/photo-1540071870804-6264aa727cf7?ixlib=rb-1.2.1&auto=format&fit=crop&w=376&q=80",
  //   "https://images.unsplash.com/photo-1561398024-910a2c6cf1a3?ixlib=rb-1.2.1&auto=format&fit=crop&w=750&q=80",
  //   "https://images.unsplash.com/photo-1594905103927-de6aacc5c9d8?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=334&q=80",
  //   "https://images.unsplash.com/photo-1594899756066-46964fff3add?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80",
  //   "https://images.unsplash.com/photo-1593106578502-27fa8479d060?ixlib=rb-1.2.1&auto=format&fit=crop&w=375&q=80",
  //   "https://images.unsplash.com/photo-1594878323962-561fbd6357d9?ixlib=rb-1.2.1&auto=format&fit=crop&w=334&q=80",
  //   "https://images.unsplash.com/photo-1594878323863-3781779efca6?ixlib=rb-1.2.1&auto=format&fit=crop&w=334&q=80",
  // ];

  final Firestore _db = Firestore.instance;
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
                "Explore",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
            ),
            StreamBuilder(
                stream: _db
                    .collection("wallpapers")
                    .orderBy("date", descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return StaggeredGridView.countBuilder(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
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
                                          data: snapshot.data.documents[index],
                                        )));
                          },
                          child: Hero(
                            tag: snapshot.data.documents[index].data['url'],
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              // child: Image(image: NetworkImage(image[index]))
                              child: CachedNetworkImage(
                                  placeholder: (ctx, url) => Image(
                                      image:
                                          AssetImage("assets/placeholder.jpg")),
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
            SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}
