import 'package:flutter/material.dart';
import 'package:myapp/data/training.dart' as tr;
import 'package:myapp/data/properties.dart' as pr;
import 'package:myapp/screens/LoginForm.dart';
import 'package:myapp/screens/SecondScreen.dart';
import 'package:myapp/screens/AnalizePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // root
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Nazwa apki
      title: 'TrainApp',

      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Startup aplikacji
      home: MyHomePage(title: 'TrainApp'),
    );
  }
}

class Home extends StatefulWidget {
  // strona główna - AnalizePage
  @override
  AnalizePage createState() => AnalizePage();
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

//Lista Ćwiczeń
class CustomListView extends StatelessWidget {
  final List<tr.Trainings> trainings;

  CustomListView(this.trainings);

  Widget build(context) {
    return ListView.builder(
      itemCount: trainings.length,
      itemBuilder: (context, int currentIndex) {
        return createViewItem(trainings[currentIndex], context);
      },
    );
  }

  Widget createViewItem(tr.Trainings trainings, BuildContext context) {
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
                        trainings.time + " minut",
                        style: new TextStyle(fontStyle: FontStyle.italic),
                        textAlign: TextAlign.right,
                      ),
                      padding: EdgeInsets.all(1.0)),
                  Text(" | "),
                  Padding(
                      child: Text(
                        trainings.date.toString(),
                        style: new TextStyle(fontStyle: FontStyle.italic),
                        textAlign: TextAlign.right,
                      ),
                      padding: EdgeInsets.all(1.0))
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

//Lista własciwości
class CustomPropView extends StatelessWidget {
  final List<pr.Properties> properties;

  CustomPropView(this.properties);

  Widget build(context) {
    return ListView.builder(
      itemCount: properties.length,
      itemBuilder: (context, int currentIndex) {
        return createViewItem(properties[currentIndex], context);
      },
    );
  }

  Widget createViewItem(pr.Properties properties, BuildContext context) {
    return new ListTile(
      title: new Card(
        elevation: 5.0,
        child: new Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          padding: EdgeInsets.all(20.0),
          margin: EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Padding(
                //child: Image.network(spacecraft.imageUrl),
                padding: EdgeInsets.only(bottom: 8.0),
              ),
              Row(children: <Widget>[
                Text('Wykonanych treningów:'),
                Padding(
                    child: Text(
                      properties.row.toString(),
                      style: new TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                    padding: EdgeInsets.all(1.0)),
              ]),
              Padding(
                //child: Image.network(spacecraft.imageUrl),
                padding: EdgeInsets.only(bottom: 8.0),
              ),
              Row(children: <Widget>[
                Text('Najczęściej wykonujesz:'),
                Padding(
                    child: Text(
                      properties.cwiczenie,
                      style: new TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                    padding: EdgeInsets.all(1.0)),
              ]),
              Padding(
                //child: Image.network(spacecraft.imageUrl),
                padding: EdgeInsets.only(bottom: 8.0),
              ),
              Row(children: <Widget>[
                Text('Wykonałeś to ćwiczenie już:'),
                Padding(
                    child: Text(
                      properties.ilecwiczenie.toString() + " razy",
                      style: new TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                    padding: EdgeInsets.all(1.0)),
              ]),
              Padding(
                //child: Image.network(spacecraft.imageUrl),
                padding: EdgeInsets.only(bottom: 8.0),
              ),
              Row(children: <Widget>[
                Text('Ostatnio ćwiczyłeś dnia:'),
                Padding(
                    child: Text(
                      properties.ostatniadata,
                      style: new TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                    padding: EdgeInsets.all(1.0)),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
