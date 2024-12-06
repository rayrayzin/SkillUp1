import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillup/Constrain/url.dart';
import 'package:skillup/Model/funccursooff.dart';

class UsuarioService {
  // Método para buscar usuários da API
  Future<List<Usuario>> fetchUsuarios() async {
    try {
      var prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      if (token == null) {
        throw Exception('Token não encontrado');
      }

      final response = await http.get(
        Uri.parse('${AppUrl.baseUrl}api/Usuario'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body) ?? [];
        return data.map((json) => Usuario.fromJson(json)).toList();
      } else {
        throw Exception('Erro ao carregar os usuários: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro na requisição de usuários: $e');
    }
  }

  // Método para buscar cursos de um usuário
  Future<List<Curso>> fetchCursos(String userId) async {
    try {
      var prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      if (token == null) {
        throw Exception('Token não encontrado');
      }

      final response = await http.get(
        Uri.parse('${AppUrl.baseUrl}api/FuncionarioCurso/Funcionario/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body) ?? [];
        return data.map((json) => Curso.fromJson(json)).toList();
      } else {
        return []; 
      }
    } catch (e) {
      return []; 
    }
  }

  Future<void> salvarUsuariosComCursos() async {
    try {
      List<Usuario> usuarios = await fetchUsuarios();
      List<UsuarioComCursos> usuariosComCursos = [];

      for (Usuario usuario in usuarios) {
        List<Curso> cursos = await fetchCursos(usuario.id);
        usuariosComCursos.add(UsuarioComCursos(usuario: usuario, cursos: cursos));
      }
 
      var prefs = await SharedPreferences.getInstance();
      final jsonData = usuariosComCursos.map((e) => e.toJson()).toList();
      await prefs.setString('usuariosComCursos', json.encode(jsonData));
   
    } catch (e) {
      throw Exception('Erro ao salvar os dados: $e');
    }
  }

  Future<List<UsuarioComCursos>> carregarUsuariosComCursos() async {
    try {
      var prefs = await SharedPreferences.getInstance();
      String? jsonString = prefs.getString('usuarios_com_cursos');

      if (jsonString != null) {
        List<dynamic> jsonData = json.decode(jsonString);
        return jsonData
            .map((data) => UsuarioComCursos.fromJson(data))
            .toList();
      } else {
        print('Nenhum dado encontrado.');
        return [];
      }
    } catch (e) {
      throw Exception('Erro ao carregar os dados: $e');
    }
  }
}