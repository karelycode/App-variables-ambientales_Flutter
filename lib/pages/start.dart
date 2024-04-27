import 'package:flutter/material.dart';
import 'package:varambientales/pages/listadatos.dart';

class Start extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _StartApp();
  }
}
class _StartApp extends State<Start>{
  int _selectedIndex=0;
  final List<Widget> _children=[
    ListaDatos(),
    ListaDatos(),
  ];
  void _onItemTapped(int index){
    setState(() {
      _selectedIndex=index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme=Theme.of(context).colorScheme;
    final textTheme=Theme.of(context).textTheme;
    return Scaffold(
      body: Center(
        child: _children[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Theme.of(context).colorScheme.primary,
        selectedItemColor: Theme.of(context).colorScheme.inversePrimary,
        unselectedItemColor:colorScheme.onSurface.withOpacity(.80),
        items:const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Inicio'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.language),
              label: 'ListaDatos'
          )
        ],
      ),
    );
  }

}