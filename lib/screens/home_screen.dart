import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:me_halal/screens/detail_screen.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final DatabaseReference databaseReference;

  const HomeScreen({super.key, required this.databaseReference});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<Map<dynamic, dynamic>> posts = [];
  late RefreshController _refreshController;
  bool isLoading = true;
  bool _isSignedIn = false;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: false);
    _checkSignInStatus();
    _loadData();
  }

  // Metode untuk memeriksa status sign in
  void _checkSignInStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isSignedIn = prefs.getBool('isSignedIn') ?? false;

    setState(() {
      _isSignedIn = isSignedIn; // Perbarui status sign in
    });
  }

  Future<void> _loadData() async {
    try {
      DataSnapshot snapshot = (await widget.databaseReference.once()).snapshot;

      if (snapshot.value != null && snapshot.value is Map<dynamic, dynamic>) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        List<Map<dynamic, dynamic>> newData = [];

        data.forEach((key, value) {
          newData.add({
            'title': value['title'],
            'description': value['description'],
            'imageUrl': value['imageUrl'],
          });
        });

        setState(() {
          posts = newData;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Failed to load data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _onRefresh() async {
    await _loadData();
    _refreshController.refreshCompleted();
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isSignedIn', false);

      // Mengambil kunci yang berawalan 'favorite_' untuk menghapus data favorit
      Set<String> keys = prefs.getKeys();
      for (String key in keys) {
        if (key.startsWith('favorite_')) {
          prefs.remove(key);
        }
      }

      // Navigasi ke halaman utama setelah sign-out berhasil
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    } catch (e) {
      print('Error during sign-out: $e');
      // Handle error
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home Screen',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (_isSignedIn) // Tampilkan tombol jika pengguna sudah sign in
            IconButton(
              onPressed: () {
                // Panggil method signOut ketika tombol di tekan
                signOut();
              },
              icon: const Icon(Icons.exit_to_app),
            ),
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        enablePullDown: true,
        header: const WaterDropMaterialHeader(),
        child: posts.isEmpty
            ? Center(
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('No post yet'),
              )
            : ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  Map<dynamic, dynamic> post = posts[index];
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(
                            title: post['title'],
                            description: post['description'],
                            imageUrl: post['imageUrl'],
                          ),
                        ),
                      );
                    },
                    leading: post['imageUrl'] != null
                        ? Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              image: DecorationImage(
                                image: NetworkImage(post['imageUrl']),
                                fit: BoxFit.cover,
                              ),
                              border: Border.all(color: Colors.teal.shade100),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          )
                        : Container(
                            width: 80,
                            height: 80,
                            color: Colors.grey,
                            child: const Icon(Icons.image, color: Colors.white),
                          ),
                    title: Text(
                      post['title'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          post['description'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}