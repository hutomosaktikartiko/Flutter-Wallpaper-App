import 'package:flutter/material.dart';
import 'package:wallyapp/pages/account_page.dart';
import 'package:wallyapp/pages/explore_page.dart';
import 'package:wallyapp/pages/favorite_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedPageIndex = 0;

  var _pages = [ExplorePage(), FavoritePage(), AccountPage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WallyApp"),
      ),
      body: _pages[_selectedPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.search), title: Text("Explore")),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), title: Text("Favorite")),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), title: Text("Account")),
        ],
        currentIndex: _selectedPageIndex,
        onTap: (index) {
          setState(() {
            _selectedPageIndex = index;
          });
        },
      ),
    );
  }
}
