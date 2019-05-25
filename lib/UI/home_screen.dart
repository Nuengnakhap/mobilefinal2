import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobilefinal2/METHOD/app_tools.dart';
import 'package:mobilefinal2/METHOD/model.dart';
import 'package:mobilefinal2/UI/profile_screen.dart';

class HomeScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  String _data = '';
  String _name = '';
  // String name = await getDataLocally('name');

  @override
  void initState() {
    super.initState();
    getData();
  }
  
  Future getData() async {
    _name = await getDataLocally('name');
    _data = await readData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Container(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
          children: <Widget>[
            ListTile(
              title: Text('Hello $_name'),
              subtitle: Text('this is my quote "$_data"'),
            ),
            RaisedButton(
              child: Text("PROFILE SETUP"),
              onPressed: () async {
                bool response = await Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
                if (response == true) {
                  getData();
                }
              },
            ),
            RaisedButton(
              child: Text("MY FRIENDS"),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/friend');
              },
            ),
            RaisedButton(
              child: Text("SIGN OUT"),
              onPressed: () {
                removeDataLocally('userid');
                removeDataLocally('name');
                CurrentAccount.clearAccount();
                writeData('');
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
          ],
        ),
      ),
    );
  }
}
