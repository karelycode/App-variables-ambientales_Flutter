import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ListaDatos extends StatefulWidget {
  @override
  _ListaDatosState createState() => _ListaDatosState();
}

class _ListaDatosState extends State<ListaDatos> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _data = [];
  List<Map<String, dynamic>> _filteredData = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    QuerySnapshot snapshot =
    await FirebaseFirestore.instance.collection('variablesTH').get();
    setState(() {
      _data = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      _filteredData = _data;
    });
  }

  void _filterData(String query) {
    setState(() {
      _filteredData = _data.where((item) =>
      item['temperatura'].toString().contains(query) ||
          item['humedad'].toString().contains(query)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text('Lectura De Ambiente'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: SizedBox(
              height: 45.0,
              child: TextField(
                controller: _searchController,
                onChanged: _filterData,
                decoration: InputDecoration(
                  hintText: 'Buscar...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  suffixIcon: Icon(Icons.search),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                ),
              ),

            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredData.length,
              itemBuilder: (context, index) {
                final item = _filteredData[index];
                final temperature = double.parse(item['temperatura'].toString());
                final humidity = double.parse(item['humedad'].toString());
                final date = item['fecha'];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircularPercentIndicator(
                          radius: 50.0,
                          lineWidth: 10.0,
                          percent: temperature / 100,
                          center: Text("${temperature.toInt()}°C"),
                          progressColor: temperature > 30
                              ? Colors.red
                              : (temperature > 20 ? Colors.orange : Colors.blue),
                        ),
                        CircularPercentIndicator(
                          radius: 50.0,
                          lineWidth: 10.0,
                          percent: humidity / 100,
                          center: Text("${humidity.toInt()}%"),
                          progressColor: Colors.cyan[700],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Temperatura: ${temperature.toString()}°C"),
                            SizedBox(height: 8.0),
                            Text("Humedad: ${humidity.toString()}%"),
                            SizedBox(height: 8.0),
                            Text("Fecha: ${date.toString()}"),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}