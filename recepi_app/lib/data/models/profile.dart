import 'package:recepi_app/data/models/recepi.dart';

class Profile {
  List<Recepi> saved;
  String id;
  String birthDate;
  String bio;
  String imgUrl;
  String name;

  Profile(
      this.id, this.birthDate, this.name, this.bio, this.imgUrl, this.saved);
  List<Recepi> _savedFactory(List list) {
    List<Recepi> _list = [];
    for (var i = 0; i < list.length; i++) {
      _list.add(Recepi.fromJson(list[i]));
    }
    return _list;
  }

  Profile.fromMap(Map<String, dynamic> data) {
    this.bio = data['bio'];
    this.name = data['name'];
    this.id = data['id'];
    this.birthDate = data['birthdate'];
    this.imgUrl = data['img_url'];
    this.saved = _savedFactory(data['saved']);
  }
}
