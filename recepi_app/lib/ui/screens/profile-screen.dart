import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:recepi_app/data/appstate.dart';
import 'package:recepi_app/data/get-it.dart';
import 'package:recepi_app/data/models/profile.dart';
import 'package:recepi_app/ui/screens/register-screen.dart';
import 'package:recepi_app/ui/widgets/divider.dart';
import 'package:recepi_app/ui/widgets/recepi-card.dart';
import 'package:recepi_app/utils/star-converter.dart';

import 'edit-profile-screen.dart';

final _appstate = getIt.get<AppState>();

class ProfileScreen extends StatelessWidget {
  final bool mine;
  ProfileScreen({this.mine});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
          actions: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 5),
              child: IconButton(
                color: Colors.black,
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
                                "Are you sure you want to log out",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            DividerCustom(
                              coloR: Colors.black.withOpacity(0.3),
                              heighT: 0.5,
                            ),
                            Wrap(
                              children: <Widget>[
                                FlatButton(
                                  padding: EdgeInsets.all(10),
                                  child: Text("Yes"),
                                  onPressed: () {
                                    _appstate.logout();
                                    Navigator.pop(context);
                                  },
                                ),
                                FlatButton(
                                  padding: EdgeInsets.all(10),
                                  child: Text("No"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            )
                          ],
                        );
                      },
                      context: context);
                },
                icon: Icon(MdiIcons.logoutVariant),
              ),
            )
          ],
        ),
        body: RefreshIndicator(
            onRefresh: () => _appstate.getProfile(mine: true),
            child: StreamBuilder(
              stream: _appstate.hasProfile,
              builder: (context, AsyncSnapshot<bool> hasProfile) {
                if (_appstate.getHasProfile) {
                  return StreamBuilder(
                    stream: _appstate.profile,
                    builder: (context, AsyncSnapshot<Profile> profile) {
                      return ProfileWidget(
                        profile: _appstate.profileValue,
                      );
                    },
                  );
                } else if (_appstate.getHasProfile == false) {
                  return NewProfileForm();
                }

                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                  ),
                );
              },
            )));
  }
}

class ProfileWidget extends StatelessWidget {
  final Profile profile;
  const ProfileWidget({Key key, this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      key: PageStorageKey<String>("profile"),
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Stack(
              children: <Widget>[
                Positioned(
                  left: MediaQuery.of(context).size.height * 0.3,
                  top: MediaQuery.of(context).size.height * 0.1,
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.red,
                  ),
                ),
                Positioned(
                  left: MediaQuery.of(context).size.height * 0.05,
                  top: MediaQuery.of(context).size.height * 0.1,
                  child: CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.pinkAccent,
                  ),
                ),
                Positioned(
                  left: MediaQuery.of(context).size.height * 0.3,
                  top: MediaQuery.of(context).size.height * 0.3,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.yellowAccent,
                  ),
                ),
                Positioned(
                  left: MediaQuery.of(context).size.height * 0.5,
                  top: MediaQuery.of(context).size.height * 0.2,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.lightGreen,
                  ),
                ),
                Positioned(
                  left: MediaQuery.of(context).size.height * 0.1,
                  top: MediaQuery.of(context).size.height * 0.4,
                  child: CircleAvatar(
                    radius: 80,
                    backgroundColor: Color(0xff42a5f5),
                  ),
                ),
                Container(
                  color: Colors.white.withOpacity(0.3),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.amber,
                        child: Icon(
                          getStar(
                            DateTime.parse(profile.birthDate),
                          ),
                          color: Colors.white,
                          size: 60,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                      ),
                      Text(
                        profile.name,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 23,
                            fontWeight: FontWeight.bold),
                      ),
                      DividerCustom(
                        coloR: Colors.black,
                        heighT: 0.3,
                        verticalMargin: 8,
                      ),
                      Text(profile.bio, style: TextStyle(color: Colors.black)),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 15),
                      )
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    color: Colors.transparent,
                    icon: Icon(
                      Icons.edit,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => EditProfileScreen()));
                    },
                  ),
                )
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
              (context, index) =>
                  _appstate.getRecepis[index].profile['id'] == profile.id
                      ? RecepiCard(
                          recepi: _appstate.getRecepis[index],
                        )
                      : SizedBox.shrink(),
              childCount: _appstate.getRecepis.length),
        )
      ],
    );
  }
}
