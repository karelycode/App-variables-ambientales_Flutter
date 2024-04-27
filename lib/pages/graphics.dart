import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Graphic extends class name extends StatefulWidget {
  Graphic ({Key? key}): super(key:key);

  @override
  _MyGraphics createState(){
    return _MyGraphics();
  }
}

class _MyGraphics extends State<Graphics> {
  List<_variablesData> data =<_variablesData>[];
  @override
  void initState(){
    getDataFromFireStore().then((results){
      SchedulerBinding.instance!.addPostFrameCallBack((String){
        setState((){});
      });
    });
    super.initState();
  }
  Future<void> getDataFromFireStore() async{
    var snapShotsValue =
    await FirenaseFirestore.instance.collection('variablesTH').get();
    List<_variablesData>((e.Data()['fecha']),(e.data()['temperatura'])));
  }).toList();
  setState
}
  @Override
    Widget build(BuildContext context){
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of.context,
        ),
      );
    }
  }
}


class _variablesData{
  _variablesData(this.year, this.datos);
  final String year;
  final String datos;

}