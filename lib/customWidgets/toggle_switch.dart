import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../utils/constants.dart';

class ToggleSwitchWidget extends StatefulWidget {
  final int? isOn;
  final Function(int) onToggle;

  const ToggleSwitchWidget({
    Key? key,
    required this.isOn,
    required this.onToggle,
  }) : super(key: key);

  @override
  State<ToggleSwitchWidget> createState() => _ToggleSwitchWidget();
}

class _ToggleSwitchWidget extends State<ToggleSwitchWidget> {

  late int isOn;

  @override
  void initState() {
    super.initState();
    isOn = widget.isOn!;
  }

  @override
  Widget build(BuildContext context) {
    return ToggleSwitch(
      minHeight: 30,
      minWidth: 40,
      cornerRadius: 20,
      fontSize: 20,
      activeBgColors: isOn == 0
          ? [[Colors.green], [Colors.blue]]
          : [[Colors.blue], [Colors.green]],
      activeFgColor: Colors.white,
      inactiveBgColor: Colors.grey,
      inactiveFgColor: Colors.white,
      totalSwitches: 2,
      labels: const ['$degreeSign$celsius', '$degreeSign$fahrenheit'],
      onToggle: (value) {
        setState(() {
          isOn = value!;
        });
        widget.onToggle(isOn);
      },
    );
  }
}