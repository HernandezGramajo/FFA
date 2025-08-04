import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Pedidos extends StatefulWidget {
  @override
  _PedidosState createState() => _PedidosState();
}

class _PedidosState extends State<Pedidos> {
  List<dynamic> clientes = [];
  dynamic clienteSeleccionado;

  bool cargando = true;
  String? error;

  @override
  void initState() {
    super.initState();
    obtenerClientes();
  }

  Future<void> obtenerClientes() async {
    final url = Uri.parse('https://3p0sm23xj5.execute-api.us-east-1.amazonaws.com/listar_clientes');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          clientes = data['clientes'];
          cargando = false;
          if (clientes.isNotEmpty) clienteSeleccionado = clientes[0];
        });
      } else {
        setState(() {
          error = 'Error en el servidor: ${response.statusCode}';
          cargando = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error: $e';
        cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecciona un cliente'),
      ),
      body: Center(
        child: cargando
            ? CircularProgressIndicator()
            : error != null
                ? Text(error!)
                : DropdownButton<dynamic>(
                    value: clienteSeleccionado,
                    items: clientes.map<DropdownMenuItem<dynamic>>((cliente) {
                      return DropdownMenuItem<dynamic>(
                        value: cliente,
                        child: Text(cliente['nombre']),
                      );
                    }).toList(),
                    onChanged: (nuevoCliente) {
                      setState(() {
                        clienteSeleccionado = nuevoCliente;
                      });
                    },
                  ),
      ),
    );
  }
}
