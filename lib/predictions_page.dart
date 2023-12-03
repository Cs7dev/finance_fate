import 'dart:io';
import 'package:flutter/material.dart';

class PredictionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Predictions Page'),
      ),
      body: Center(
        child: Text('Stock Price Predictions'),
      ),
    );
  }
}
