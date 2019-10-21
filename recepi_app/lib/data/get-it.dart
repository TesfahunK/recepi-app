import 'package:get_it/get_it.dart';
import 'package:recepi_app/data/appstate.dart';

GetIt getIt = GetIt.instance;

// this  class initiates a global static instance of the global state
class GetItInstance {
  GetItInstance() {
    getIt.registerSingleton<AppState>(new AppState());
  }
}
