import 'package:flutter/material.dart';

class Client {
  final String id;
  final String name;
  final String fiscalAddress;
  // otros campos...

  Client({required this.id, required this.name, required this.fiscalAddress});
}

class ClientsListPage extends StatelessWidget {
  final List<Client> clients;

  ClientsListPage({required this.clients});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Clientes')),
      body: ListView.builder(
        itemCount: clients.length,
        itemBuilder: (context, index) {
          final client = clients[index];
          return ListTile(
            title: Text(client.name),
            subtitle: Text(client.fiscalAddress),
            onTap: () {
              // Navegar a detalle o editar cliente
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navegar a pantalla creación de cliente
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
