import 'package:flutter/material.dart';
import 'package:crud2a/models/item.dart';

class ItemsShowPage extends StatefulWidget {
  ItemsShowPage({Key key, @required this.item}) : super(key: key);
  final Item item;

  @override
  _ItemsShowPageState createState() => _ItemsShowPageState();
}

class _ItemsShowPageState extends State<ItemsShowPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ItemsShow Page"),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Title is ... ${widget.item.title}"),
          Text("CreatedAt: ${widget.item.createdAt.toDate()}"),
        ],
      )),
    );
  }
}
