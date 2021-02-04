import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Application name
      title: 'TrainApp',
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

//strona główna (logowanie)
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
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(child: LoginForm()),
    );
  }
}
//

//lista treningów (wpisy)
class Trainings {
  final String id;
  final String name, time;

  Trainings({
    this.id,
    this.name,
    //this.imageUrl,
    this.time,
  });

  factory Trainings.fromJson(Map<String, dynamic> jsonData) {
    return Trainings(
      id: jsonData['id'],
      name: jsonData['name'],
      time: jsonData['time'],
      //imageUrl: "http://192.168.12.2/PHP/spacecrafts/images/"+jsonData['image_url'],
    );
  }
}

class CustomListView extends StatelessWidget {
  final List<Trainings> trainings;

  CustomListView(this.trainings);

  Widget build(context) {
    return ListView.builder(
      itemCount: trainings.length,
      itemBuilder: (context, int currentIndex) {
        return createViewItem(trainings[currentIndex], context);
      },
    );
  }

  Widget createViewItem(Trainings trainings, BuildContext context) {
    return new ListTile(
        title: new Card(
          elevation: 5.0,
          child: new Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.orange)),
            padding: EdgeInsets.all(20.0),
            margin: EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Padding(
                  //child: Image.network(spacecraft.imageUrl),
                  padding: EdgeInsets.only(bottom: 8.0),
                ),
                Row(children: <Widget>[
                  Padding(
                      child: Text(
                        trainings.name,
                        style: new TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.right,
                      ),
                      padding: EdgeInsets.all(1.0)),
                  Text(" | "),
                  Padding(
                      child: Text(
                        trainings.time,
                        style: new TextStyle(fontStyle: FontStyle.italic),
                        textAlign: TextAlign.right,
                      ),
                      padding: EdgeInsets.all(1.0)),
                ]),
              ],
            ),
          ),
        ),
        onTap: () {
          var route = new MaterialPageRoute(
            builder: (BuildContext context) =>
                new SecondScreen(value: trainings),
          );
          Navigator.of(context).push(route);
        });
  }
}

Future<List<Trainings>> downloadJSON() async {
  final jsonEndpoint = "http://127.0.0.1/train_app_login/list.php";

  final response = await http.post(jsonEndpoint, body: {
    "user_id": LoginFormStatement.userId.toString(),
  });

  if (response.statusCode == 200) {
    List trainings = json.decode(response.body);
    return trainings
        .map((trainings) => new Trainings.fromJson(trainings))
        .toList();
  } else
    throw Exception('Nie można pobrać danych json.');
}
//

// Szczegóły Ćwiczeń
class SecondScreen extends StatefulWidget {
  final Trainings value;

  SecondScreen({Key key, this.value}) : super(key: key);

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Szczegóły'),
        centerTitle: true,
        backgroundColor: Colors.black87,
      ),
      body: new Container(
        child: new Center(
          child: Column(
            children: <Widget>[
              Padding(
                child: new Text(
                  'SZCZEGÓŁY ĆWICZENIA',
                  style: new TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20.0),
                  textAlign: TextAlign.center,
                ),
                padding: EdgeInsets.only(bottom: 20.0),
              ),
              Padding(
                //child: Image.network('${widget.value.imageUrl}'),
                padding: EdgeInsets.all(12.0),
              ),
              Padding(
                child: new Text(
                  'Nazwa Ćwiczenia : ${widget.value.name}',
                  style: new TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                padding: EdgeInsets.all(20.0),
              ),
              Padding(
                child: new Text(
                  'Czas wykonywania : ${widget.value.time}',
                  style: new TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                padding: EdgeInsets.all(20.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}
//

class Home extends StatefulWidget {
  // ignore: non_constant_identifier_names
  @override
  AnalizePage createState() => AnalizePage();
}

//Strona analiz/wpisów
class AnalizePage extends State<Home> {
  int _currentIndex = 0;
  //*do testowego grafu
  static var data = [0.0, 1.0, 1.5, 2.0, 0.0, 0.0, -0.5];

  final tabs = [
    //Grafy/analiza
    Center(
      child: Container(
        child: new Container(
          child: new Sparkline(
            data: data,
            pointsMode: PointsMode.all,
            pointSize: 8.0,
            pointColor: Colors.amber,
          ),
        ),
      ),
    ),
    //Lista treningów
    Center(
      child: new FutureBuilder<List<Trainings>>(
        future: downloadJSON(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Trainings> trainings = snapshot.data;
            return new CustomListView(trainings);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return new CircularProgressIndicator();
        },
      ),
    ),
  ];

//Po zalogowaniu
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //body:
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Witaj w TrainApp!"),
          centerTitle: true,
          backgroundColor: Colors.black87,
          leading: FloatingActionButton(
              heroTag: "LogoutButton",
              tooltip: 'Wyloguj',
              backgroundColor: Colors.black87,
              onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyHomePage(title: 'TrainApp'),
                      ),
                    ),
                  },
              child: Icon(
                Icons.backspace,
              ))),

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
            label: 'Analiza',
            backgroundColor: Colors.yellow,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.tab_sharp,
              color: Colors.white,
            ),
            label: 'Wpisy',
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
        heroTag: "AddTrainingButton",
        backgroundColor: Colors.black87,
        onPressed: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateNewTraining(),
            ),
          ),
        },
        tooltip: 'Nowy Wpis',
        child: Icon(Icons.add, size: 50),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
//

//Dodawanie nowego treningu
class CreateNewTraining extends StatefulWidget {
  @override
  CreateNewTrainingStatement createState() {
    return CreateNewTrainingStatement();
  }
}

class CreateNewTrainingStatement extends State<CreateNewTraining> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController name = new TextEditingController();
  TextEditingController attemps = new TextEditingController();
  TextEditingController time = new TextEditingController();
  TextEditingController amount = new TextEditingController();
  FToast fToast;

  //initialize FlutterToast
  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  //login
  Future add() async {
    var url = "http://127.0.0.1/train_app_login/train_app_newTraining.php";
    var response = await http.post(url, body: {
      "id": LoginFormStatement.userId.toString(),
      "name": name.text,
      "time": time.text,
      "attemps": attemps.text,
      "amount": amount.text,
    });

    print(name.text);
    print(time.text);
    print(attemps.text);
    print(amount.text);
    print(LoginFormStatement.userId.toString());
    var data;
    if (response.body.isNotEmpty) {
      data = json.decode(response.body);
    }
    if (data == "error") {
      fToast.showToast(
          child: Text('Wystąpił Błąd',
              style: TextStyle(fontSize: 25, color: Colors.red)));
    } else {
      fToast.showToast(
          child: Text(
        'Dodano Nowy Wpis',
        style: TextStyle(fontSize: 25, color: Colors.green),
      ));
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Home(),
        ),
      );
    }
  }

  //login form
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dodaj Ćwiczenie"),
        backgroundColor: Colors.black87,
      ),
      body: Container(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              //Nazwa
              TextFormField(
                controller: name,
                textAlign: TextAlign.center,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Nazwa ćwiczenia nie została wprowadzona!';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Nazwa Ćwiczenia',
                ),
              ),
              //Serie
              TextFormField(
                controller: attemps,
                textAlign: TextAlign.center,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Ilość serii nie została wprowadzona!';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Serie',
                ),
              ),
              //Czas ćwiczenia
              TextFormField(
                controller: time,
                textAlign: TextAlign.center,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Długośc ćwiczenia nie została wprowadzona!';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Długość Ćwiczenia',
                ),
              ),
              //Ilość wykonanych ćwiczeń
              TextFormField(
                controller: amount,
                textAlign: TextAlign.center,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Ilość wykonywanych ćwiczeń nie została wprowadzona!';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Ilość wykonanych ćwiczeń',
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
        onPressed: () => add(),
        tooltip: 'Dodaj',
        child: Icon(Icons.add, size: 50),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
//

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
//
