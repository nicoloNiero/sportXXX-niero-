import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Changenegozio extends StatefulWidget {
  final String ip;
  final String endpoint;
  final Map<String, dynamic>? data;

  Changenegozio({
    required this.ip,
    required this.endpoint,
    this.data,
  });

  @override
  _ChangearticoloState createState() => _ChangearticoloState();
}

class _ChangearticoloState extends State<Changenegozio> {
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
        if (_controllers.containsKey(key)) {
          _controllers[key] = TextEditingController(text: value.toString());
        }
      });
    }
  }

  Future<void> _submitForm() async {
    final url = 'http://${widget.ip}/dino/updateNegozio.php';
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
      print('Failed to update data: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifica negozio'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          TextField(
            controller: _controllers['num_tel'],
            decoration: const InputDecoration(hintText: "telefono del negozio"),
          ),
          TextField(
            controller: _controllers['indirizzo'],
            decoration:
                const InputDecoration(hintText: "indirizzo del negozio"),
          ),
          TextField(
            controller: _controllers['nome'],
            decoration: const InputDecoration(hintText: "Nome del negozio"),
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
