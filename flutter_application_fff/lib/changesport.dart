import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Changesport extends StatefulWidget {
  final String ip;
  final String endpoint;
  final Map<String, dynamic>? data;

  Changesport({
    required this.ip,
    required this.endpoint,
    this.data,
  });

  @override
  _DataFormScreenState createState() => _DataFormScreenState();
}

class _DataFormScreenState extends State<Changesport> {
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
    final url = 'http://${widget.ip}/dino/updateSport.php';
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
            controller: _controllers['nome_sport'],
            decoration: const InputDecoration(hintText: "nome dello sport"),
          ),
          TextField(
            controller: _controllers['descrizione'],
            decoration:
                const InputDecoration(hintText: "descrizione dello sport"),
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
