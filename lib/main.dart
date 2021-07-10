// import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mycontactapp/entity/mycontact.dart';
import 'package:mycontactapp/entity/mycontact.g.dart';
import 'package:mycontactapp/utils/util.dart';
import 'package:path_provider/path_provider.dart';
import './home.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final appdir=await getExternalStorageDirectory();
  await Hive.initFlutter(appdir!.path);
   Hive.registerAdapter(MyContactAdapter());
  await Hive.openBox<MyContact>(DB);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'my contact demo'),
    );
  }
}

