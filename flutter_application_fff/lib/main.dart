import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:progetto_finale/addarticolo.dart';
import 'package:progetto_finale/addcliente.dart';
import 'package:progetto_finale/addnegozio.dart';
import 'package:progetto_finale/addsport.dart';
import 'package:progetto_finale/changearticolo.dart';
import 'package:progetto_finale/changesport.dart';
import 'package:progetto_finale/changecliente.dart';
import 'package:progetto_finale/changenegozio.dart';
import 'package:progetto_finale/cancellaearticolo.dart';
import 'package:progetto_finale/cancellasport.dart';
import 'package:progetto_finale/cancellacliente.dart';
import 'package:progetto_finale/cancellanegozio.dart';
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SportDB App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: IPInputScreen(),
    );
  }
}

class IPInputScreen extends StatefulWidget {
  @override
  _IPInputScreenState createState() => _IPInputScreenState();
}

class _IPInputScreenState extends State<IPInputScreen> {
  final TextEditingController _controller = TextEditingController();

  void _navigateToDataScreen(String ip) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DataScreen(ip: ip),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inserisci IP Server'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'IP Server',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _navigateToDataScreen(_controller.text);
              },
              child: const Text('Connetti'),
            ),
          ],
        ),
      ),
    );
  }
}

class DataScreen extends StatefulWidget {
  final String ip;

  DataScreen({required this.ip});

  @override
  _DataScreenState createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  Future<List<dynamic>> _fetchData(String endpoint) async {
    final url = 'http://${widget.ip}/dino/$endpoint.php';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return json.decode(response.body)['records'];
      } else {
        throw Exception(
            
            'Failed to load data: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error connecting to $url: $e');
      throw Exception('Failed to connect to the server: $e');
    }
  }

  void _showData(BuildContext context, String endpoint) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DataViewScreen(
          ip: widget.ip,
          endpoint: endpoint,
          fetchData: _fetchData,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dati SportDB'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _showData(context, 'readArticolo'),
              child: const Text('Visualizza Articoli'),
            ),
            ElevatedButton(
              onPressed: () => _showData(context, 'readClinte'),
              child: const Text('Visualizza Clienti'),
            ),
            ElevatedButton(
              onPressed: () => _showData(context, 'readNegozio'),
              child: const Text('Visualizza Negozi'),
            ),
            ElevatedButton(
              onPressed: () => _showData(context, 'readSport'),
              child: const Text('Visualizza Sport'),
            ),
          ],
        ),
      ),
    );
  }

  void _requestNameAndDescription(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Inserisci Nome e Descrizione'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Descrizione'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annulla'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showForm(
                  context,
                  'add',
                  {
                    'nome_sport': nameController.text,
                    'descrizione': descriptionController.text,
                  },
                );
              },
              child: const Text('Conferma'),
            ),
          ],
        );
      },
    );
  }

  void _showForm(
      BuildContext context, String action, Map<String, dynamic>? data) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Addsport(
          ip: widget.ip,
          endpoint:
              'sport', // Modifica l'endpoint a 'sport' per aggiungere uno sport
          data: data,
        ),
      ),
    );
  }
}

class DataViewScreen extends StatelessWidget {
  final String ip;
  final String endpoint;
  final Future<List<dynamic>> Function(String) fetchData;

  DataViewScreen({
    required this.ip,
    required this.endpoint,
    required this.fetchData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dati $endpoint'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchData(endpoint),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data found'));
          } else {
            return ListView(
              children: snapshot.data!.map((item) {
                return GestureDetector(
                  onTap: () => _showOptionsDialog(context, item),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(item.toString()),
                    ),
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _goToAdd(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _goToAdd(BuildContext context) {
    print(endpoint);
    switch (endpoint) {
      case "readSport":
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Addsport(ip: ip, endpoint: endpoint);
        }));
        break;
      case "readArticolo":
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Addarticolo(ip: ip, endpoint: endpoint);
        }));
        break;
      case "readClinte":
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Addcliente(ip: ip, endpoint: endpoint);
        }));
        break;
      case "readNegozio":
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Addnegozio(ip: ip, endpoint: endpoint);
        }));
        break;
    }
  }

  void _showOptionsDialog(BuildContext context, dynamic item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Opzioni'),
          content: const Text('Scegli un\'azione:'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _goToChange(context, item);
              },
              child: const Text('Modifica'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _goToDelete(context, item);
              },
              child: const Text('Elimina'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annulla'),
            ),
          ],
        );
      },
    );
  }

  void _goToChange(BuildContext context, dynamic item) {
    // Logica per navigare alla schermata di modifica
    print('Modifica: $item');
    print(endpoint);
    switch (endpoint) {
      case "readSport":
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Changesport(ip: ip, endpoint: endpoint);
        }));
        break;
      case "readArticolo":
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Changearticolo(ip: ip, endpoint: endpoint);
        }));
        break;
      case "readClinte":
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Changecliente(ip: ip, endpoint: endpoint);
        }));
        break;
      case "readNegozio":
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Changenegozio(ip: ip, endpoint: endpoint);
        }));
        break;
    }
  }

  void _goToDelete(BuildContext context, dynamic item) {
    // Logica per eseguire l'azione di eliminazione
    print(endpoint);
    switch (endpoint) {
      case "readSport":
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Cancellasport(ip: ip, endpoint: endpoint);
        }));
        break;
      case "readArticolo":
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Cancellaarticolo(ip: ip, endpoint: endpoint);
        }));
        break;
      case "readClinte":
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Cancellacliente(ip: ip, endpoint: endpoint);
        }));
        break;
      case "readNegozio":
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Cancellanegozio(ip: ip, endpoint: endpoint);
        }));
        break;
    }
    // Implementa la logica di eliminazione qui
    // Ad esempio, potresti chiamare un'API per eliminare l'elemento
  }
}
