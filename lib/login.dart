import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:walmart_docs/commonUtils.dart';
import 'package:walmart_docs/docsModel.dart';
import 'package:walmart_docs/validationManager.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  final scaffoldkey = new GlobalKey<ScaffoldState>();
  final formkey = new GlobalKey<FormState>();
  List<String> _values = new List<String>();
  String _value;
  String _email;
  String _password;
  bool _autoValidate = false;
  //CommonUtils client = new CommonUtils("192.168.1.16:5000/repo");

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _value = "voila";
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.white,
        key: scaffoldkey,
        appBar: new AppBar(
          title: new Text("Login"),
          backgroundColor: Colors.blue[400],
        ),
        body: new Container(
            child: new FutureBuilder<List<Data>>(
                future: fetchDocs(http.Client()),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error.toString());
                    return new Text("error:  "+snapshot.error.toString());
                  }
                  if (snapshot.hasData) {
                    docsList(snapshot.data);
                    return new Container(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: formkey,
                        autovalidate: _autoValidate,
                        child: LoginFormUI(),
                      ),
                    );
                  }
                  if (snapshot.connectionState != ConnectionState.done) {
                    return new Center(
                      child: CircularProgressIndicator(),
                    );
                    
                  }
                  return new Text("work aavala $snapshot.data");
                })));
  }

  Future<List<Data>> fetchDocs(http.Client client) async {
    final response = await client.get('http://192.168.1.16:5000/repo');

    // Use the compute function to run parsePhotos in a separate isolate
    print("ommmmleleleeeeeeeeeeeeeeeeeee "+ response.body);
    final parsed = json.decode(response.body);

    // return parsed.map<Data>((json) => new DocsModel().fromJson(json)).toList();
    return  new DocsModel().fromJson(parsed).toList();

    //return parseDocs, response.body);
  }

  static List<Data> parseDocs(String responseBody) {
    print("ommmmleleleeeeeeeeeeeeeeeeeee $responseBody");
    final parsed = json.decode(responseBody);

    return parsed.map<Data>((json) => new DocsModel().fromJson(json)).toList();

  }

  Widget LoginFormUI() {
    return new ListView(
      shrinkWrap: true,
      children: <Widget>[
        SizedBox(
          height: 100.0,
        ),
        new CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 100.0,
            child: Image.asset('assets/walmart.jpg')),
        SizedBox(
          height: 150.0,
        ),
        new TextFormField(
          decoration: new InputDecoration(
              labelText: "UserName",
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
              hintText: "username"),
          keyboardType: TextInputType.emailAddress,
          autofocus: true,
          validator: ValidationManager.validateEmail,
          onSaved: (String val) => _email = val,
          style:
              TextStyle(color: Colors.black.withOpacity(0.8), fontSize: 20.0),
        ),
        SizedBox(
          height: 8.0,
        ),
        new TextFormField(
          obscureText: true,
          decoration: new InputDecoration(
              labelText: "Password",
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
              hintText: "password123"),
          validator: ValidationManager.validatePassword,
          onSaved: (val) => _password = val,
          style:
              TextStyle(color: Colors.black.withOpacity(0.8), fontSize: 20.0),
        ),
        SizedBox(
          height: 8.0,
        ),
        new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Text(
                "Repository",
                style: TextStyle(
                    color: Colors.black.withOpacity(0.8), fontSize: 20.0),
              ),
              new DropdownButton(
                hint: new Text("choose :"),
                value: _value,
                items: _values.map((String value) {
                  return new DropdownMenuItem(
                    value: value,
                    child: new Text(value),
                    // child: new Row(
                    //   children: <Widget>[new Text('$value')],
                    // ),
                  );
                }).toList(),
                onChanged: (value) {
                  // print(value);
                  // _onChanged(value);
                  print(_values.indexOf(value));
                  print(_values.where((String _v ) => _v == value)); 
                  // setState(() {
                  //   _value = value;               
                  //                   });
                  
                },
              ),
            ]),
        SizedBox(
          height: 8.0,
        ),
        new Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0),
          child: Material(
            shadowColor: Colors.lightBlueAccent.shade100,
            elevation: 5.0,
            child: MaterialButton(
                minWidth: 200.0,
                height: 42.0,
                onPressed: _submit,
                color: Colors.lightBlue[700],
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white),
                )),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        FlatButton(
          child: Text(
            'Forgot Password?',
            style: TextStyle(color: Colors.black54),
          ),
          onPressed: () {
            //Navigator.of(context).pushNamed(SighUp.tag);
          },
        )
      ],
    );
  }

  void _submit() {
    final form = formkey.currentState;
    if (form.validate()) {
      form.save();
      loginCheck();
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  void _onChanged(String value) {
    print(value);
    setState(() {
      _value = value;  
    });
   
  }

  void status(dynamic response) {
    print(response);
    SnackBar snackBar;
    if (!response) {
      snackBar = new SnackBar(
          content: new Text(
            "Username/Password wrong Try Again",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          duration: Duration(seconds: 3));
    } else {
      snackBar = new SnackBar(
          content: new Text(
            "Logged in Successfully",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          duration: Duration(seconds: 3));

      //Navigator.of(context).pushNamed(ListDocument.tag);
    }
    scaffoldkey.currentState.showSnackBar(snackBar);
  }

  loginCheck() {
    if (_email == "pradeep@walmart.com" && _password == "qwe123") {
      status(true);
    } else
      status(false);
  }

  docsList(List<Data> data) {
    print(data);
    for (Data x in data) {

      _values.add(x.title);
      
    }
    _value = _values.elementAt(0);
    }
}

// class DocsList extends StatelessWidget {
//   final List<DocsModel> docs;

//   DocsList({Key key, this.docs}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return new Column(
//       children: <Widget>[
//         new GridView.builder(
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 1,
//           ),
//           itemCount: docs.length,
//           itemBuilder: (context, index) {
//             return Image.network(docs[index].title);
//           },
//         )
//       ],
//     );
//   }
// }
