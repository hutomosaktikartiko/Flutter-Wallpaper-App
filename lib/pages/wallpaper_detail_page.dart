import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:share/share.dart';
import 'package:wallyapp/config/config.dart';

class WallpaperDetailPage extends StatefulWidget {
  final DocumentSnapshot data;

  WallpaperDetailPage({this.data});
  @override
  _WallpaperDetailPageState createState() => _WallpaperDetailPageState();
}

class _WallpaperDetailPageState extends State<WallpaperDetailPage> {
  final Firestore _db = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    List<dynamic> tags = widget.data["tags"].toList();
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              Container(
                child: Hero(
                  tag: widget.data['url'],
                  child: CachedNetworkImage(
                      placeholder: (ctx, url) =>
                          Image(image: AssetImage("assets/placeholder.jpg")),
                      imageUrl: widget.data['url']),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: tags.map((tag) {
                    return Chip(
                      label: Text(tag),
                    );
                  }).toList(),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Wrap(spacing: 10, runSpacing: 10, children: [
                    RaisedButton.icon(
                      onPressed: _launchURL,
                      icon: Icon(
                        Icons.file_download,
                      ),
                      label: Text("Get wallpaper"),
                    ),
                    RaisedButton.icon(
                      onPressed: _createDynamicLink,
                      icon: Icon(
                        Icons.share,
                      ),
                      label: Text("Share"),
                    ),
                    RaisedButton.icon(
                      onPressed: _addToFavorite,
                      icon: Icon(Icons.favorite_border),
                      label: Text("Favorite"),
                    ),
                  ])),
            ],
          ),
        ),
      ),
    );
  }

  void _launchURL() async {
    try {
      await launch(widget.data["url"],
          option: CustomTabsOption(toolbarColor: primaryColor));
    } catch (e) {
      print(e);
    }
  }

  void _addToFavorite() async {
    FirebaseUser user = await _auth.currentUser();

    String uid = user.uid;

    _db
        .collection("users")
        .document(uid)
        .collection("favorites")
        .document(widget.data.documentID)
        .setData(widget.data.data);
  }

  void _createDynamicLink() async {
    DynamicLinkParameters dynamicLinkParameters = DynamicLinkParameters(
        uriPrefix: "https://walyapp.page.link",
        link: Uri.parse(widget.data.documentID),
        androidParameters: AndroidParameters(
            packageName: "com.example.wallyapp", minimumVersion: 0),
        socialMetaTagParameters: SocialMetaTagParameters(
            title: "WalllyApp",
            description: "An app for cool wallpapers",
            imageUrl: Uri.parse(widget.data["url"])));

    Uri uri = await dynamicLinkParameters.buildUrl();

    String url = uri.toString();
    print(url);

    Share.share(url);
  }
}
