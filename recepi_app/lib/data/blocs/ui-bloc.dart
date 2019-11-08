import 'package:rxdart/rxdart.dart';

class UiBloc {
  /// **Handles bottom navigation indexing**
  /// decideds whit screen to show on the homescreen

  final _currentBottomBarIndex = new BehaviorSubject<int>.seeded(0);

  //Getters
  Observable<int> get currentBottomBarIndex => _currentBottomBarIndex.stream;

  //Switcher

  void switchScreen({int to}) {
    _currentBottomBarIndex.add(to);
  }
}
