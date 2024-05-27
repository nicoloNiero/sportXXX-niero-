import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Changearticolo extends StatefulWidget {
  final String ip;
  final String endpoint;
  final Map<String, dynamic>? data;

  Changearticolo({
    required this.ip,
    required this.endpoint,
    this.data,
  });

  @override
  _DataFormScreenState createState() => _DataFormScreenState();
}

class _DataFormScreenState extends State<Changearticolo> {
  final Map<String, TextEditingController> _controllers = {
    "nome": TextEditingController(),
    "idArticolo": TextEditingController(),
    "quantita": TextEditingController(),
    "costo": TextEditingController(),
    "sport": TextEditingController(),
  };

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      widget.data!.forEach((key, value) {
        if (_controllers.containsKey(key)) {
          _controllers[key]!.text = value.toString();
        }
      });
    }
  }

  Future<void> _submitForm() async {
    final url = 'http://${widget.ip}/dino/updateArticolo.php';
    var body = {
      'nome': _controllers['nome']!.text,
      'idArticolo': _controllers['idArticolo']!.text,
      'quantita': _controllers['quantita']!.text,
      'costo': _controllers['costo']!.text,
      'sport': _controllers['sport']!.text,
    };
    final response = await http.post(
      Uri.parse(url),
      body: json.encode(body),
    );
    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Navigator.pop(context);
    } else {
      print('Failed to update data: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifica articolo'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          TextField(
            controller: _controllers['nome'],
            decoration: const InputDecoration(hintText: "Nome dell'articolo"),
          ),
          TextField(
            controller: _controllers['idArticolo'],
            decoration: const InputDecoration(hintText: "ID dell'articolo"),
          ),
          TextField(
            controller: _controllers['quantita'],
            decoration:
                const InputDecoration(hintText: "Quantità dell'articolo"),
          ),
          TextField(
            controller: _controllers['costo'],
            decoration: const InputDecoration(hintText: "Costo dell'articolo"),
          ),
          TextField(
            controller: _controllers['sport'],
            decoration: const InputDecoration(hintText: "Sport dell'articolo"),
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
