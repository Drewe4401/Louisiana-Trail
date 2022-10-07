// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:louisianatrail/components/infocard.dart';
import 'package:louisianatrail/variables.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: 200,
              margin: EdgeInsets.only(top: 20, left: 20),
              child: Text("What's new on the trail",
                  style: Theme.of(context).textTheme.labelLarge),
            ),
            Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.purple, width: 2),
                    borderRadius: BorderRadius.circular(8)),
                margin: EdgeInsets.only(bottom: 5, right: 20),
                padding: EdgeInsets.all(3),
                child: InkWell(
                  onTap: () => {print("Filter")},
                  child: Row(
                    children: [
                      Icon(MdiIcons.filter),
                      Text("Classes",
                          style: Theme.of(context).textTheme.headlineMedium),
                      Icon(MdiIcons.chevronDown),
                    ],
                  ),
                )),
          ],
        ),
        StreamBuilder(
            stream: trailcollection.snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.data != null) {
                return Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      padding: EdgeInsets.all(0),
                      itemBuilder: (context, index) {
                        DocumentSnapshot document = snapshot.data!.docs[index];
                        return Padding(
                          padding: EdgeInsets.all(10.0),
                          child: InfoCard(
                              title: document["title"],
                              desc: document["desc"],
                              host: document["host"],
                              address: document["address"]),
                        );
                      }),
                );
              } else {
                return CircularProgressIndicator();
              }
            }),
      ],
    )));
  }
}
