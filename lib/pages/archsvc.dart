import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class CSVScreen2 extends StatelessWidget {

  Future<void> exportDataToCSV() async {

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('variablesTH').get();

    List<List<dynamic>> csvData = [];
    csvData.add(['fecha', 'humedad', 'temperatura']); // Cambia los nombres de los campos según tu colección
    querySnapshot.docs.forEach((doc) {
      csvData.add([doc['fecha'], doc['humedad'], doc['temperatura']]);
    });

    String dir = (await getApplicationDocumentsDirectory()).path;
    String csvFilePath = '$dir/humTemp.csv';
    File csvFile = File(csvFilePath);

    String csv = const ListToCsvConverter().convert(csvData);
    await csvFile.writeAsString(csv);
    print('Archivo CSV guardado en: $csvFilePath');


    final smtpServer = gmail('tu correo del servicio de correos', 'contraseña'); //ver video para generar la clave

    final message = Message()
      ..from = Address('correo para recibir', 'Variables Ambientales')
      ..recipients.add('correo para recibir') // Cambiar al correo del destinatario
      ..subject = 'Archivo CSV'
      ..text = 'Adjunto encontrarás el archivo CSV.'
      ..attachments.add(FileAttachment(File(csvFilePath)));

    // Enviar el correo electrónico
    try {
      final sendReport = await send(message, smtpServer);
      print('Correo electrónico enviado: ${sendReport.toString()}');
    } catch (e) {
      print('Error al enviar el correo electrónico: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Correo electrónico'),
      ),
      body: Center(
        child:
          ElevatedButton(
            onPressed: exportDataToCSV,
            child: Text('Enviar datos por correo electrónico'),
          ),
      ),
    );
  }
}