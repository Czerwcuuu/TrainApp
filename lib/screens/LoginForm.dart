import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/main.dart';

//Logowanie
class LoginForm extends StatefulWidget {
  @override
  LoginFormStatement createState() {
    return LoginFormStatement();
  }
}

class LoginFormStatement extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController user = new TextEditingController();
  TextEditingController pass = new TextEditingController();
  FToast fToast;
  static var userId;

  //initialize FlutterToast
  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  //login
  Future login() async {
    var url = "http://127.0.0.1/train_app_login/train_app_login.php";
    var response = await http.post(url, body: {
      "username": user.text,
      "password": pass.text,
    });

    var data = json.decode(response.body);
    var id = int.parse(data);
    if (id > 0) {
      //print(id);
      userId = id;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Home(),
        ),
      );
    } else {
      //print(id);
      fToast.showToast(
          child: Text('Zły login lub hasło',
              style: TextStyle(fontSize: 25, color: Colors.red)));
    }
  }

  //login form
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextFormField(
                controller: user,
                textAlign: TextAlign.center,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Login nie został wprowadzony!';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Wprowadź login',
                ),
              ),
              TextFormField(
                controller: pass,
                textAlign: TextAlign.center,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Hasło nie zostało wprowadzone!';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Wprowadź hasło',
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: Colors.black87,
        child: Container(
          height: 65.0,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black87,
        onPressed: () => login(),
        tooltip: 'Zaloguj',
        child: Icon(Icons.arrow_right_rounded, size: 50),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
