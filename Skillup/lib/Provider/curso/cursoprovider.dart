import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillup/Constrain/url.dart';
import 'package:http/http.dart' as http;
import 'package:skillup/Model/curso.dart';
import 'package:skillup/Model/cursoassociado.dart';

class CursoProvider with ChangeNotifier {
  bool _cadastrado = false;
  bool get cadastrado => _cadastrado;

  bool _carregando = false;
  bool get carregando => _carregando;

  String _menssagem = "";
  String get menssagem => _menssagem;

  List<Curso> _cursos = [];
  List<Curso> get cursos => _cursos;

  String? token;

  List<CursoAssociado> _cursosAssociados = [];
  List<CursoAssociado> get cursosAssociados => _cursosAssociados;

  // Pegar token
  Future<void> pegarToken() async {
    var dados = await SharedPreferences.getInstance();
    token = dados.getString("token");
  }

  // Cadastrar curso
  Future<void> cadastrarCurso(Curso curso) async {
    final url = '${AppUrl.baseUrl}api/Curso';
    try {
      await pegarToken();
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(curso.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _cadastrado = true;
        _carregando = false;
        await listarCursos();
        _menssagem = "Curso cadastrado com sucesso!";
        notifyListeners();
      } else {
        _cadastrado = false;
        _carregando = false;
        _menssagem = "Erro ao cadastrar curso!";
        notifyListeners();
      }
    } catch (error) {
      _cadastrado = false;
      _carregando = false;
      _menssagem = "Erro de conexão ou dados incorretos: $error";
      notifyListeners();
    }
  }

  // Listar cursos
  Future<void> listarCursos() async {
    final url = '${AppUrl.baseUrl}api/Curso';
    try {
      await pegarToken();
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _cursos = data.map((json) => Curso.fromJson(json)).toList();
        _carregando = false;
        notifyListeners();
      } else {
        _carregando = false;
        notifyListeners();
      }
    } catch (error) {
      _cadastrado = false;
      _carregando = false;
      _menssagem = "Erro ao carregar dados do servidor.";
      notifyListeners();
    }
  }

  // Atualizar curso
  Future<void> atualizarCurso(Curso curso) async {
    try {
      final response = await http.put(
        Uri.parse('${AppUrl.baseUrl}api/Curso/${curso.cursoId}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(curso.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        _menssagem = 'Curso atualizado com sucesso!';
        listarCursos();
        notifyListeners();
      } else {
        _menssagem = 'Erro ao atualizar curso!';
        notifyListeners();
      }
    } catch (error) {
      _menssagem = 'Erro ao conectar com o servidor!';
      notifyListeners();
    }
  }

  // Deletar curso
  Future<void> deletarCurso(int id) async {
    final url = Uri.parse('${AppUrl.baseUrl}api/Curso/$id');
    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        _menssagem = 'Curso deletado com sucesso!';
        listarCursos();
        notifyListeners();
      } else {
        _menssagem = 'Erro ao deletar curso!';
        notifyListeners();
      }
    } catch (error) {
      _menssagem = 'Erro de conexão com o servidor!';
      notifyListeners();
    }
  }

  // Associar curso a funcionário
  Future<void> associarFuncionarioCurso(
      String funcionarioId, int cursoId, DateTime dataValidade) async {
    final url = '${AppUrl.baseUrl}api/FuncionarioCurso';
    final dataFormatada = DateFormat('yyyy-MM-dd').format(dataValidade);

    final data = {
      "funcCursoId": 0,
      "funcionarioId": funcionarioId,
      "cursoId": cursoId,
      "dataValidade": dataFormatada,
    };

    try {
      await pegarToken();
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _menssagem = "Curso associado com sucesso!";
        listarCursosFuncionario(funcionarioId);
        notifyListeners();
      } else {
        _menssagem = "Erro ao associar curso.";
        notifyListeners();
      }
    } catch (error) {
      _menssagem = "Erro ao conectar ao servidor: $error";
      notifyListeners();
    }
  }

  // Listar cursos associados ao funcionário
  Future<void> listarCursosFuncionario(String funcionarioId) async {
    final url = '${AppUrl.baseUrl}api/FuncionarioCurso/Funcionario/$funcionarioId';

    try {
      await pegarToken();
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _cursosAssociados =
            data.map((json) => CursoAssociado.fromJson(json)).toList();
        _carregando = false;
        notifyListeners();
      } else {
        _carregando = false;
        notifyListeners();
      }
    } catch (error) {
      _carregando = false;
      _menssagem = "Erro ao carregar cursos associados.";
      notifyListeners();
    }
  }

  Future<void> dissociarFuncionarioCurso(String funcionarioId, int cursoId) async {
  final url = '${AppUrl.baseUrl}api/FuncionarioCurso?idCurso=$cursoId&idFunc=$funcionarioId';

  try {
    await pegarToken();
    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      _menssagem = 'Curso dissociado com sucesso!';
      listarCursosFuncionario(funcionarioId);
      notifyListeners();
    } else {
      _menssagem = 'Erro ao dissociar curso.';
      notifyListeners();
    }
  } catch (error) {
    _menssagem = 'Erro de conexão com o servidor: $error';
    notifyListeners();
  }
}
  
}
