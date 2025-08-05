import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class CrearPedidoScreen extends StatefulWidget {
  @override
  _CrearPedidoScreenState createState() => _CrearPedidoScreenState();
}

class _CrearPedidoScreenState extends State<CrearPedidoScreen> {
  List<dynamic> clientes = [];
  List<dynamic> productos = [];
  List<dynamic> ubicaciones = [];

  String? selectedClienteId;
  String? selectedUbicacion;
  DateTime? selectedDate;

  List<Map<String, dynamic>> productosSeleccionados = [];

  @override
  void initState() {
    super.initState();
    fetchClientes();
    fetchProductos();
  }

  Future<void> fetchClientes() async {
    final res = await http.get(Uri.parse('https://3p0sm23xj5.execute-api.us-east-1.amazonaws.com//listar_clientes'));
    final data = json.decode(res.body); // Solo un decode
    setState(() {
      clientes = data['clientes'];
    });
  }

  Future<void> fetchProductos() async {
  final res = await http.get(Uri.parse('https://3p0sm23xj5.execute-api.us-east-1.amazonaws.com/listar_productos'));

  if (res.statusCode == 200) {
    final data = json.decode(res.body); // Solo un decode

    setState(() {
      productos = data['productos'];
    });
  } else {
    // Manejar error si la respuesta no es 200
    print('Error al obtener productos: ${res.statusCode}');
  }
  }


  Future<void> fetchUbicaciones(String clienteId) async {
    final res = await http.post(
      Uri.parse('https://3p0sm23xj5.execute-api.us-east-1.amazonaws.com/consultar_ubicacion'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'body': jsonEncode({
          'cliente_id': clienteId
        })
      }),
    );
    final data = json.decode(res.body); // Solo un decode
    setState(() {
      ubicaciones = data['ubicacion'];
      selectedUbicacion = null;
    });
  }

  void agregarProducto() {
    setState(() {
      productosSeleccionados.add({
        'codigo_producto': null,
        'cantidad': 1,
      });
    });
  }

  Future<void> enviarPedido() async {
    if (selectedClienteId == null || selectedUbicacion == null || selectedDate == null || productosSeleccionados.any((p) => p['codigo_producto'] == null)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Completa todos los campos.')));
      return;
    }

    final payload = {
      'cliente_id': selectedClienteId,
      'productos': productosSeleccionados,
      'ubicacion': selectedUbicacion,
      'fecha_entrega': DateFormat('yyyy-MM-dd').format(selectedDate!),
    };

    final res = await http.post(
      Uri.parse('https://3p0sm23xj5.execute-api.us-east-1.amazonaws.com/crear_pedido'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'body': jsonEncode(payload)}),
    );
 final body = json.decode(res.body); // Solo un decode
    
    if (res.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(body['mensaje'] ?? 'Pedido enviado')));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(body['error'] ?? 'Error al enviar')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Crear Pedido')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: clientes.isEmpty || productos.isEmpty
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: 'Cliente'),
                      items: clientes.map<DropdownMenuItem<String>>((cliente) {
                        return DropdownMenuItem<String>(
                          value: cliente['id'],
                          child: Text(cliente['nombre']),
                        );
                      }).toList(),
                      value: selectedClienteId,
                      onChanged: (value) {
                        setState(() {
                          selectedClienteId = value;
                          ubicaciones = [];
                          selectedUbicacion = null;
                        });
                        if (value != null) fetchUbicaciones(value);
                      },
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: 'Ubicación de entrega'),
                      items: ubicaciones.map<DropdownMenuItem<String>>((ubic) {
                        return DropdownMenuItem<String>(
                          value: ubic['direccion'],
                          child: Text(ubic['direccion']),
                        );
                      }).toList(),
                      value: selectedUbicacion,
                      onChanged: (value) {
                        setState(() {
                          selectedUbicacion = value;
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    TextButton.icon(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now().add(Duration(days: 1)),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (date != null) {
                          setState(() {
                            selectedDate = date;
                          });
                        }
                      },
                      icon: Icon(Icons.calendar_today),
                      label: Text(selectedDate == null
                          ? 'Seleccionar fecha de entrega'
                          : DateFormat('yyyy-MM-dd').format(selectedDate!)),
                    ),
                    SizedBox(height: 20),
                    Text('Productos', style: TextStyle(fontWeight: FontWeight.bold)),
                    ...productosSeleccionados.map((producto) {
                      int index = productosSeleccionados.indexOf(producto);
                      return Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(labelText: 'Producto'),
                              value: producto['codigo_producto'],
                              items: productos.map<DropdownMenuItem<String>>((prod) {
                                return DropdownMenuItem<String>(
                                  value: prod['codigo_producto'],
                                  child: Text(prod['nombre']),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  productosSeleccionados[index]['codigo_producto'] = value;
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              initialValue: producto['cantidad'].toString(),
                              decoration: InputDecoration(labelText: 'Cantidad'),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  productosSeleccionados[index]['cantidad'] = int.tryParse(value) ?? 1;
                                });
                              },
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                    TextButton.icon(
                      onPressed: agregarProducto,
                      icon: Icon(Icons.add),
                      label: Text('Agregar producto'),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: enviarPedido,
                      child: Text('Enviar pedido'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
