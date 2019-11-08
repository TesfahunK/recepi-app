import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:recepi_app/data/appstate.dart';
import 'package:recepi_app/data/get-it.dart';
import 'package:recepi_app/data/models/ingridient.dart';
import 'package:recepi_app/data/models/recepi.dart';
import 'package:recepi_app/data/models/step.dart';
import 'package:recepi_app/ui/widgets/divider.dart';
import 'package:recepi_app/ui/widgets/step-card.dart';
import 'package:recepi_app/utils/validators.dart';

class AddRecipeScreen extends StatefulWidget {
  final bool editMode;
  final Recepi recepi;

  const AddRecipeScreen({Key key, this.editMode = false, this.recepi})
      : super(key: key);

  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _appstate = getIt.get<AppState>();
// TextFormField controllers
  TextEditingController _ingridientName;
  TextEditingController _name;
  TextEditingController _ingridientAmount;
  TextEditingController _stepHeader;
  TextEditingController _stepDescription;
  TextEditingController _equipmentName;
  TextEditingController _tagName;

// FormState Keys : Used to validate fields when submitting a form
  GlobalKey<FormState> _ingridientFormKey = new GlobalKey<FormState>();
  GlobalKey<FormState> _stepFormKey = new GlobalKey<FormState>();
  GlobalKey<FormState> _equipmentKey = new GlobalKey<FormState>();
  GlobalKey<FormState> _tagKey = new GlobalKey<FormState>();

  List<RecepiStep> _steps = [];
  List<String> _equipments = [];
  List<Ingridient> _ingridients = [];
  List<String> _tags = [];
  File _image;
  String hr = "00";
  String mm = "30";

  bool posting = false;

  @override
  void initState() {
    _ingridientName = new TextEditingController();
    _name = new TextEditingController();
    _equipmentName = new TextEditingController();
    _tagName = new TextEditingController();
    _ingridientAmount = new TextEditingController();
    _stepDescription = new TextEditingController();
    _stepHeader = new TextEditingController();

    if (widget.editMode) {
      _name.text = widget.recepi.dish;
      _steps = widget.recepi.steps;
      _ingridients = widget.recepi.ingridients;
      _equipments = widget.recepi.equipments;
      _tags = widget.recepi.tags;
//      _image = await fromBase64ToFile(widget.recepi.imgUrl);
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

  bool _validateForm(BuildContext context) {
    if (_name.text.isEmpty) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Dish name is empty"),
        backgroundColor: Colors.black,
      ));
      return false;
    }
    if (_equipments.length == 0) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Equipments are empty"),
        backgroundColor: Colors.black,
      ));
      return false;
    }
    if (_steps.length < 2) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Steps can't be less than 2"),
        backgroundColor: Colors.black,
      ));
      return false;
    }
    if (_ingridients.length == 0) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Ingridients are empty"),
        backgroundColor: Colors.black,
      ));
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _appstate.hasProfile,
      initialData: false,
      builder: (context, AsyncSnapshot<bool> hasProfile) {
        if (_appstate.getHasProfile == true) {
          return Scaffold(
            body: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  actions: <Widget>[
                    IconButton(
                      onPressed: () {
                        setState(() {
                          posting = true;
                        });
                        if (_validateForm(context)) {
                          _appstate
                              .createRecepi(
                            image: _image,
                            recepi: Recepi(
                                dish: _name.text,
                                ingridients: _ingridients,
                                equipments: _equipments,
                                steps: _steps,
                                tags: _tags,
                                duration: {"hr": hr, "mm": mm}),
                          )
                              .then((done) {
                            setState(() {
                              posting = false;
                            });
                            _appstate.switchScreen(to: 0);
                          });
                        }
                        setState(() {
                          posting = false;
                        });
                      },
                      icon: posting
                          ? CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.black),
                            )
                          : Icon(Icons.send),
                    )
                  ],
                  title: widget.editMode
                      ? Text("Edit Recipe")
                      : Text("New Recipe"),
                  floating: true,
                ),
                SliverToBoxAdapter(
                  child: Container(
                    decoration: BoxDecoration(
                        border:
                            BorderDirectional(bottom: BorderSide(width: 0.2))),
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          child: _image != null
                              ? Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: _image != null
                                              ? FileImage(_image)
                                              : null)),
                                )
                              : Center(
                                  child: Icon(
                                  Icons.image,
                                  size: 100,
                                  color: Colors.blueGrey,
                                )),
                        ),
                        Positioned(
                          left: MediaQuery.of(context).size.width * 0.82,
                          top: MediaQuery.of(context).size.height * 0.3,
                          child: FloatingActionButton(
                            heroTag: "imagebut",
                            backgroundColor: Colors.blueGrey,
                            child: Icon(MdiIcons.paperclip),
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
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                _dishname(context),
                sliverHeader(
                    header: "Ingridients",
                    expansionchild: _addIngridient(),
                    length: _ingridients.length),
                _ingridientsBuilder(),
                sliverHeader(
                    header: "Equipments",
                    expansionchild: _addEquipment(),
                    length: _equipments.length),
                _equipmentsBuilder(),
                sliverHeader(
                    header: "Steps",
                    expansionchild: _addStep(),
                    length: _steps.length),
                _stepsBuilder(),
                sliverHeader(
                    header: "Tags",
                    expansionchild: _addTag(),
                    length: _tags.length),
                _tagsBuilder("Tags"),
                sliverHeader(
                  header:
                      "Preparation Time  ${hr ?? "00"}hr and ${mm ?? "00"}min",
                ),
                SliverToBoxAdapter(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Wrap(
                      spacing: 40,
                      alignment: WrapAlignment.center,
                      children: <Widget>[
                        Text(
                          "Hr",
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          "Mm",
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                    Container(
                      height: 100,
                      width: 200,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 100,
                            width: 100,
                            child: CupertinoPicker.builder(
                              backgroundColor: Colors.white,
                              childCount: 13,
                              itemBuilder: (BuildContext context, int index) {
                                return index > 9
                                    ? Text("$index")
                                    : Text("0$index");
                              },
                              itemExtent: 30,
                              onSelectedItemChanged: (int value) {
                                setState(() {
                                  hr = value > 9 ? "$value" : "0$value";
                                });
                              },
                            ),
                          ),
                          Container(
                            height: 100,
                            width: 100,
                            child: CupertinoPicker.builder(
                              backgroundColor: Colors.white,
                              childCount: 60,
                              itemBuilder: (BuildContext context, int index) {
                                return index > 9
                                    ? Text("$index")
                                    : Text("0$index");
                              },
                              itemExtent: 30,
                              onSelectedItemChanged: (int value) {
                                setState(() {
                                  mm = value > 9 ? "$value" : "0$value";
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ))
              ],
            ),
          );
        }
        return Container(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  MdiIcons.emoticonFrownOutline,
                  size: 30,
                ),
                SizedBox(
                  height: 10,
                ),
                Text("Create A Profile First")
              ],
            ),
          ),
        );
      },
    );
  }

//input dialogs
  Widget _addIngridient() {
    return Form(
      key: _ingridientFormKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          TextFormField(
            controller: _ingridientName,
            decoration: InputDecoration(
                labelText: 'Name', filled: false, fillColor: Colors.white70),
            validator: (str) {
              return stringValidator("name", str);
            },
          ),
          SizedBox(
            height: 15,
          ),
          TextFormField(
            controller: _ingridientAmount,
            decoration: InputDecoration(
                labelText: 'Amount(eg.1kg, 100gram, 1/2 Cup)',
                filled: false,
                fillColor: Colors.white70),
            validator: (str) {
              return stringValidator("amount", str);
            },
          ),
          SizedBox(
            height: 15,
          ),
          FlatButton(
            onPressed: () {
              if (_ingridientFormKey.currentState.validate()) {
                setState(() {
                  _ingridients.add(new Ingridient(
                      _ingridientName.text, _ingridientAmount.text));
                  _ingridientName = TextEditingController(text: "");
                  _ingridientAmount = TextEditingController(text: "");
                });
              }
            },
            child: Text(
              'add',
            ),
          )
        ],
      ),
    );
  }

  Widget _addStep() {
    return Form(
      key: _stepFormKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          TextFormField(
            controller: _stepHeader,
            decoration: InputDecoration(
                border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.redAccent)),
                labelText: 'Step Title',
                filled: false,
                fillColor: Colors.white70),
            validator: (str) {
              return stringValidator("title", str);
            },
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _stepDescription,
            maxLines: 5,
            decoration: InputDecoration(
                border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.redAccent)),
                labelText: 'Step Description',
                filled: false,
                fillColor: Colors.white70),
            validator: (str) {
              return stringValidator("description", str);
            },
          ),
          SizedBox(
            height: 15,
          ),
          FlatButton(
            onPressed: () {
              if (_stepFormKey.currentState.validate()) {
                setState(() {
                  _steps.add(
                      new RecepiStep(_stepHeader.text, _stepDescription.text));
                  _stepHeader = TextEditingController(text: "");
                  _stepDescription = TextEditingController(text: "");
                });
              }
            },
            child: Text(
              'add',
            ),
          ),
        ],
      ),
    );
  }

  Widget _addEquipment() {
    return Form(
      key: _equipmentKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          TextFormField(
            controller: _equipmentName,
            decoration: InputDecoration(
                border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.redAccent)),
                labelText: 'Name',
                filled: false,
                fillColor: Colors.white70),
            validator: (str) {
              return stringValidator("name", str);
            },
          ),
          FlatButton(
            onPressed: () {
              if (_equipmentKey.currentState.validate()) {
                setState(() {
                  _equipments.add(_equipmentName.text);
                  _equipmentName = TextEditingController(text: "");
                });
              }
            },
            child: Text(
              'add',
            ),
          )
        ],
      ),
    );
  }

  Widget _addTag() {
    return Container(
      child: Form(
        key: _tagKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextFormField(
              controller: _tagName,
              decoration: InputDecoration(
                  border: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.redAccent)),
                  labelText: 'Tag (eg. ethiopian, asian, holiday)',
                  filled: false,
                  fillColor: Colors.white70),
              validator: (str) {
                return stringValidator("tag", str);
              },
            ),
            FlatButton(
              onPressed: () {
                if (_tagKey.currentState.validate()) {
                  setState(() {
                    _tags.add(_tagName.text);
                    _tagName = TextEditingController(text: "");
                  });
                }
              },
              child: Text(
                'add',
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _dishname(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: TextFormField(
          controller: _name,
          decoration: InputDecoration(
              border: new OutlineInputBorder(
                  borderSide: new BorderSide(color: Colors.redAccent)),
              labelText: 'Dish name',
              filled: false,
              fillColor: Colors.white70),
          validator: (String value) {
            return stringValidator("dish", value);
          },
          onSaved: (String value) {},
        ),
      ),
    );
  }

//Sliver Widget Builders
  Widget sliverHeader({String header, int length, Widget expansionchild}) {
    String postfix = length != null ? " ($length)" : "";
    return SliverToBoxAdapter(
      child: Container(
          padding: EdgeInsets.only(left: 15, right: 15, top: 8),
          child: ExpansionTile(
            title: Text(
              header + postfix,
              style: TextStyle(fontSize: 19),
            ),
            trailing: Icon(Icons.add),
            children: <Widget>[expansionchild ?? SizedBox.shrink()],
          )),
    );
  }

  Widget _stepsBuilder() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
          (context, int index) => StepCard(
                index: index + 1,
                step: _steps[index],
              ),
          childCount: _steps.length),
    );
  }

  Widget _equipmentsBuilder() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          spacing: 5,
          runSpacing: 5,
          children: _equipments
              .map((f) => Chip(
                    deleteIcon: Icon(Icons.clear),
                    label: Text("$f"),
                    onDeleted: () {
                      setState(() {
                        _equipments.remove(f);
                      });
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget _tagsBuilder(String msg) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          spacing: 5,
          runSpacing: 5,
          children: _tags
              .map((f) => Chip(
                    backgroundColor: Colors.amberAccent,
                    deleteIcon: Icon(Icons.clear),
                    label: Text("$f"),
                    onDeleted: () {
                      setState(() {
                        _tags.remove(f);
                      });
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget _ingridientsBuilder() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          spacing: 5,
          runSpacing: 5,
          children: _ingridients
              .map((f) => Chip(
                    deleteIcon: Icon(Icons.clear),
                    label: Text("${f.name}(${f.amount})"),
                    onDeleted: () {
                      setState(() {
                        _ingridients.remove(f);
                      });
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
