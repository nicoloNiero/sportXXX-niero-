import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Addsport extends StatefulWidget {
  final String ip;
  final String endpoint;
  final Map<String, dynamic>? data;

  Addsport({
    required this.ip,
    required this.endpoint,
    this.data,
  });

  @override
  _DataFormScreenState createState() => _DataFormScreenState();
}

class _DataFormScreenState extends State<Addsport> {
  final Map<String, TextEditingController> _controllers = {
    "nome_sport": TextEditingController(),
    "descrizione": TextEditingController(),
  };

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      widget.data!.forEach((key, value) {
        _controllers[key] = TextEditingController(text: value.toString());
      });
    }
  }

  Future<void> _submitForm() async {
    final url =
        'http://${widget.ip}/dino/createSport.php'; // Sostituisci 'nome-del-file-php.php' con il nome effettivo del tuo file PHP
    var body = {
      'nome_sport': _controllers['nome_sport']!.text,
      'descrizione': _controllers['descrizione']!.text,
    };
    final response = await http.post(
      Uri.parse(url),
      body: json.encode(body),
    );
    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Navigator.pop(context);
    } else {
      print('Failed to submit data: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('aggiungi SPORT'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          TextField(
            controller: _controllers['nome_sport'],
            decoration: const InputDecoration(hintText: "nome"),
          ),
          TextField(
            controller: _controllers['descrizione'],
            decoration: const InputDecoration(hintText: "descrizione"),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _submitForm,
        child: Icon(Icons.save),
      ),
    );
  }
}
