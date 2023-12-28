import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:me_halal/screens/detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteScreen extends StatefulWidget {
  final DatabaseReference databaseReference;

  const FavoriteScreen({Key? key, required this.databaseReference})
      : super(key: key);

  @override
  FavoriteScreenState createState() => FavoriteScreenState();
}

class FavoriteScreenState extends State<FavoriteScreen> {
  List<String> favoriteTitles = [];
  bool _isLoading = true;
  bool isSignedIn = false;

  @override
  void initState() {
    super.initState();
    _checkSignInStatus();
  }

  void _checkSignInStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool signedIn = prefs.getBool('isSignedIn') ?? false;
    setState(() {
      isSignedIn = signedIn;
      if (isSignedIn) {
        _loadFavoriteTitles();
      } else {
        _isLoading = false;
      }
    });
  }

  Future<void> _loadFavoriteTitles() async {
    if (isSignedIn) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Set<String> keys = prefs.getKeys();
      for (String key in keys) {
        if (key.startsWith('favorite_')) {
          String title = key.substring(9); // Remove 'favorite_' prefix
          favoriteTitles.add(title);
        }
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorites',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : favoriteTitles.isEmpty
          ? const Center(
        child: Text('No favorites yet'),
      )
          : StreamBuilder<DatabaseEvent>(
        stream: widget.databaseReference.onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              !snapshot.hasError &&
              snapshot.data!.snapshot.value != null) {
            Map<dynamic, dynamic> posts =
            snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
            List<Widget> postWidgets = [];

            posts.forEach((key, value) {
              if (favoriteTitles.contains(value['title'])) {
                String? imageUrl = value['imageUrl'];
                Widget leadingWidget = imageUrl != null
                    ? Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                )
                    : Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey,
                  child: const Icon(Icons.image,
                      color: Colors.white),
                );

                postWidgets.addAll([
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(
                            title: value['title'],
                            description: value['description'],
                            imageUrl: value['imageUrl'],
                          ),
                        ),
                      );
                    },
                    leading: leadingWidget,
                    title: Text(
                      value['title'],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          value['description'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                ]);
              }
            });

            return ListView(
                children: postWidgets.isNotEmpty
                    ? postWidgets
                    : [const SizedBox()]);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
