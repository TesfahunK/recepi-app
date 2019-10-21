import 'package:recepi_app/data/models/ingridient.dart';
import 'package:recepi_app/data/models/step.dart';

class Recepi {
  String imgUrl;
  String dish;
  String id;
  List<RecepiStep> steps = [];
  List<Ingridient> ingridients = [];
  List<String> tags = [];
  List<String> equipments = [];
  Map<String, String> profile;
  String duration;

  List<RecepiStep> _stepFactory(List stepdata) {
    List<RecepiStep> _converted =
        stepdata.map((f) => RecepiStep.fromJson(f)).toList();
    return _converted;
  }

  List<Ingridient> _ingridientFactory(List ingdata) {
    List<Ingridient> _converted =
        ingdata.map((f) => Ingridient.fromJson(f)).toList();
    return _converted;
  }

  List<String> _stringListFromMap(List list) {
    List<String> _list = list.map<String>((f) => f).toList();
    return _list;
  }

  Recepi(
      {this.dish,
      this.ingridients,
      this.equipments,
      this.steps,
      this.tags,
      this.duration});
  Recepi.fromJson(Map<String, dynamic> recepi) {
    this.dish = recepi['dish'];
    this.id = recepi['id'];
    this.steps = _stepFactory(recepi['steps']);
    this.ingridients = _ingridientFactory(recepi['ingridients']);
    this.duration = recepi['duration'];
    this.imgUrl = recepi['img_url'] ?? "";
    this.tags = _stringListFromMap(recepi['tags']);
    this.equipments = _stringListFromMap(recepi['equipments']);
    this.profile = {
      "name": recepi["profile"]['name'].toString(),
      "id": recepi["profile"]['id'].toString(),
      "img_url": recepi["profile"].toString()
    };
  }

  Map<String, dynamic> tomap(Recepi data, String profileId, String image) {
    return {
      "dish": data.dish,
      "steps":
          data.steps.map<Map<String, String>>((ing) => ing.toMap(ing)).toList(),
      "ingridients": data.ingridients
          .map<Map<String, String>>((ing) => ing.toMap(ing))
          .toList(),
      "tags": data.tags.map<String>((tag) => tag).toList(),
      "equipments": data.equipments.map((eq) => eq).toList(),
      "duration": data.duration,
      "profileId": profileId,
      "img_url": image
    };
  }
}
