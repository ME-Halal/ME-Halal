import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:me_halal/screens/detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final DatabaseReference databaseReference;

  const HomeScreen({super.key, required this.databaseReference});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home Screen',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: widget.databaseReference.onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              !snapshot.hasError &&
              snapshot.data!.snapshot.value != null) {
            Map<dynamic, dynamic> posts =
            snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
            List<Widget> postWidgets = [];

            posts.forEach((key, value) {
              // Check if imageUrl exists, if not, use a placeholder
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
                child: const Icon(Icons.image, color: Colors.white),
              );

              postWidgets.addAll(
                [
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
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          value['description'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                ],
              );
            });

            return ListView(
              children: postWidgets,
            );
          } else {
            return const Center(
              child: Text('No posts yet'),
            );
          }
        },
      ),
    );
  }
}

// import 'package:flutter/material.dart';
//
// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'ME Halal',
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//       ),
//       body: const Center(
//         child: Text('Belum ada informasi utama'),
//       ),
//     );
//   }
// }
