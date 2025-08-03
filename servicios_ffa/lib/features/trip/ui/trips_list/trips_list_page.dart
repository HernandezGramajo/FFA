import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart'; // Importante para signOut
import 'package:servicios_ffa/common/utils/colors.dart' as constants;

class TripsListPage extends StatelessWidget {
  const TripsListPage({super.key});

  Future<void> _signOut(BuildContext context) async {
    try {
      await Amplify.Auth.signOut();
      // Redirige al login (o a pantalla de inicio)
      Navigator.of(context).pushReplacementNamed('/login');
    } catch (e) {
      print('❌ Error al cerrar sesión: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cerrar sesión')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Amplify Trips Planner'),
        backgroundColor: const Color(constants.primaryColorDark),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(constants.primaryColorDark),
        child: const Icon(Icons.add),
      ),
      body: const Center(
        child: Text('Trips List'),
      ),
    );
  }
}
