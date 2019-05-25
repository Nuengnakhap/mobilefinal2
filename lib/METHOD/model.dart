class CurrentAccount {
  static int id;
  static var userId;
  static var name;
  static var age;
  static var password;
  static var quote;
  static void clearAccount() {
    id = 0;
    userId = '';
    name = '';
    age = 0;
    password = '';
    quote = '';
  }
}


class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String website;

  User({this.id, this.name, this.email, this.phone, this.website});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      website: json['website'],
    );
  }
}

class Todo {
  final int userid;
  final int id;
  final String title;
  final String completed;

  Todo({this.userid, this.id, this.title, this.completed});

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      userid: json['userId'],
      id: json['id'],
      title: json['title'],
      completed: (json['completed'] ? "Completed" : ""),
    );
  }
}