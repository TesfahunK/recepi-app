import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recepi_app/data/appstate.dart';
import 'package:recepi_app/data/get-it.dart';

import 'package:recepi_app/data/models/recepi.dart';
import 'package:recepi_app/ui/screens/add-recipe-screen.dart';
import 'package:recepi_app/ui/screens/feeds-screen.dart';
import 'package:recepi_app/ui/screens/profile-screen.dart';
import 'package:recepi_app/ui/screens/recepi-screen.dart';
import 'package:recepi_app/ui/widgets/divider.dart';
import 'package:recepi_app/utils/imagedecoder.dart';
import 'package:recepi_app/utils/star-converter.dart';

class RecepiCard extends StatelessWidget {
  /// This widget is responsible for showing a card widget
  /// holding different properties of a recepi
  /// [recepi] passed by the parent widget and provides the recepi data
  /// [profileLinkActive] is a boolean value that decides
  ///  whether to make the profile avatar on this card active or not

  final Recepi recepi;
  final bool profileLinkActive;
  final _appstate = getIt.get<AppState>();
  RecepiCard({this.recepi, this.profileLinkActive = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 1),
      padding: EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 2,
                offset: Offset(1, 1))
          ]),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RecepiScreen(
                        recepi: recepi,
                      )));
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      if (profileLinkActive) {
                        _appstate.getProfile(
                            id: recepi.profile['id'], mine: false);
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (ctx) => ProfileScreen(
                                      mine: false,
                                    )));
                      }
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.black.withOpacity(0.3),
                          radius: 25,
                          child: Icon(
                            getStar(
                                DateTime.parse(recepi.profile['birthdate'])),
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Wrap(
                          direction: Axis.vertical,
                          crossAxisAlignment: WrapCrossAlignment.start,
                          children: <Widget>[
                            Text(recepi.profile['name']),
                          ],
                        ),
                      ],
                    ),
                  ),
                  recepi.profile['id'] == _appstate.profileValue.id
                      ? Wrap(
                          spacing: 10,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                showModalBottomSheet(
                                    builder: (BuildContext context) {
                                      return Column(
                                        textDirection: TextDirection.ltr,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(top: 30),
                                            padding:
                                                EdgeInsets.only(bottom: 10),
                                            child: Text(
                                              "Delete Recepi?",
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          ),
                                          DividerCustom(
                                            coloR:
                                                Colors.black.withOpacity(0.3),
                                            heighT: 0.5,
                                          ),
                                          Wrap(
                                            children: <Widget>[
                                              FlatButton(
                                                padding: EdgeInsets.all(10),
                                                child: Text("Yes"),
                                                onPressed: () async {
                                                  await _appstate.deleteRecepi(
                                                      recepi.id, recepi);
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
                            ),
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) => AddRecipeScreen(
                                              recepi: recepi,
                                              editMode: true,
                                            )));
                              },
                            ),
                          ],
                        )
                      : SizedBox.shrink()
                ],
              ),
            ),
            Container(
              height: 350,
              child: Stack(
                children: <Widget>[
                  FutureBuilder(
                    future: decodedImage(recepi.imgUrl, context),
                    builder: (context, AsyncSnapshot<Image> image) {
                      if (image.hasData) {
                        return Container(
                          height: 350,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10)),
                              image: DecorationImage(
                                  image: image.data.image, fit: BoxFit.cover)),
                        );
                      }
                      return Container(
                        height: 350,
                        color: Colors.grey.withOpacity(0.5),
                      );
                    },
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: EdgeInsets.only(
                          top: 10, left: 12, right: 12, bottom: 20),
                      color: Colors.black.withOpacity(0.3),
                      height: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              recepi.dish,
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.av_timer,
                                size: 25,
                                color: Colors.white,
                              ),
                              DividerCustom(
                                coloR: Colors.white,
                                verticalMargin: 2,
                              ),
                              Text(
                                "${recepi.duration['hr']}hr & ${recepi.duration['mm']}mm",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            recepi.tags.length > 0
                ? Padding(
                    padding: const EdgeInsets.only(
                        bottom: 10, left: 10, right: 8, top: 8),
                    child: Wrap(
                        runAlignment: WrapAlignment.start,
                        spacing: 5,
                        runSpacing: 2,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              CupertinoIcons.tags,
                              size: 25,
                            ),
                          )
                        ]
                            .followedBy(recepi.tags.map(
                              (f) => ActionChip(
                                shadowColor: Colors.black.withOpacity(0.2),
                                label: Text("$f"),
                                onPressed: () {
                                  showSearch(
                                      context: context,
                                      delegate: RecepiSearch(tag: true),
                                      query: f);
                                },
                              ),
                            ))
                            .toList()),
                  )
                : SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
