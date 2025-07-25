import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';

class CrearNotaScreen extends StatefulWidget {
  const CrearNotaScreen({super.key});

  @override
  State<CrearNotaScreen> createState() => _CrearNotaScreenState();
}

class _CrearNotaScreenState extends State<CrearNotaScreen> {
  final _tituloController = TextEditingController();
  final _contenidoController = TextEditingController();
  DateTime? _fechaRecordatorio;
  final _apiService = ApiService();

  Future<void> _seleccionarFecha(BuildContext context) async {
    final DateTime? fecha = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2101),
    );

    if (fecha != null) {
      final TimeOfDay? hora = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (hora != null) {
        setState(() {
          _fechaRecordatorio = DateTime(
            fecha.year,
            fecha.month,
            fecha.day,
            hora.hour,
            hora.minute,
          );
        });
      }
    }
  }

  Future<void> _guardarNota() async {
    final titulo = _tituloController.text.trim();
    final contenido = _contenidoController.text.trim();

    if (titulo.isEmpty || contenido.isEmpty || _fechaRecordatorio == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Todos los campos son obligatorios')),
      );
      return;
    }

    try {
      await _apiService.crearNota(titulo, contenido, _fechaRecordatorio!);
      Navigator.pop(context); // Vuelve a la pantalla anterior
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear nota: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Nota')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: _contenidoController,
              decoration: const InputDecoration(labelText: 'Contenido'),
              maxLines: 5,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(_fechaRecordatorio == null
                      ? 'Sin recordatorio'
                      : 'Recordatorio: ${DateFormat('yyyy-MM-dd HH:mm').format(_fechaRecordatorio!)}'),
                ),
                TextButton(
                  onPressed: () => _seleccionarFecha(context),
                  child: const Text('Elegir Recordatorio'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _guardarNota,
              child: const Text('Guardar Nota'),
            ),
          ],
        ),
      ),
    );
  }
}