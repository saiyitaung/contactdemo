
import 'package:hive/hive.dart';
import 'package:mycontactapp/entity/mycontact.dart';

class MyContactAdapter extends TypeAdapter<MyContact>{
  final typeId=1;
  MyContact read(BinaryReader reader){
 var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MyContact()
    ..uuid = fields[0] as String
    ..name = fields[1] as String?
    ..picture = fields[2] as String
    ..numbers = (fields[3] as List).cast<String>()
    ..audioName = fields[4] as String
    ..isFavorite = fields[5] as bool;
    
  }
  void write(BinaryWriter writer,MyContact c){
    writer
    ..writeByte(6)
    ..writeByte(0)
    ..write(c.uuid)
    ..writeByte(1)
    ..write(c.name)
    ..writeByte(2)
    ..write(c.picture)
    ..writeByte(3)
    ..write(c.numbers)
    ..writeByte(4)
    ..write(c.audioName)
    ..writeByte(5)
    ..write(c.isFavorite);
  }
}