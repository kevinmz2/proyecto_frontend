import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl = url; // Usa la constante desde config.dart

  // Método para obtener las notas del backend
  Future<List<Map<String, dynamic>>> getNotas() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access'); // Token guardado tras login

    final response = await http.get(
      Uri.parse('$baseUrl/api/notas/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => e as Map<String, dynamic>).toList();
    } else {
      throw Exception('Error al obtener notas: ${response.statusCode}');
    }
  }
}