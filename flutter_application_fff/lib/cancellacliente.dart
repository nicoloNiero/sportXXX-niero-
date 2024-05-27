import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Cancellacliente extends StatefulWidget {
  final String ip;
  final String endpoint;

  Cancellacliente({
    required this.ip,
    required this.endpoint,
  });

  @override
  _CancellasportState createState() => _CancellasportState();
}

class _CancellasportState extends State<Cancellacliente> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _sportController;

  @override
  void initState() {
    super.initState();
    _sportController = TextEditingController();
  }

  @override
  void dispose() {
    _sportController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final url = 'http://${widget.ip}/dino/eraseCliente.php';
      var body = {
        'utente': _sportController.text,
      };
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );
      print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.pop(context);
      } else {
        print('Failed to delete cliente: ${response.body}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cancella cliente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _sportController,
                decoration: InputDecoration(
                  labelText: 'Nome del cliente',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Inserisci il nome del cliente';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Conferma'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
