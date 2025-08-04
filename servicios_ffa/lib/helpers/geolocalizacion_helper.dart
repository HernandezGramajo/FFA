
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

class GeolocalizacionHelper {
  static Future<Position?> obtenerUbicacionActual(BuildContext context) async {
    bool servicioHabilitado;
    LocationPermission permiso;

    // Verificar si el servicio de ubicación está activo
    servicioHabilitado = await Geolocator.isLocationServiceEnabled();
    if (!servicioHabilitado) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Los servicios de ubicación están deshabilitados.')),
      );
      return null;
    }

    // Verificar permisos
    permiso = await Geolocator.checkPermission();
    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
      if (permiso == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permiso de ubicación denegado.')),
        );
        return null;
      }
    }

    if (permiso == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permiso de ubicación denegado permanentemente.')),
      );
      return null;
    }

    // Obtener ubicación actual
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
}

