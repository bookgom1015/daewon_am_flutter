import 'package:flutter/material.dart';

class ReceivablePage extends StatefulWidget {
  const ReceivablePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ReceivablePageState();
}

class _ReceivablePageState extends State<ReceivablePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Center(
        child: Text("ReceivablePage"),
      ),
    );
  }  
}