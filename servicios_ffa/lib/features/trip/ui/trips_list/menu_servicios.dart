import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart'; // Importante para signOut
import 'package:go_router/go_router.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Microservices Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await Amplify.Auth.signOut();
      // Redirige al login (o a pantalla de inicio)
      
      Navigator.of(context).pushReplacementNamed('/login');
    } catch (e) {
      print(' Error al cerrar sesión: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cerrar sesión')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Microservicios'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _DashboardButton(
              label: 'Gestión de Clientes',
              icon: Icons.person,
              onPressed: () => context.push('/clientes'),
              
            ),
            _DashboardButton(
              label: 'Gestión de Pedidos',
              icon: Icons.shopping_cart,
              onPressed: () => context.push('/pedidos'),
            ),
            _DashboardButton(
              label: 'Comentarios',
              icon: Icons.comment,
              onPressed: () => _navigateTo(context, const ComentariosScreen()),
            ),
            _DashboardButton(
              label: 'Recordatorios',
              icon: Icons.alarm,
              onPressed: () => _navigateTo(context, const RecordatoriosScreen()),
            ),
            _DashboardButton(
              label: 'Geolocalización',
              icon: Icons.location_on,
              onPressed: () => _navigateTo(context, const GeolocalizacionScreen()),
            ),
            _DashboardButton(
              label: 'Fotografías',
              icon: Icons.photo_camera,
              onPressed: () => _navigateTo(context, const FotografiasScreen()),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _DashboardButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(label),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onPressed,
      ),
    );
  }
}


class PedidosScreen extends StatelessWidget {
  const PedidosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildPlaceholderScreen(context, 'Gestión de Pedidos');
  }
}

class ComentariosScreen extends StatelessWidget {
  const ComentariosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildPlaceholderScreen(context, 'Comentarios');
  }
}

class RecordatoriosScreen extends StatelessWidget {
  const RecordatoriosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildPlaceholderScreen(context, 'Recordatorios');
  }
}

class GeolocalizacionScreen extends StatelessWidget {
  const GeolocalizacionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildPlaceholderScreen(context, 'Geolocalización');
  }
}

class FotografiasScreen extends StatelessWidget {
  const FotografiasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildPlaceholderScreen(context, 'Fotografías');
  }
}

// Widget reutilizable para pantalla placeholder
Widget _buildPlaceholderScreen(BuildContext context, String title) {
  return Scaffold(
    appBar: AppBar(
      title: Text(title),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ),
    ),
    body: Center(
      child: Text(
        'Aquí va la pantalla de $title',
        style: const TextStyle(fontSize: 20),
      ),
    ),
  );
}
