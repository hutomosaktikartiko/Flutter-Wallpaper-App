import 'package:flutter/material.dart';

class ExplorePage extends StatefulWidget {
  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  var image = [
    "https://images.unsplash.com/photo-1540071870804-6264aa727cf7?ixlib=rb-1.2.1&auto=format&fit=crop&w=376&q=80",
    "https://images.unsplash.com/photo-1594905103927-de6aacc5c9d8?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=334&q=80",
    "https://images.unsplash.com/photo-1542641197-cdc5b5d1923f?ixlib=rb-1.2.1&auto=format&fit=crop&w=401&q=80",
    "https://images.unsplash.com/photo-1593106578502-27fa8479d060?ixlib=rb-1.2.1&auto=format&fit=crop&w=375&q=80",
    "https://images.unsplash.com/photo-1594878323962-561fbd6357d9?ixlib=rb-1.2.1&auto=format&fit=crop&w=334&q=80",
    "https://images.unsplash.com/photo-1594878323863-3781779efca6?ixlib=rb-1.2.1&auto=format&fit=crop&w=334&q=80",
  ];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              childAspectRatio: 9 / 16,
              children: image.map((e) {
                return Image(
                  image: NetworkImage(e),
                  fit: BoxFit.cover,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
