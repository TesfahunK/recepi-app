import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:recepi_app/data/appstate.dart';
import 'package:recepi_app/data/get-it.dart';
import 'package:recepi_app/ui/widgets/divider.dart';

final _appstate = getIt.get<AppState>();

/// **A Sign up Screen**

class CreateAccountScreen extends StatefulWidget {
  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  TextEditingController _password;
  TextEditingController _confPassword;
  TextEditingController _email;
  bool _creating = false;
  GlobalKey<FormState> _accountFormKey = new GlobalKey<FormState>();

  @override
  void initState() {
    _confPassword = new TextEditingController();
    _password = new TextEditingController();
    _email = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: Form(
          key: _accountFormKey,
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.amberAccent,
                child: Icon(
                  MdiIcons.account,
                  color: Colors.white,
                  size: 50,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  "Create your account here",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              StreamBuilder(
                stream: _appstate.signupError,
                builder: (context, AsyncSnapshot<String> error) {
                  return TextFormField(
                    controller: _email,
                    decoration: InputDecoration(
                        border: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                new BorderSide(color: Colors.redAccent)),
                        labelText: 'E-mail',
                        errorText: error.data,
                        filled: false,
                        fillColor: Colors.white70),
                    validator: (String value) {
                      if (value.isEmpty) return "email is required";
                      return null;
                    },
                  );
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                obscureText: true,
                controller: _password,
                decoration: InputDecoration(
                    border: new OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: new BorderSide(color: Colors.redAccent)),
                    labelText: 'Password',
                    filled: false,
                    fillColor: Colors.white70),
                validator: (String value) {
                  if (value.isEmpty) return "password is required";
                  if (value.length < 8) return "password is too short";

                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                obscureText: true,
                controller: _confPassword,
                decoration: InputDecoration(
                    border: new OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: new BorderSide(color: Colors.redAccent)),
                    labelText: 'Confirm Password',
                    filled: false,
                    fillColor: Colors.white70),
                validator: (String value) {
                  if (value.isEmpty) return "confirm your password";
                  if (value != _password.text) return "Passwords do not match";

                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              CupertinoButton(
                color: Colors.amberAccent,
                onPressed: () {
                  if (_accountFormKey.currentState.validate()) {
                    setState(() {
                      _creating = true;
                    });
                    _appstate
                        .createUser(_email.text, _password.text, context)
                        .then((onValue) {
                      setState(() {
                        _creating = false;
                      });
                    });
                  }
                },
                child: _creating
                    ? CircularProgressIndicator()
                    : Text(
                        "Create Account",
                        style: TextStyle(color: Colors.black),
                      ),
                borderRadius: BorderRadius.circular(20),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileForm extends StatefulWidget {
  final bool editMode;
  ProfileForm({this.editMode = false});
  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  TextEditingController _name;
  final _appstate = getIt.get<AppState>();
  TextEditingController _bio;
  String _birthdate;
  GlobalKey<FormState> _profileFormKey = new GlobalKey<FormState>();
  bool _creating = false;
  File _image;
  String intialDate;

  @override
  void initState() {
    if (widget.editMode) {
      _name = new TextEditingController(text: _appstate.profileValue.name);
      _bio = new TextEditingController(text: _appstate.profileValue.bio);
      intialDate = _appstate.profileValue.birthDate;
      _birthdate = _appstate.profileValue.birthDate;
    } else {
      _name = new TextEditingController();
      _bio = new TextEditingController();
    }
    super.initState();
  }

  Future selectImage(ImageSource source, BuildContext context) async {
    var image = await ImagePicker.pickImage(source: source);
    setState(() {
      _image = image;
    });
    if (image != null) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _profileFormKey,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "${widget.editMode == true ? "Edit" : "Create"} Your Profile",
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
              !widget.editMode
                  ? Stack(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey,
                          backgroundImage:
                              _image != null ? FileImage(_image) : null,
                          child: IconButton(
                            color: Colors.white,
                            iconSize: 30,
                            onPressed: () {
                              showModalBottomSheet(
                                  builder: (BuildContext context) {
                                    return Column(
                                      textDirection: TextDirection.ltr,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(top: 30),
                                          padding: EdgeInsets.only(bottom: 10),
                                          child: Text(
                                            "Select Image",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                        DividerCustom(
                                          coloR: Colors.black.withOpacity(0.3),
                                          heighT: 0.5,
                                        ),
                                        ListTile(
                                          leading: Icon(MdiIcons.camera),
                                          title: Text("Camera"),
                                          onTap: () {
                                            selectImage(
                                                ImageSource.camera, context);
                                          },
                                        ),
                                        ListTile(
                                          leading: Icon(MdiIcons.googlePhotos),
                                          title: Text("Gallery"),
                                          onTap: () {
                                            selectImage(
                                                ImageSource.gallery, context);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                  context: context);
                            },
                            icon: Icon(MdiIcons.camera),
                          ),
                        ),
                      ],
                    )
                  : SizedBox.shrink(),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: _name,
                decoration: InputDecoration(
                    border: new OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: new BorderSide(color: Colors.redAccent)),
                    labelText: 'Name',
                    filled: false,
                    fillColor: Colors.white70),
                validator: (String value) {
                  if (value.isEmpty) return "name is required name";
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                maxLines: 4,
                controller: _bio,
                decoration: InputDecoration(
                    border: new OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: new BorderSide(color: Colors.redAccent)),
                    labelText: 'Bio',
                    filled: false,
                    fillColor: Colors.white70),
                validator: (String value) {
                  if (value.isEmpty) return "Bio is required";
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Birthdate",
                style: TextStyle(fontSize: 17),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                height: 150,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime:
                      widget.editMode ? DateTime.parse(intialDate) : null,
                  minimumYear: 1920,
                  onDateTimeChanged: (DateTime value) {
                    setState(() {
                      _birthdate =
                          "${value.year}-${value.month > 9 ? value.month : "0" + value.month.toString()}-${value.day > 9 ? value.day : "0" + value.day.toString()}";
                    });
                  },
                ),
              ),
              CupertinoButton(
                color: Colors.amberAccent,
                borderRadius: BorderRadius.circular(20),
                onPressed: () async {
                  if (_profileFormKey.currentState.validate()) {
                    setState(() {
                      _creating = true;
                    });
                    if (widget.editMode) {
                      _appstate.updateProfile(data: {
                        "bio": _bio.text,
                        "name": _name.text,
                        "birthdate": _birthdate
                      }).then((onValue) {
                        setState(() {
                          _creating = false;
                        });
                      });
                    } else {
                      _appstate.createProfile(data: {
                        "bio": _bio.text,
                        "name": _name.text,
                        "birthdate": _birthdate
                      }).then((onValue) {
                        setState(() {
                          _creating = false;
                        });
                      });
                    }
                  }
                },
                child: _creating
                    ? CircularProgressIndicator()
                    : Text(
                        "${widget.editMode ? "update" : "create"}",
                        style: TextStyle(color: Colors.black),
                      ),
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
