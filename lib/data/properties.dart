class Properties {
  final String row;
  final String cwiczenie;
  final String ilecwiczenie;
  final String ostatniadata;

  Properties({
    this.row,
    this.cwiczenie,
    this.ilecwiczenie,
    this.ostatniadata,
    //this.imageUrl,
  });

  factory Properties.fromJson(Map<String, dynamic> jsonData) {
    return Properties(
      row: jsonData['row'],
      cwiczenie: jsonData['cwiczenie'],
      ilecwiczenie: jsonData['ilecwiczenie'],
      ostatniadata: jsonData['ostatniadata'],

      //imageUrl: "http://192.168.12.2/PHP/spacecrafts/images/"+jsonData['image_url'],
    );
  }
}
