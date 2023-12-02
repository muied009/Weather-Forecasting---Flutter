import 'dart:async';

import 'package:flutter/material.dart';

class ParallaxBackground extends StatefulWidget {
  @override
  _ParallaxBackgroundState createState() => _ParallaxBackgroundState();
}

class _ParallaxBackgroundState extends State<ParallaxBackground> {
  final cloudImages = [
    'images/cloud1.png',
    'images/cloud2.png',
    'images/cloud3.png',
    'images/cloud4.png',
  ];

  double offset = 0;
  double movementFactor = 2.0;
  double screenWidth = 0;
  double rowWidth = 2000;
  double rowOp = 0.5;

  @override
  void initState() {
    super.initState();
    startMovement();
  }

  @override
  void didChangeDependencies() {
    ///device er screen width calculation
    screenWidth = MediaQuery.of(context).size.width;
    //startMovement();
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          ///AnimatedPositioned = child gulo k lef to right / right to left / top to bottom / bottom to top move kora te pari
          AnimatedPositioned(
            duration: const Duration(milliseconds: 50),
            left: offset + screenWidth,
            child: SizedBox(
              width: rowWidth,
              child: Opacity(
                opacity: rowOp,
                child: Row(
                  children: cloudImages.map((imageOfClouds) => Expanded(child: Image.asset(imageOfClouds, height: 200,))).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );

  }



  void startMovement() {
    setState(() {
      if(rowOp == 0.0) {
        rowOp = 0.5;
      }
      //ekhane offset ( - ) korar karon = eitar jonnoi screenWidth theke ( - ) hocche jar karon e right to left jacche
      offset -= movementFactor;
    });
    if(offset < -(rowWidth + screenWidth)) {
      rowOp = 0.0;
      offset = 0;
    }
    //startMovement() only 1bar call kora holeo nicher line er karonei bar bar ( - ) hocche
    //proti 50 miliSecond e 1bar kore startMovement() eita call hocche
    Future.delayed(const Duration(milliseconds: 50), startMovement);
  }
}

