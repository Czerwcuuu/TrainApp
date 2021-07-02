import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:myapp/data/training.dart' as tr;
import 'package:myapp/data/properties.dart' as pr;
import 'LoginForm.dart';

Future<List<tr.Trainings>> downloadJSON() async {
  final jsonEndpoint = "http://127.0.0.1/train_app_login/list.php";

  final response = await http.post(jsonEndpoint, body: {
    "user_id": LoginFormStatement.userId.toString(),
  });

  if (response.statusCode == 200) {
    List trainings = json.decode(response.body);
    return trainings
        .map((trainings) => new tr.Trainings.fromJson(trainings))
        .toList();
  } else
    throw Exception('Nie można pobrać danych json.');
}
//

Future<List<pr.Properties>> downloadProperties() async {
  final jsonEndpoint =
      "http://127.0.0.1/train_app_login/train_app_properties.php";

  final response = await http.post(jsonEndpoint, body: {
    "user_id": LoginFormStatement.userId.toString(),
  });

  if (response.statusCode == 200) {
    List properties = json.decode(response.body);
    return properties
        .map((properties) => new pr.Properties.fromJson(properties))
        .toList();
  } else
    throw Exception('Nie można pobrać danych json.');
}
