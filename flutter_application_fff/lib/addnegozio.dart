import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Addnegozio extends StatefulWidget {
  final String ip;
  final String endpoint;
  final Map<String, dynamic>? data;

  Addnegozio({
    required this.ip,
    required this.endpoint,
    this.data,
  });

  @override
  _DataFormScreenState createState() => _DataFormScreenState();
}

class _DataFormScreenState extends State<Addnegozio> {
  final Map<String, TextEditingController> _controllers = {
    "num_tel": TextEditingController(),
    "indirizzo": TextEditingController(),
    "nome": TextEditingController(),
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
    final url = 'http://${widget.ip}/dino/createNegozio.php';
    var body = {
      'num_tel': _controllers['num_tel']!.text,
      'indirizzo': _controllers['indirizzo']!.text,
      'nome': _controllers['nome']!.text,
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
        title: const Text('aggiungi negozio'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          TextField(
            controller: _controllers['num_tel'],
            decoration: const InputDecoration(hintText: "numero di telefono"),
          ),
          TextField(
            controller: _controllers['indirizzo'],
            decoration: const InputDecoration(hintText: "indirizzo"),
          ),
          TextField(
            controller: _controllers['nome'],
            decoration: const InputDecoration(hintText: "nome del negozio"),
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
