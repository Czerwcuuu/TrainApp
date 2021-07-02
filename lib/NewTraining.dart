import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/screens/LoginForm.dart';
import '/main.dart';

//Dodawanie nowego treningu
class CreateNewTraining extends StatefulWidget {
  @override
  CreateNewTrainingStatement createState() {
    return CreateNewTrainingStatement();
  }
}

//Lista treningów do wyboru
class TrainingToSelect {
  int id;
  String name;

  TrainingToSelect(this.id, this.name);

  static List<TrainingToSelect> getTrainings() {
    return <TrainingToSelect>[
      TrainingToSelect(1, 'Bieganie'),
      TrainingToSelect(2, 'Ciężarki'),
      TrainingToSelect(3, 'Bieżnia'),
      TrainingToSelect(4, 'Pływanie'),
      TrainingToSelect(5, 'Skłony'),
      TrainingToSelect(6, 'Przysiady'),
    ];
  }
}

//Tworzenie nowego treningu
class CreateNewTrainingStatement extends State<CreateNewTraining> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController name = new TextEditingController();
  TextEditingController attemps = new TextEditingController();
  TextEditingController time = new TextEditingController();
  TextEditingController amount = new TextEditingController();
  FToast fToast;

  List<TrainingToSelect> _trainings = TrainingToSelect.getTrainings();
  List<DropdownMenuItem<TrainingToSelect>> _dropdownMenuItems;
  TrainingToSelect _selectedTraining;

  //initialize FlutterToast
  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_trainings);
    _selectedTraining = _dropdownMenuItems[0].value;
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  onChangeDropdownItem(TrainingToSelect selectedTraining) {
    setState(() {
      _selectedTraining = selectedTraining;
    });
  }

  List<DropdownMenuItem<TrainingToSelect>> buildDropdownMenuItems(
      List trainings) {
    List<DropdownMenuItem<TrainingToSelect>> items = List();
    for (TrainingToSelect training in trainings) {
      items.add(
        DropdownMenuItem(
          value: training,
          child: Text(training.name),
        ),
      );
    }
    return items;
  }

  //login
  Future add() async {
    RegExp regExp =
        new RegExp(r"^[0-9]", caseSensitive: false, multiLine: false);

    if (time.text.isEmpty &&
        attemps.text.isEmpty &&
        attemps.text.isEmpty &&
        amount.text.isEmpty) {
      fToast.showToast(
          child: Text('Wszystkie pola musza być uzupełnione',
              style: TextStyle(fontSize: 25, color: Colors.red)));
      return;
    }
    /*(else if (regExp.hasMatch(time.text)) {
      fToast.showToast(
          child: Text('Czas musi być liczbą!',
              style: TextStyle(fontSize: 25, color: Colors.red)));
      return;
    }*/

    var url = "http://127.0.0.1/train_app_login/train_app_newTraining.php";
    var response = await http.post(url, body: {
      "id": LoginFormStatement.userId.toString(),
      "name": _selectedTraining.name.toString(),
      "time": time.text,
      "attemps": attemps.text,
      "amount": amount.text,
    });

    print(_selectedTraining.name.toString());
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //Nazwa
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Wybierz Ćwiczenie"),
                  SizedBox(
                    height: 20.0,
                  ),
                  DropdownButton(
                    value: _selectedTraining,
                    items: _dropdownMenuItems,
                    onChanged: onChangeDropdownItem,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'Wybrane: ${_selectedTraining.name}',
                  ),
                ],
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
