import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:servicios_ffa/helpers/geolocalizacion_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CrearCliente extends StatefulWidget {
  const CrearCliente({super.key});

  @override
  State<CrearCliente> createState() => _CrearClienteState();
}

class _CrearClienteState extends State<CrearCliente> {
  final _formKey = GlobalKey<FormState>();




  // Controladores de campos
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController generoController = TextEditingController();
  final TextEditingController edadController = TextEditingController();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController sucursalController = TextEditingController();
  final List<TextEditingController> telefonos = [TextEditingController()];
  final List<TextEditingController> direcciones = [TextEditingController()];
  final TextEditingController inicioHoraController = TextEditingController();
  final TextEditingController finHoraController = TextEditingController();
  final TextEditingController repetirCadaController = TextEditingController();
  final TextEditingController formaPagoController = TextEditingController();
  final TextEditingController diaCobroController = TextEditingController();
  final TextEditingController nitController = TextEditingController();


 final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _edadController = TextEditingController();
  final TextEditingController _sucursalController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _frecuenciaController = TextEditingController();
  final TextEditingController _nitController = TextEditingController();

  String? _genero;
  String? _formaPago;
  TimeOfDay? _horaInicio;
  TimeOfDay? _horaFin;
  DateTime? _diaCobro;
  List<String> _diasVisita = [];
  File? fotoReferencia;
  File? fotoDpiFrente;
  File? fotoDpiAtras;

  final picker = ImagePicker();
  final List<String> _generos = ['Masculino', 'Femenino', 'Otro'];
  final List<String> _formasPago = ['Contado', 'Crédito', 'Transferencia', 'Tarjeta'];
  final List<String> _opcionesDias = [
    'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo', 'Todos los días'
  ];

Future<void> _selectHoraInicio() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => _horaInicio = picked);
  }

  Future<void> _selectHoraFin() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => _horaFin = picked);
  }

  Future<void> _tomarFoto(Function(File) setFoto) async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        setFoto(File(pickedFile.path));
      });
    }
  }

String _ubicacionTexto = 'Ubicación no establecida';

  void _obtenerUbicacion() async {
    final posicion = await GeolocalizacionHelper.obtenerUbicacionActual(context);
    if (posicion != null) {
      setState(() {
        _ubicacionTexto = 'Lat: ${posicion.latitude}, Lng: ${posicion.longitude}';
      });
    } else {
      setState(() {
        _ubicacionTexto = 'No se pudo obtener la ubicación';
      });
    }
  }

  @override
  void dispose() {
    // Limpiar controladores
    nombreController.dispose();
    generoController.dispose();
    edadController.dispose();
    correoController.dispose();
    sucursalController.dispose();
    telefonos.forEach((c) => c.dispose());
    direcciones.forEach((c) => c.dispose());
    inicioHoraController.dispose();
    finHoraController.dispose();
    repetirCadaController.dispose();
    formaPagoController.dispose();
    diaCobroController.dispose();
    nitController.dispose();
    super.dispose();
  }

  
  Future<void> _selectDiaCobro() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _diaCobro = picked);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Cliente')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Datos del Cliente', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre Cliente'),
                validator: (value) => value == null || value.isEmpty ? 'Campo obligatorio' : null,
              ),
              DropdownButtonFormField<String>(
                value: _genero,
                decoration: const InputDecoration(labelText: 'Género'),
                items: _generos.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                onChanged: (value) => setState(() => _genero = value),
              ),
              TextFormField(
                controller: _edadController,
                decoration: const InputDecoration(labelText: 'Edad'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _correoController,
                decoration: const InputDecoration(labelText: 'Correo'),
                keyboardType: TextInputType.emailAddress,
                
              ),
              TextFormField(controller: sucursalController, decoration: const InputDecoration(labelText: 'Nombre Sucursal')),

              const SizedBox(height: 16),
              const Text('Teléfonos'),
              ...telefonos.map((controller) => TextFormField(controller: controller, decoration: const InputDecoration(labelText: 'Teléfono'), keyboardType: TextInputType.number,)),
              TextButton.icon(
                onPressed: () => setState(() => telefonos.add(TextEditingController())),
                icon: const Icon(Icons.add),
                label: const Text('Agregar Teléfono'),
              ),

              const SizedBox(height: 16),
              const Text('Direcciones (Primera por defecto)'),
              ...direcciones.map((controller) => TextFormField(controller: controller, decoration: const InputDecoration(labelText: 'Dirección'))),
              TextButton.icon(
                onPressed: () => setState(() => direcciones.add(TextEditingController())),
                icon: const Icon(Icons.add),
                label: const Text('Agregar Dirección'),
              ),

              const SizedBox(height: 16),
               ElevatedButton.icon(
              onPressed: _obtenerUbicacion,
              icon: const Icon(Icons.gps_fixed),
              label: const Text('Ingresar Geolocalización'),
            ),
            const SizedBox(height: 20),
            Text(
              _ubicacionTexto,
              style: const TextStyle(fontSize: 16),
            ),

               const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _selectHoraInicio,
                child: Text(_horaInicio == null
                    ? 'Seleccionar hora inicio'
                    : 'Hora inicio: ${_horaInicio!.format(context)}'),
              ),
              ElevatedButton(
                onPressed: _selectHoraFin,
                child: Text(_horaFin == null
                    ? 'Seleccionar hora fin'
                    : 'Hora fin: ${_horaFin!.format(context)}'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _diasVisita.isNotEmpty ? _diasVisita.first : null,
                decoration: const InputDecoration(labelText: 'Días de visita'),
                items: _opcionesDias
                    .map((dia) => DropdownMenuItem(value: dia, child: Text(dia)))
                    .toList(),
                onChanged: (value) => setState(() => _diasVisita = value == null ? [] : [value]),
              ),
              const SizedBox(height: 24),
              const Text('Fotografías', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
               ElevatedButton.icon(
              onPressed: () => _tomarFoto((file) => fotoReferencia = file),
              icon: const Icon(Icons.camera_alt),
              label: const Text('Fotografía de Referencia'),
            ),
            if (fotoReferencia != null)
              Image.file(fotoReferencia!, height: 150),

            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => _tomarFoto((file) => fotoDpiFrente = file),
              icon: const Icon(Icons.credit_card),
              label: const Text('Fotografía de DPI delante'),
            ),
            if (fotoDpiFrente != null)
              Image.file(fotoDpiFrente!, height: 150),

            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => _tomarFoto((file) => fotoDpiAtras = file),
              icon: const Icon(Icons.credit_card),
              label: const Text('Fotografía de DPI atrás'),
            ),
            if (fotoDpiAtras != null)
              Image.file(fotoDpiAtras!, height: 150),
              const SizedBox(height: 24),
              const Text('Información de Pagos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _formaPago,
                decoration: const InputDecoration(labelText: 'Forma de pago'),
                items: _formasPago
                    .map((fp) => DropdownMenuItem(value: fp, child: Text(fp)))
                    .toList(),
                onChanged: (value) => setState(() => _formaPago = value),
              ),
              ElevatedButton(
                onPressed: _selectDiaCobro,
                child: Text(_diaCobro == null
                    ? 'Seleccionar día de cobro'
                    : 'Día de cobro: ${DateFormat.yMMMd().format(_diaCobro!)}'),
              ),
              TextFormField(controller: nitController, decoration: const InputDecoration(labelText: 'NIT')),

              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Procesar datos
                      guardarCliente();
                    }
                  },
                  child: const Text('Guardar Cliente'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }



/// funciones de envio

Future<void> guardarCliente() async {
  const url = 'https://3p0sm23xj5.execute-api.us-east-1.amazonaws.com/crear_clientes';

  // Suponiendo que ya tienes la geolocalización
  final posicion = await GeolocalizacionHelper.obtenerUbicacionActual(context);



  final base64ImageReferencia = fotoReferencia != null    ? await convertirImagenABase64(fotoReferencia!)    : null;
  final base64Image_dpiadelante = fotoDpiFrente != null    ? await convertirImagenABase64(fotoDpiFrente!)    : null;
  final base64Image_dpiatras = fotoDpiAtras != null    ? await convertirImagenABase64(fotoDpiAtras!)    : null;

  
  final Map<String, dynamic> cliente = {
    "nombre": _nombreController.text,
    "genero": _genero,
    "edad": int.tryParse(_edadController.text) ?? 0,
    "correo": _correoController.text,
    "sucursal": sucursalController.text,
    "ubicacion_lat": posicion?.latitude,
    "ubicacion_lng": posicion?.longitude,
    'hora_inicio': _horaInicio != null ? formatoHora24(_horaInicio!) : null,
    'hora_fin': _horaFin != null ? formatoHora24(_horaFin!) : null,
    "dia_cobro": _diaCobro?.toIso8601String().split("T").first,
    "forma_pago": _formaPago,
    "nit": nitController.text,
    "telefonos": telefonos.map((c) => c.text).where((t) => t.isNotEmpty).toList(),
    "direcciones": direcciones.map((c) => c.text).where((d) => d.isNotEmpty).toList(),
    "fotos": [

      {
        'tipo_foto': 'referencia',
        'imagen_base64': base64ImageReferencia,
        'extension': 'jpg' // o png según sea
      },
      {
        'tipo_foto': 'dpi_frente',
        'imagen_base64': base64Image_dpiadelante,
        'extension': 'jpg' // o png según sea
      },
      {
        'tipo_foto': 'dpi_atras',
        'imagen_base64': base64Image_dpiatras,
        'extension': 'jpg' // o png según sea
      },
    ]
  };

  final body = jsonEncode({'body': jsonEncode(cliente)});
  print(body);
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      print('Cliente guardado con éxito');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cliente guardado exitosamente')));
    } else {
      print('Error al guardar: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${response.body}')));
    }
  } catch (e) {
    print('Error en la solicitud: $e');
  }
}

String formatoHora24(TimeOfDay hora) {
  final h = hora.hour.toString().padLeft(2, '0');
  final m = hora.minute.toString().padLeft(2, '0');
  return '$h:$m:00';  // segundos 00 fijo
}

Future<String?> convertirImagenABase64(File imageFile) async {
  final bytes = await imageFile.readAsBytes();
  return base64Encode(bytes);
}

}
