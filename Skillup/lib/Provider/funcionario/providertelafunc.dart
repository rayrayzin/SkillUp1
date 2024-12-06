import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillup/Model/colaborador/cursocolabmodel.dart';
import 'package:skillup/Model/colaborador/valdiade.dart';
import 'package:skillup/Constrain/url.dart';

class FuncionarioCursoProviderTela with ChangeNotifier {
  List<CursoModel> cursos = [];
  CursoValidadeModel? validadeCurso;
  String? token;

  // Método para pegar o token
  Future<void> pegarToken() async {
    var dados = await SharedPreferences.getInstance();
    token = dados.getString("token");
  }

  // Busca os cursos do funcionário com tratamento de erros
  Future<void> fetchCursos(String funcionarioId) async {
    try {
      await pegarToken();
      final response = await http.get(Uri.parse("${AppUrl.baseUrl}api/FuncionarioCurso/Funcionario/$funcionarioId"));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        cursos = data.map((curso) => CursoModel.fromJson(curso)).toList();
        notifyListeners();
      } else {
        throw Exception("Erro ao buscar cursos");
      }
    } catch (e) {
      rethrow; // Repassa o erro para ser tratado na interface
    }
  }

  // Busca a validade de um curso específico com tratamento de erros
  Future<void> fetchValidadeCurso(int cursoId) async {
    try {
      await pegarToken();
      final response = await http.get(Uri.parse("${AppUrl.baseUrl}api/FuncionarioCurso/$cursoId"),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        validadeCurso = CursoValidadeModel.fromJson(data);
        notifyListeners();
      } else {
        throw Exception("Erro ao buscar validade do curso");
      }
    } catch (e) {
      rethrow; // Repassa o erro para ser tratado na interface
    }
  }
}