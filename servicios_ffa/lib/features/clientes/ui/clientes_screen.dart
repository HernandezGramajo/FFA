import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ClientesScreen extends StatelessWidget {
  const ClientesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Clientes'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/'); // O la ruta principal que desees
            }
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Editar Información del Cliente'),
            onTap: () {
              // Aquí irá el navigation más adelante
            },
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Crear Nuevo Cliente'),
            onTap: () => context.push('/crearcliente'),
          ),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text('Dirección Fiscal'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.contacts),
            title: const Text('Múltiples Contactos por Cliente'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.store),
            title: const Text('Múltiples Contactos por Sucursal'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Ubicación'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.gps_fixed),
            title: const Text('Geolocalización'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Fotografía'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Información de Pagos'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
