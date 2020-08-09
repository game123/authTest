import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:crud2a/models/item.dart';
import 'package:provider/provider.dart';

class ItemsEditPage extends StatefulWidget {
  ItemsEditPage({Key key, @required this.item}) : super(key: key);
  final Item item;

  @override
  _ItemsEditPageState createState() => _ItemsEditPageState();
}

class _ItemsEditPageState extends State<ItemsEditPage> {
  final GlobalKey<FormState> _editItemFormKey_ = GlobalKey<FormState>();
  final titleInputController = TextEditingController();
  final contentInputController = TextEditingController();

  bool _isSubmitting = false;

  @override
  initState() {
    titleInputController.text = widget.item.title;
    contentInputController.text = widget.item.content;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Edit Item"),
        ),
        body: Container(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
                child: Form(
              key: _editItemFormKey_,
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
                  SizedBox(height: 20),
                  _isSubmitting
                      ? Center(child: CircularProgressIndicator())
                      : RaisedButton(
                          child: Text("Update Item"),
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                          onPressed: () async {
                            if (_editItemFormKey_.currentState.validate()) {
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
                                    .document(widget.item.id)
                                    .updateData({
                                  "title": titleInputController.text,
                                  "content": contentInputController.text,
                                  "updatedAt": FieldValue.serverTimestamp()
                                });

                                Navigator.pop(context);
                              } catch (e) {
                                print('Error Happened!!!: $e');
                                setState(() {
                                  _isSubmitting = false;
                                });
                              }
                            }
                          },
                        ),
                ],
              ),
            ))));
  }
}
