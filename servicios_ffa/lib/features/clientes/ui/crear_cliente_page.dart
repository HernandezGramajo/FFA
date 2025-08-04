import 'package:flutter/material.dart';

class CrearClientePage extends StatefulWidget {
  const CrearClientePage({super.key});

  @override
  State<CrearClientePage> createState() => _CrearClientePageState();
}

class _CrearClientePageState extends State<CrearClientePage> {
  final _formKey = GlobalKey<FormState>();

  String nombre = '';
  String correo = '';
  String telefono = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Nuevo Cliente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nombre completo'),
                onSaved: (value) => nombre = value ?? '',
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Ingrese el nombre' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Correo electrónico'),
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) => correo = value ?? '',
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Ingrese el correo' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Teléfono'),
                keyboardType: TextInputType.phone,
                onSaved: (value) => telefono = value ?? '',
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Ingrese el teléfono' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  final form = _formKey.currentState;
                  if (form != null && form.validate()) {
                    form.save();

                    // Aquí conectaremos con el backend o base de datos luego
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Cliente creado')),
                    );

                    Navigator.pop(context);
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
