import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:mobilefinal2/METHOD/model.dart';

Future<List<Todo>> fetchTodos(int userid) async {
  final response = await http
      .get('https://jsonplaceholder.typicode.com/todos?userid=$userid');

  List<Todo> todoRes = [];

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    var body = json.decode(response.body);
    for (int i = 0; i < body.length; i++) {
      var todo = Todo.fromJson(body[i]);
      if (todo.userid == userid) {
        todoRes.add(todo);
      }
    }
    return todoRes;
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

class TodoScreen extends StatelessWidget {
  // Declare a field that holds the Todo
  final int id;
  final String name;
  // In the constructor, require a Todo
  TodoScreen({Key key, @required this.id, @required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create our UI
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo"),
        automaticallyImplyLeading: false,
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
                  child: Text(
                    "BACK",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              FutureBuilder(
                future: fetchTodos(this.id),
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
                        return new Text('Error: ${snapshot.error}');
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
    List<Todo> todos = snapshot.data;
    return new Expanded(
      child: new ListView.builder(
        itemCount: todos.length,
        itemBuilder: (BuildContext context, int index) {
          return new Card(
            margin: EdgeInsets.symmetric(vertical: 5.0),
            child: InkWell(
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(
                        (todos[index].id).toString(),
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                      padding: EdgeInsets.only(bottom: 10.0),
                    ),
                    Container(
                      child: Text(
                        todos[index].title,
                        style: TextStyle(fontSize: 16),
                      ),
                      padding: EdgeInsets.only(bottom: 5.0),
                    ),
                    Text(
                      todos[index].completed,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
