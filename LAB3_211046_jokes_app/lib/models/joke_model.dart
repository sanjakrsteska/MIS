class Joke {
  int id;
  String type;
  String setup;
  String punchline;

  Joke({required this.id, required this.type, required this.setup,required this.punchline});

  factory Joke.fromJson(Map<String, dynamic> json) {
    return Joke(
      id: json['id'] ?? 0,
      type: json['type'] ?? '',
      setup: json['setup'] ?? '',
      punchline: json['punchline'] ?? '',
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'setup': setup,
      'punchline': punchline,
    };
  }
}