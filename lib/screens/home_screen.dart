import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'crear_nota_screen.dart';

class HomeScreen extends StatefulWidget {
  final String accessToken;
  const HomeScreen({super.key, required this.accessToken});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Map<String, dynamic>>> _notasFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _notasFuture = _apiService.getNotas(widget.accessToken); // corregido: widget con minúscula
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Notas')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _notasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay notas'));
          }

          final notas = snapshot.data!;
          return ListView.builder(
            itemCount: notas.length,
            itemBuilder: (context, index) {
              final nota = notas[index];
              return Card(
                child: ListTile(
                  title: Text(nota['titulo'] ?? 'Sin título'),
                  subtitle: Text(nota['contenido'] ?? ''),
                  trailing: Text(nota['fecha']?.split('T')[0] ?? ''),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CrearNotaScreen(accessToken: widget.accessToken),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}