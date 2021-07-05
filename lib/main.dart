import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

void main() {
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

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> imgNames = [
    "assets/img/pone.jfif",
    "assets/img/ptwo.jfif",
    "assets/img/pthree.jfif",
    "assets/img/pfour.jfif",
    "assets/img/pone.jfif",
    "assets/img/ptwo.jfif",
    "assets/img/pthree.jfif",
    "assets/img/pfour.jfif",
    "assets/img/pone.jfif",
    "assets/img/ptwo.jfif",
    "assets/img/pthree.jfif",
    "assets/img/pfour.jfif",
    "assets/img/pone.jfif",
    "assets/img/ptwo.jfif",
    "assets/img/pthree.jfif",
    "assets/img/pfour.jfif"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      body: Container(
        padding: EdgeInsets.only(top:22),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 80,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Container(
                    height: 80,
                    width: 80,
                    margin: EdgeInsets.symmetric(horizontal: 1),
                    // decoration: BoxDecoration(shape: BoxShape.circle),
                    child: OpenContainer(
                      closedColor: Colors.teal,
                      closedShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      transitionDuration: Duration(milliseconds: 350),
                      transitionType: ContainerTransitionType.fade,
                      closedBuilder: (context, closeContainer) {
                        return Image(
                          image: AssetImage(imgNames[index]),
                          fit: BoxFit.cover,
                        );
                      },
                      openBuilder: (context, openContainer) {
                        return DetailPage(imgNames[index]);
                      },
                    ),
                  );
                },
                itemCount: 10,
                scrollDirection: Axis.horizontal,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          // borderRadius: BorderRadius.only(topRight: Radius.)),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: AssetImage(imgNames[index]),
                              fit: BoxFit.cover)),
                    ),
                    title: Text(
                      "09245631548",
                      style: TextStyle(fontSize: 22),
                    ),
                    subtitle: Row(
                      children: [
                        Icon(
                          Icons.call_missed,
                          color: Colors.red,
                        ),
                        Text("July 5,2021")
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.speaker),
                      onPressed: () {},
                    ),
                  );
                },
                itemCount: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final String img;
  DetailPage(this.img);
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail page"),
      ),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: (MediaQuery.of(context).size.height / 100) * 40,
            child: Image(
              image: AssetImage(img),
              fit: BoxFit.cover,
            ),
          ),
          Container(
            height: 60,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child: IconButton(onPressed: () {}, icon: Icon(Icons.mic)),
                ),
                Container(
                  child:
                      IconButton(onPressed: () {}, icon: Icon(Icons.speaker)),
                ),
                Container(
                  child: IconButton(onPressed: () {}, icon: Icon(Icons.call)),
                ),
              ],
            ),
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(Icons.phone),
                title: Text("Phone Number"),
              );
            },
            itemCount: 2,
          )),
        ],
      ),
    );
  }
}
