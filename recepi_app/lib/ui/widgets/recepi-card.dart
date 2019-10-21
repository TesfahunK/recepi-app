import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recepi_app/data/appstate.dart';
import 'package:recepi_app/data/get-it.dart';

import 'package:recepi_app/data/models/recepi.dart';
import 'package:recepi_app/ui/screens/add-recipe-screen.dart';
import 'package:recepi_app/ui/screens/feeds-screen.dart';
import 'package:recepi_app/ui/screens/recepi-screen.dart';
import 'package:recepi_app/ui/widgets/divider.dart';
import 'package:recepi_app/utils/imagedecoder.dart';

class RecepiCard extends StatelessWidget {
  final Recepi recepi;
  final _appstate = getIt.get<AppState>();
  RecepiCard({this.recepi});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: decodedImageProvider(recepi.imgUrl),
                        radius: 25,
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
            FutureBuilder(
              future: decodedImage(recepi.imgUrl, context),
              builder: (context, AsyncSnapshot<Image> image) {
                if (image.hasData) {
                  return Container(
                    height: 300,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: image.data.image, fit: BoxFit.cover)),
                  );
                }
                return Container(
                  height: 200,
                  color: Colors.grey.withOpacity(0.5),
                );
              },
            ),
            // Container(
            //   height: 300,
            //   decoration: BoxDecoration(
            //       image: DecorationImage(image: NetworkImage(recepi.imgUrl))),
            // ),
            Padding(
              padding: EdgeInsets.only(top: 10, left: 12, right: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      recepi.dish,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.av_timer,
                        size: 25,
                        color: Colors.black,
                      ),
                      DividerCustom(
                        coloR: Colors.white,
                        verticalMargin: 2,
                      ),
                      Text("${recepi.duration}"),
                      Text("Cook")
                    ],
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
