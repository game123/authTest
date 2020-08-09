import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud2a/pages/login_page.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _registerFormKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register Page"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _registerFormKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration:
                    InputDecoration(labelText: 'Name', hintText: "John Doe"),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter name.";
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Email', hintText: "johnjackson@example.com"),
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter email';
                  } else if (!EmailValidator.validate(value)) {
                    return 'Please enter valid email';
                  }

                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                controller: _passwordController,
                obscureText: true,
                validator: (value) {
                  if (value != _passwordController.text) {
                    return 'Password is not matching';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Confirm Password'),
                controller: _confirmPasswordController,
                obscureText: true,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Confirm Pwd is not matching';
                  }
                  return null;
                },
              ),
              Container(
                margin: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                child: RaisedButton(
                  child: Text("Register"),
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  onPressed: () async {
                    if (_registerFormKey.currentState.validate()) {
                      try {
                        // Register user by firebase auth
                        final FirebaseUser user = (await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                    email: _emailController.text,
                                    password: _passwordController.text))
                            .user;
                        /* store users data in firestore database */
                        await Firestore.instance
                            .collection("users")
                            .document(user.uid)
                            .setData({
                          "name": _nameController.text,
                          "email": _emailController.text,
                          "createdAt": FieldValue.serverTimestamp(),
                          "updatedAt": FieldValue.serverTimestamp()
                        });

                        Navigator.pushNamed(context, '/');
                      } catch (e) {
                        print('Error Happened!!!: $e');
                      }
                    }
                  },
                ),
              ),
              Text("Already have an account?"),
              FlatButton(
                child: Text("Login here!"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              )
            ]),
          ),
        ),
      ),
    );
  }
}
