import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateItemPage extends StatefulWidget {
  @override
  _CreateItemPageState createState() => _CreateItemPageState();
}

class _CreateItemPageState extends State<CreateItemPage> {
  final GlobalKey<FormState> _createNewFormKey = GlobalKey<FormState>();
  final titleInputController = TextEditingController();
  final contentInputController = TextEditingController();

  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ItemsNew Page"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _createNewFormKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration:
                      InputDecoration(labelText: 'Title*', hintText: "Title"),
                  controller: titleInputController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please enter a title.";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Content', hintText: "Item content here..."),
                  controller: contentInputController,
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: _isSubmitting
                      ? Center(child: CircularProgressIndicator())
                      : RaisedButton(
                          child: Text("Save Items"),
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                          onPressed: () async {
                            if (_createNewFormKey.currentState.validate()) {
                              try {
                                setState(() {
                                  _isSubmitting = true;
                                });

                                final user = Provider.of<FirebaseUser>(context,
                                    listen: false);

                                await Firestore.instance
                                    .collection('users')
                                    .document(user.uid)
                                    .collection("items")
                                    .document()
                                    .setData({
                                  "title": titleInputController.text,
                                  "content": contentInputController.text,
                                  "createdAt": FieldValue.serverTimestamp(),
                                  "updatedAt": FieldValue.serverTimestamp()
                                });

                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/', (Route<dynamic> route) => false);
                              } catch (e) {
                                print('Error Happened!!!: $e');
                                setState(() {
                                  _isSubmitting = false;
                                });
                              }
                            }
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
