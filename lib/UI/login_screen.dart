import 'package:flutter/material.dart';
import 'package:mobilefinal2/METHOD/app_tools.dart';
import 'package:mobilefinal2/METHOD/model.dart';
import 'package:mobilefinal2/METHOD/sqllite.dart';
import 'package:toast/toast.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String user = '';
  String pass = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.fromLTRB(30.0, 50.0, 30.0, 0.0),
          children: <Widget>[
            Image.asset(
              'images/key.png',
              height: 200,
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                  ),
                ),
              ),
              child: TextFormField(
                decoration: InputDecoration(
                  icon: Icon(Icons.person),
                  hintText: 'User Id',
                  border: InputBorder.none,
                ),
                onSaved: (value) => user = value,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                  ),
                ),
              ),
              child: TextFormField(
                decoration: InputDecoration(
                  icon: Icon(Icons.lock),
                  hintText: 'Password',
                  border: InputBorder.none,
                ),
                obscureText: true,
                onSaved: (value) => pass = value,
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 20),
                child: RaisedButton(
                  onPressed: () async {
                    _formKey.currentState.save();
                    if (user == "" || pass == "") {
                      Toast.show("Please fill out this form", context,
                          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                    } else {
                      List lst_acc = await AccountProvider.db.getAllAccount();
                      Account acc;
                      bool checked = false;
                      for (Account item in lst_acc) {
                        if (user == item.userId && pass == item.password) {
                          writeDataLocally(key: "userid", value: user);
                          writeDataLocally(key: "name", value: item.name);
                          acc = item;
                          checked = true;
                          break;
                        }
                      }
                      if (await getDataLocally('userid') != '' && checked) {
                        CurrentAccount.id = acc.id;
                        CurrentAccount.name = acc.name;
                        CurrentAccount.age = acc.age;
                        CurrentAccount.userId = acc.userId;
                        CurrentAccount.password = acc.password;
                        Navigator.pushReplacementNamed(context, '/home');
                      } else {
                        Toast.show("Invalid user or password", context,
                            duration: Toast.LENGTH_SHORT,
                            gravity: Toast.BOTTOM);
                      }
                    }
                  },
                  child: Text('LOGIN'),
                )),
            Container(
              alignment: Alignment.centerRight,
              child: FlatButton(
                padding: EdgeInsets.all(0),
                child: Text('Register New Account',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    )),
                onPressed: () {
                  Navigator.pushNamed(context, "/register");
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
