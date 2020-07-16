import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser _user;

  var image = [
    "https://images.unsplash.com/photo-1540071870804-6264aa727cf7?ixlib=rb-1.2.1&auto=format&fit=crop&w=376&q=80",
    "https://images.unsplash.com/photo-1594905103927-de6aacc5c9d8?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=334&q=80",
    "https://images.unsplash.com/photo-1542641197-cdc5b5d1923f?ixlib=rb-1.2.1&auto=format&fit=crop&w=401&q=80",
    "https://images.unsplash.com/photo-1593106578502-27fa8479d060?ixlib=rb-1.2.1&auto=format&fit=crop&w=375&q=80",
    "https://images.unsplash.com/photo-1594878323962-561fbd6357d9?ixlib=rb-1.2.1&auto=format&fit=crop&w=334&q=80",
    "https://images.unsplash.com/photo-1594878323863-3781779efca6?ixlib=rb-1.2.1&auto=format&fit=crop&w=334&q=80",
  ];

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
                        IconButton(icon: Icon(Icons.add), onPressed: () {})
                      ],
                    ),
                  ),
                  StaggeredGridView.countBuilder(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
                    itemCount: image.length,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    itemBuilder: (ctx, index) {
                      return ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image(image: NetworkImage(image[index])));
                    },
                  ),
                ],
              )
            : LinearProgressIndicator(),
      ),
    );
  }
}
