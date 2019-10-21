import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:recepi_app/data/appstate.dart';
import 'package:recepi_app/data/get-it.dart';
import 'package:recepi_app/ui/clippers/login-page-painters.dart';
import 'package:recepi_app/ui/screens/register-screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _appstate = getIt.get<AppState>();
  TextEditingController _email;
  TextEditingController _password;
  bool _remember = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _storage = new FlutterSecureStorage();
  Future _readCredentials() async {
    String password = await _storage.read(key: "recepi_passphrase");
    String email = await _storage.read(key: "recepi_mail");
    String remember = await _storage.read(key: "recepi_remember");
    if (remember != null) {
      if (remember == "y") {
        setState(() {
          _remember = true;
          _password = TextEditingController(text: password);
          _email = TextEditingController(text: email);
        });
      }
    }
  }

  @override
  void initState() {
    _email = new TextEditingController();
    _password = new TextEditingController();
    _readCredentials();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  ClipPath(
                    clipper: ThirdClipper(),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 2,
                      color: Colors.amberAccent,
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 2,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.white,
                            child: Icon(
                              MdiIcons.bowl,
                              size: 50,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "The Recepi",
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * 0.5,
                padding: EdgeInsets.symmetric(horizontal: 30),
                // color: Colors.red,
                child: ListView(
                  physics: NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _email,
                      decoration: InputDecoration(
                          border: new OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  new BorderSide(color: Colors.redAccent)),
                          labelText: 'E-mail',
                          filled: false,
                          fillColor: Colors.white70),
                      validator: (String value) {
                        if (value.isEmpty) return "invalid email";
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    StreamBuilder(
                      stream: _appstate.loginError,
                      builder: (context, AsyncSnapshot<String> error) {
                        return TextFormField(
                          obscureText: true,
                          controller: _password,
                          decoration: InputDecoration(
                              border: new OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      new BorderSide(color: Colors.redAccent)),
                              labelText: 'Password',
                              errorText: error.data,
                              filled: false,
                              fillColor: Colors.white70),
                          validator: (String value) {
                            if (value.isEmpty) return "invalid password";
                            return null;
                          },
                          onSaved: (String value) {},
                        );
                      },
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 3, horizontal: 30),
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: <Widget>[
                          Checkbox(
                            activeColor: Colors.amberAccent,
                            checkColor: Colors.black,
                            value: _remember,
                            onChanged: (newval) {
                              print(newval);
                              setState(() {
                                _remember = newval;
                              });
                            },
                          ),
                          Text("Remember me")
                        ],
                      ),
                    ),
                    CupertinoButton(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.amberAccent,
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _appstate.login(
                              email: _email.text,
                              password: _password.text,
                              remember: _remember);
                        }
                      },
                      child: StreamBuilder(
                        initialData: false,
                        stream: _appstate.loggingIn,
                        builder: (context, AsyncSnapshot<bool> loading) {
                          return loading.data
                              ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.black),
                                )
                              : Text(
                                  "login",
                                  style: TextStyle(color: Colors.black),
                                );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Or Sign up",
                      textAlign: TextAlign.center,
                    ),
                    FloatingActionButton(
                        backgroundColor: Colors.amberAccent,
                        child: Icon(
                          MdiIcons.accountPlus,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(new MaterialPageRoute(
                              builder: (context) => CreateAccountScreen()));
                        })
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
