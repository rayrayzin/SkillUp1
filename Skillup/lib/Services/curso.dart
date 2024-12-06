import 'package:http/http.dart' as http;
import 'package:skillup/Model/funcionariocurso.dart';
import 'dart:convert';
import 'package:skillup/Model/curso.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillup/Constrain/url.dart';

class ApiService {
  int? id;
  String? token;

  Future<List<FuncionarioCurso>> buscarCursos() async {
    var dados = await SharedPreferences.getInstance();
    id = dados.getInt("id");
    token = dados.getString("token");

    final response = await http.get(
      Uri.parse('${AppUrl.baseUrl}api/Funcionario/Curso?id=$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => FuncionarioCurso.fromJson(data)).toList();
    } else {
      throw Exception('Falha ao carregar dados');
    }
  }

  Future<Curso> detalhesEpi(int idCurso) async {
    final response = await http.get(
      Uri.parse('${AppUrl.baseUrl}api/Curso/$idCurso'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return Curso.fromJson(json.decode(response.body));
    } else {
      throw Exception('Falha ao carregar detalhes do Curso');
    }
  }
}
