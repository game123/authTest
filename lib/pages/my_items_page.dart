import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud2a/pages/items_edit_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:crud2a/models/item.dart';
import 'package:crud2a/pages/items_show_page.dart';
import 'package:provider/provider.dart';

class MyItemsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Items'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection("users")
            .document(user.uid)
            .collection("items")
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
                    trailing: PopupMenuButton(
                      onSelected: (result) async {
                        final type = result["type"];
                        final item = result["value"];
                        switch (type) {
                          case 'edit':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ItemsEditPage(item: item),
                              ),
                            );
                            break;
                          case 'delete':
                            await Firestore.instance
                                .collection('users')
                                .document(user.uid)
                                .collection('items')
                                .document(item.id)
                                .delete();
                            break;
                        }
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                        PopupMenuItem(
                          value: {"type": "edit", "value": item},
                          child: Text('Edit'),
                        ),
                        PopupMenuItem(
                          value: {"type": "delete", "value": item},
                          child: Text('Delete'),
                        ),
                      ],
                    ),
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
    );
  }
}
