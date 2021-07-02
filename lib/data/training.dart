class Trainings {
  final String id;
  final String name, time, attemps, amount, date;

  Trainings({
    this.id,
    this.name,
    //this.imageUrl,
    this.time,
    this.attemps,
    this.amount,
    this.date,
  });

  factory Trainings.fromJson(Map<String, dynamic> jsonData) {
    return Trainings(
      id: jsonData['id'],
      name: jsonData['name'],
      time: jsonData['time'],
      attemps: jsonData['attemps'],
      amount: jsonData['amount'],
      date: jsonData['date'],
      //imageUrl: "http://192.168.12.2/PHP/spacecrafts/images/"+jsonData['image_url'],
    );
  }
}
