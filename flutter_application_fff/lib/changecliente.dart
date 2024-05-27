import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Changecliente extends StatefulWidget {
  final String ip;
  final String endpoint;
  final Map<String, dynamic>? data;

  Changecliente({
    required this.ip,
    required this.endpoint,
    this.data,
  });

  @override
  _ChangearticoloState createState() => _ChangearticoloState();
}

class _ChangearticoloState extends State<Changecliente> {
  final Map<String, TextEditingController> _controllers = {
    "utente": TextEditingController(),
    "pasword": TextEditingController(),
    "indirizzo": TextEditingController(),
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
    final url = 'http://${widget.ip}/dino/updateCliente.php';
    var body = {
      'utente': _controllers['utente']!.text,
      'pasword': _controllers['pasword']!.text,
      'indirizzo': _controllers['indirizzo']!.text,
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
            controller: _controllers['utente'],
            decoration: const InputDecoration(hintText: "nome utente"),
          ),
          TextField(
            controller: _controllers['pasword'],
            decoration: const InputDecoration(hintText: "password del utente"),
          ),
          TextField(
            controller: _controllers['indirizzo'],
            decoration:
                const InputDecoration(hintText: "indirizzo del utente "),
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
