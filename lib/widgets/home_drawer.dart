import 'package:crud2a/pages/login_page.dart';
import 'package:crud2a/pages/change_later.dart';
import 'package:crud2a/pages/my_items_page.dart';
import 'package:crud2a/pages/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    final bool isAuthenticated = user != null;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              '${Provider.of<String>(context)}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          if (isAuthenticated) ...[
            ListTile(
                leading: Icon(Icons.note),
                title: Text('My Items'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyItemsPage()),
                  );
                }),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Sign Out'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();

                Navigator.pushNamed(context, '/');
              },
            ),
          ],
          if (!isAuthenticated) ...[
            ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Login'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                }),
            ListTile(
                leading: Icon(Icons.account_circle),
                title: Text('Register'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                }),
          ],
        ],
      ),
    );
  }
}
