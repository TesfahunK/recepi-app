import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:recepi_app/data/appstate.dart';
import 'package:recepi_app/data/get-it.dart';
import 'package:recepi_app/data/models/recepi.dart';
import 'package:recepi_app/ui/widgets/recepi-card.dart';

class FeedsScreen extends StatelessWidget {
  final _appstate = getIt.get<AppState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        displacement: 50,
        onRefresh: () => _appstate.getRecepies(),
        child: CustomScrollView(
          key: PageStorageKey<String>("feeds"),
          slivers: <Widget>[
            SliverAppBar(
              actions: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8),
                  child: IconButton(
                    onPressed: () {
                      showSearch(
                        context: context,
                        delegate: RecepiSearch(),
                      );
                    },
                    color: Colors.black,
                    icon: Icon(
                      Icons.search,
                    ),
                    iconSize: 30,
                  ),
                )
              ],
              floating: true,
              title: Text("Recepies"),
            ),
            StreamBuilder(
              stream: _appstate.fetching,
              builder: (context, AsyncSnapshot loading) {
                return !_appstate.getFetching
                    ? StreamBuilder(
                        stream: _appstate.recepis,
                        builder:
                            (context, AsyncSnapshot<List<Recepi>> recepis) {
                          if (_appstate.getRecepis.length > 0)
                            return SliverList(
                              delegate: SliverChildBuilderDelegate(
                                  (ctx, int index) => RecepiCard(
                                        recepi: _appstate.getRecepis[index],
                                      ),
                                  childCount: _appstate.getRecepis.length),
                            );
                          return SliverFillRemaining(
                            child: Center(
                                child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Icon(MdiIcons.emoticonFrown),
                                SizedBox(
                                  height: 5,
                                ),
                                Text("No Recepis")
                              ],
                            )),
                          );
                        })
                    : SliverFillRemaining(
                        child: Center(
                            child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.black),
                        )),
                      );
              },
            )
          ],
        ),
      ),
    );
  }
}

final _appstate = getIt.get<AppState>();

class RecepiSearch extends SearchDelegate<Recepi> {
  final bool tag;
  RecepiSearch({this.tag = false});

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      primaryColor: Colors.amberAccent,
      primaryIconTheme: IconTheme.of(context).copyWith(color: Colors.black),
      primaryColorBrightness: Brightness.light,
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      tag
          ? IconButton(
              color: Colors.black,
              onPressed: null,
              icon: Icon(MdiIcons.tag),
            )
          : SizedBox.shrink(),
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder(
      stream: _appstate.recepis,
      builder: (context, AsyncSnapshot<List<Recepi>> result) {
        if (result.hasData) {
          return query.length > 0
              ? ListView(
                  children: result.data
                      .where((re) => tag
                          ? re.tags.contains(query)
                          : re.dish
                              .toLowerCase()
                              .startsWith(query.toLowerCase()))
                      .map<Widget>((f) => RecepiCard(
                            recepi: f,
                          ))
                      .toList())
              : Container(
                  color: Colors.red,
                );
        }
        return Container(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(MdiIcons.emoticonConfused, size: 50),
                SizedBox(
                  height: 10,
                ),
                Text("No Recpes")
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder(
      stream: _appstate.recepis,
      builder: (context, AsyncSnapshot<List<Recepi>> suggestions) {
        if (suggestions.hasData) {
          return query == ""
              ? Container(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(Icons.search, size: 50),
                        SizedBox(
                          height: 10,
                        ),
                        Text("Search Recepes Here")
                      ],
                    ),
                  ),
                )
              : ListView(
                  children: suggestions.data
                      .where((re) => tag
                          ? re.tags.contains(query)
                          : re.dish
                              .toLowerCase()
                              .startsWith(query.toLowerCase()))
                      .map<Widget>((f) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: Icon(MdiIcons.bowl),
                            title: Text(f.dish),
                            onTap: () {
                              query = tag ? query : f.dish;
                            },
                          )))
                      .toList());
        }

        return Container(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(MdiIcons.emoticonConfused, size: 50),
                SizedBox(
                  height: 10,
                ),
                Text("No Recpes")
              ],
            ),
          ),
        );
      },
    );
  }
}
