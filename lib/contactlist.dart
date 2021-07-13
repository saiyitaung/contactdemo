import 'dart:io';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:mycontactapp/detail.dart';
import 'package:mycontactapp/entity/mycontact.dart';
import 'package:mycontactapp/newcontact.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mycontactapp/utils/util.dart';

class ContactList extends StatefulWidget {
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  late List<MyContact> contactList;
  Box<MyContact> box = Hive.box(DB);
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("All contact"),
        ),
        body: ValueListenableBuilder(
          valueListenable: box.listenable(),
          builder: (context, Box<MyContact> contacts, child) {
            contactList = contacts.values.toList();
            return GridView.builder(
              padding: EdgeInsets.all(5),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  childAspectRatio: 1.1),
              itemBuilder: (context, index) {
                return OpenContainer(
                  transitionDuration: Duration(milliseconds: 350),
                  transitionType: ContainerTransitionType.fade,

                  closedBuilder: (context, closeContainer) {
                  return Card(
                     margin: EdgeInsets.zero,
                    child: Container(
                      decoration: BoxDecoration(
                        // borderRadius: BorderRadius.circular(5),

                        image: contactList[index].picture != ""
                            ? DecorationImage(
                                image: FileImage(
                                  File(contactList[index].picture!),
                                ),
                                fit: BoxFit.cover)
                            : DecorationImage(
                                image: AssetImage("assets/img/defaultpic.png"),
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  );
                }, openBuilder: (context, openContainer) {
                  return DetailPage(contactList[index]);
                });
              },
              itemCount: contactList.length,
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute<MyContact>(
                    builder: (context) => NewContact("")))
                .then((value) {
              if (value != null) {
                print("${value.picture}");
                setState(() {
                  // contactList.add(value);
                  box.put(value.uuid, value);
                });
              }
            });
          },
        ));
  }
}
