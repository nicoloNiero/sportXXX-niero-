import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Addcliente extends StatefulWidget {
  final String ip;
  final String endpoint;
  final Map<String, dynamic>? data;

  Addcliente({
    required this.ip,
    required this.endpoint,
    this.data,
  });

  @override
  _DataFormScreenState createState() => _DataFormScreenState();
}

class _DataFormScreenState extends State<Addcliente> {
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
        _controllers[key] = TextEditingController(text: value.toString());
      });
    }
  }

  Future<void> _submitForm() async {
    final url = 'http://${widget.ip}/dino/createCliente.php';
    var body = {
      'utente': _controllers['utente']!.text,
      'pasword': _controllers['pasword']!.text,
      'indirizzo': _controllers['indirizzo']!.text,
    };
    print('bananaaa');
    print(body);

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
        title: const Text('aggiungi cliente'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          TextField(
            controller: _controllers['utente'],
            decoration: const InputDecoration(hintText: "nome del utente"),
          ),
          TextField(
            controller: _controllers['pasword'],
            decoration: const InputDecoration(hintText: "password"),
          ),
          TextField(
            controller: _controllers['indirizzo'],
            decoration: const InputDecoration(hintText: "indirizzo"),
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
