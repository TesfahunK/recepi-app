import 'package:recepi_app/data/blocs/profile-bloc.dart';
import 'package:recepi_app/data/blocs/recepis-bloc.dart';
import 'package:recepi_app/data/blocs/user-bloc.dart';

import 'blocs/ui-bloc.dart';

//this is a bucket class which is mixed in with different business logic
//controller classes that perform differnt actions, it also serves as GlobalState for the app
class AppState with UserBloc, RecepiBloc, ProfileBloc, UiBloc {
// This bucket class is populated with Subjects , Observables and getter methods

//Subjects

  Future initApp() async {
    await getProfile(mine: true);
    getRecepies();
  }
}
