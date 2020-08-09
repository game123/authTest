import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud2a/models/item.dart';
import 'package:crud2a/pages/create_item_page.dart';
import 'package:crud2a/pages/items_show_page.dart';
import 'package:crud2a/pages/login_page.dart';
import 'package:crud2a/widgets/home_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    final bool isAuthenticated = user != null;

    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      drawer: HomeDrawer(),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collectionGroup('items')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Text('Loading...');
            default:
              return ListView(
                children:
                    snapshot.data.documents.map((DocumentSnapshot document) {
                  final item = Item.fromFirestore(document);

                  return ListTile(
                    title: Text(
                      item.title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(item.content),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ItemsShowPage(item: item),
                        ),
                      );
                    },
                  );
                }).toList(),
              );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isAuthenticated) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateItemPage()),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          }
        },
        tooltip: 'New Item',
        child: Icon(Icons.note_add),
      ),
    );
  }
}
