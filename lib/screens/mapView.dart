// ignore_for_file: prefer_const_constructors

import 'package:louisianatrail/components/map.dart';
import 'package:louisianatrail/components/mapCard.dart';
import 'package:louisianatrail/screens/auth.dart';
import 'package:louisianatrail/screens/navigation.dart';
import 'package:louisianatrail/variables.dart';
import 'package:flutter/material.dart';

class MapPage extends StatefulWidget {
  final String? title;
  final String? desc;
  final String? host;
  final String? address;
  final String? tag;
  const MapPage(
      {Key? key, this.title, this.desc, this.host, this.address, this.tag})
      : super(key: key);

  @override
  State<MapPage> createState() => _MapState();
}

class _MapState extends State<MapPage> {
  bool active = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GPSMap(
      address: address,
      interactive: true,
      marker: widget.tag != null
          ? Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                GestureDetector(
                    onTap: () => setState(() {
                          active = !active;
                          print(active);
                        }),
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: CustomPaint(
                        painter: MyPainter(
                            inputText: tags[widget.tag]!, inputSize: 25),
                      ),
                    )),
                if (active)
                  Positioned(
                    left: 50,
                    bottom: 100,
                    width: 200,
                    child: MapCard(
                        title: widget.title,
                        desc: widget.desc,
                        host: widget.host,
                        address: widget.address),
                  ),
              ],
            )
          : SizedBox(),
    ));
  }
}
