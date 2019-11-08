import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recepi_app/data/appstate.dart';
import 'package:recepi_app/data/get-it.dart';
import 'package:recepi_app/ui/screens/register-screen.dart';
import 'package:recepi_app/ui/widgets/divider.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _appstate = getIt.get<AppState>();
  TextEditingController _newPassword;
  TextEditingController _oldPassword;
  TextEditingController _confPassword;
  GlobalKey<FormState> _passwordFormKey = new GlobalKey<FormState>();

  @override
  void initState() {
    _newPassword = TextEditingController();
    _oldPassword = TextEditingController();
    _confPassword = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          floating: true,
          title: Text("Edit Profile"),
        ),
        SliverToBoxAdapter(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            child: ProfileForm(
              editMode: true,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: Form(
                key: _passwordFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Update Password"),
                    DividerCustom(
                      coloR: Colors.white,
                      verticalMargin: 5,
                    ),
                    TextFormField(
                      controller: _oldPassword,
                      decoration: InputDecoration(
                          border: new OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  new BorderSide(color: Colors.redAccent)),
                          labelText: 'Old Password',
                          filled: false,
                          fillColor: Colors.white70),
                      validator: (String value) {
                        if (value.isEmpty) return "old passwod is required";
                        return null;
                      },
                    ),
                    DividerCustom(
                      coloR: Colors.white,
                      verticalMargin: 5,
                    ),
                    TextFormField(
                      controller: _newPassword,
                      decoration: InputDecoration(
                          border: new OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  new BorderSide(color: Colors.redAccent)),
                          labelText: 'New Password',
                          filled: false,
                          fillColor: Colors.white70),
                      validator: (String value) {
                        if (value.isEmpty) return "new passwod is required";
                        return null;
                      },
                    ),
                    DividerCustom(
                      coloR: Colors.white,
                      verticalMargin: 5,
                    ),
                    TextFormField(
                      controller: _confPassword,
                      decoration: InputDecoration(
                          border: new OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  new BorderSide(color: Colors.redAccent)),
                          labelText: 'Conf Password',
                          filled: false,
                          fillColor: Colors.white70),
                      validator: (String value) {
                        if (value.isEmpty) return "confirm your password";
                        return null;
                      },
                    ),
                    DividerCustom(
                      coloR: Colors.white,
                      verticalMargin: 5,
                    ),
                    Center(
                      child: CupertinoButton(
                        color: Colors.amberAccent,
                        borderRadius: BorderRadius.circular(20),
                        onPressed: () async {
                          if (_passwordFormKey.currentState.validate()) {
                            _appstate.updatePassword(
                                oldpassword: _oldPassword.text,
                                newpassword: _newPassword.text);
                          }
                        },
                        child: Text(
                          "update password",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
              )),
        )
      ],
    ));
  }
}
