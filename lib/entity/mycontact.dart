import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class MyContact {
  @HiveField(0)
  String? uuid;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? picture;
  @HiveField(3)
  List<String>? numbers;
  @HiveField(4)
  String? audioName;
  @HiveField(5)
  bool isFavorite;
  //contstructor
  MyContact({this.uuid, this.picture, this.numbers, this.audioName,
      this.name, this.isFavorite = false});
  //toString method
  String toString() {
    return "MyContact{ uuid : $uuid , name : $name , picture : $picture , number : $numbers , audioName :$audioName,isFavorite : $isFavorite }";
  }
}
