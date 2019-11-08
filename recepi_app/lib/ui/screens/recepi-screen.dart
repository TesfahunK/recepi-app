import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:recepi_app/data/models/recepi.dart';
import 'package:recepi_app/ui/widgets/chip.dart';
import 'package:recepi_app/ui/widgets/step-card.dart';
import 'package:recepi_app/utils/imagedecoder.dart';

import 'feeds-screen.dart';

/// This shows a full detail of recepi
class RecepiScreen extends StatelessWidget {
  final Recepi recepi;
  RecepiScreen({this.recepi});

  Widget sliverHeader({String header}) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.only(left: 15, right: 15, top: 8),
        decoration:
            BoxDecoration(border: Border(bottom: BorderSide(width: 0.2))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              header,
              style: TextStyle(fontSize: 19),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                color: Colors.black.withOpacity(0.2),
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                )),
            expandedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(recepi.dish),
              background: Stack(
                children: <Widget>[
                  FutureBuilder(
                    future: decodedImage(recepi.imgUrl, context),
                    builder: (context, AsyncSnapshot<Image> image) {
                      if (image.hasData) {
                        return Container(
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
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 80,
                      color: Colors.black.withOpacity(0.1),
                    ),
                  )
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
              child: recepi.tags.length > 0
                  ? Container(
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(width: 0.4))),
                      child: Padding(
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
                                  MdiIcons.tag,
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
                      ),
                    )
                  : SizedBox.shrink()),
          SliverToBoxAdapter(
              child: recepi.equipments.length > 0
                  ? Container(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            bottom: 10, left: 10, right: 8, top: 8),
                        child: Wrap(
                            runAlignment: WrapAlignment.start,
                            spacing: 5,
                            runSpacing: 2,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  "Equipments",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              )
                            ]
                                .followedBy(recepi.equipments.map(
                                  (f) => CustomChip(
                                    color: Colors.grey,
                                    textColor: Colors.white.withOpacity(1),
                                    lableText: f.toString(),
                                    isEquipment: true,
                                  ),
                                ))
                                .toList()),
                      ),
                    )
                  : SizedBox.shrink()),
          SliverToBoxAdapter(
              child: recepi.ingridients.length > 0
                  ? Container(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            bottom: 10, left: 10, right: 8, top: 8),
                        child: Wrap(
                            runAlignment: WrapAlignment.start,
                            spacing: 5,
                            runSpacing: 2,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  "Ingridients",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              )
                            ]
                                .followedBy(recepi.ingridients.map(
                                  (f) => CustomChip(
                                    color: Colors.amberAccent,
                                    textColor: Colors.black.withOpacity(1),
                                    ingridient: f,
                                    isIngridient: true,
                                  ),
                                ))
                                .toList()),
                      ),
                    )
                  : SizedBox.shrink()),
          sliverHeader(header: "Steps"),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                (context, int index) => StepCard(
                      index: index + 1,
                      step: recepi.steps[index],
                    ),
                childCount: recepi.steps.length),
          ),
        ],
      ),
    );
  }
}
