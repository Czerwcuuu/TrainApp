import 'package:flutter/material.dart';
import 'package:myapp/data/training.dart' as tr;
import 'package:myapp/data/properties.dart' as pr;
import 'package:myapp/screens/Jsons.dart';
import 'package:myapp/main.dart';
import 'package:myapp/NewTraining.dart';

//Strona analiz/wpisów
class AnalizePage extends State<Home> {
  int _currentIndex = 0;

  final tabs = [
    //Grafy/analiza
    Center(
      child: Container(
        child: new FutureBuilder<List<pr.Properties>>(
            future: downloadProperties(),
            // ignore: missing_return
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<pr.Properties> properties = snapshot.data;
                return new CustomPropView(properties);
              } else if (snapshot.hasError) {
                return Text('test');
              }
            }),
      ),
    ),
    //Lista treningów
    Center(
      child: new FutureBuilder<List<tr.Trainings>>(
        future: downloadJSON(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<tr.Trainings> trainings = snapshot.data;
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