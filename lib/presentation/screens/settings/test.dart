import 'package:flutter/material.dart';

class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text((null as String).length.toString()); // deliberate null error
  }
}
