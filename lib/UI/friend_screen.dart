import 'package:flutter/material.dart';
import 'package:mobilefinal2/METHOD/model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:mobilefinal2/UI/todo_screen.dart';

class FriendScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FriendScreenState();
  }
}

Future<List<User>> fetchUsers() async {
  final response = await http.get('https://jsonplaceholder.typicode.com/users');

  List<User> userRes = [];

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    var body = json.decode(response.body);
    for (int i = 0; i < body.length; i++) {
      var user = User.fromJson(body[i]);
      userRes.add(user);
    }
    return userRes;
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

class FriendScreenState extends State<FriendScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Friend"),
        centerTitle: true,
      ),
      body: Container(
        child: Container(
          margin: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                child: RaisedButton(
                  child: Center(
                    child: Text(
                      "BACK",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                ),
              ),
              FutureBuilder(
                future: fetchUsers(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Expanded(
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 20.0,),
                              Text("Loading"),
                            ],
                          ),
                        ),
                      );
                    default:
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return createListView(context, snapshot);
                      }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<User> friends = snapshot.data;
    return Expanded(
      child: ListView.builder(
        itemCount: friends.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            child: Card(
              margin: EdgeInsets.symmetric(vertical: 5.0),
              child: InkWell(
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Text(
                          "${(friends[index].id).toString()} : ${friends[index].name}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                        padding: EdgeInsets.only(bottom: 10.0),
                      ),
                      Text(
                        friends[index].email,
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        friends[index].phone,
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        friends[index].website,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TodoScreen(
                          id: friends[index].id, name: friends[index].name),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
