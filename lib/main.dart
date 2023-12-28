import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:me_halal/firebase_options.dart';
import 'package:me_halal/screens/ayat_screen.dart';
import 'package:me_halal/screens/favorite_screen.dart';
import 'package:me_halal/screens/halal_screen.dart';
import 'package:me_halal/screens/home_screen.dart';
import 'package:me_halal/screens/search_screen.dart';
import 'package:me_halal/screens/sign_in_screen.dart';
import 'package:me_halal/screens/sign_up_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child('posts');
  runApp(MyApp(databaseReference: databaseReference));
}

class MyApp extends StatelessWidget {
  final DatabaseReference databaseReference;

  const MyApp({super.key, required this.databaseReference});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ME Halal',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: MeHalal(databaseReference: databaseReference,),
      initialRoute: '/',
      routes: {
        '/signin': (context) => const SignInScreen(),
        '/signup': (context) => const SignUpScreen(),
      },
    );
  }
}

class MeHalal extends StatefulWidget {
  final DatabaseReference databaseReference;
  const MeHalal({super.key, required this.databaseReference});

  @override
  MeHalalState createState() => MeHalalState();
}

class MeHalalState extends State<MeHalal> {
  int _currentIndex = 0;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(databaseReference: widget.databaseReference),
      const AyatScreen(),
      const SearchScreen(),
      FavoriteScreen(databaseReference: widget.databaseReference,),
      const HalalScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.teal[300],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[350],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Ayat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Halal',
          ),
        ],
      ),
    );
  }
}