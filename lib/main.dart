import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Application name
      title: 'Flutter Hello World',
      // Application theme data, you can set the colors for the application as
      // you want
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // A widget which will be started on application startup
      home: MyHomePage(title: 'TrainApp'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  const MyHomePage({@required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // The title text which will be shown on the action bar
        title: Text(title),
        centerTitle: true,
        backgroundColor: Colors.black87,
      ),
      body: SafeArea(child: MyCustomForm()),
    );
  }
}

class Home extends StatefulWidget {
  @override
  AnalizePage createState() => AnalizePage();
}

class AnalizePage extends State<Home> {
  int _currentIndex = 0;

  final tabs = [
    Center(
      child: Container(
        child: Text(
          "analiza",
        ),
      ),
    ),
    Center(
      child: Container(
        child: Text("wpisy"),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //body:
      appBar: AppBar(
        // The title text which will be shown on the action bar
        title: Text("whatever"),
        backgroundColor: Colors.black87,
      ),

      body: tabs[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Colors.black87,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.tab_sharp,
              color: Colors.white,
            ),
            label: 'test',
            backgroundColor: Colors.yellow,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.tab_sharp,
              color: Colors.white,
            ),
            label: 'test',
            backgroundColor: Colors.red,
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black87,
        onPressed: () {},
        tooltip: 'Zaloguj',
        child: Icon(Icons.add, size: 50),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormStatement createState() {
    return MyCustomFormStatement();
  }
}

class MyCustomFormStatement extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  bool processing = false;
  bool signin = true;

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
                controller: emailController,
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
                controller: passwordController,
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
        onPressed: () => userSignIn(),
        tooltip: 'Zaloguj',
        child: Icon(Icons.arrow_right_rounded, size: 50),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void changeState() {
    if (signin) {
      setState(() {
        signin = false;
      });
    } else
      setState(() {
        signin = true;
      });
  }

  void userSignIn() async {
    setState(() {
      processing = true;
    });
    var url = "http://127.0.0.1/train_app_login/train_app_login.php";
    var data = {
      "email": emailController.text,
      "pass": passwordController.text,
    };

    var res = await http.post(url, body: data);
    if (jsonDecode(res.body) == "xxx") {
      print("nie ma takiego konta");
    }
    if (jsonDecode(res.body) == "false") {
      print("wprowadziłeś złe hasło");
    } else {
      if (_formKey.currentState.validate()) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Home(),
          ),
        );
      }
    }
    setState(() {
      processing = false;
    });
  }
}
