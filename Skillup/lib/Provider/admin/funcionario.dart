import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillup/Constrain/url.dart';
import 'package:http/http.dart' as http;
import 'package:skillup/Model/colaborador/funcedit.dart';
import 'package:skillup/Model/funcionario.dart';
import 'package:skillup/Model/funcionariolistmodel.dart';

class FuncionarioProvider with ChangeNotifier {
  bool _cadastrado = false;
  bool get cadastrado => _cadastrado;

  bool _carregando = false;
  bool get carregando => _carregando;

  String _menssagem = "";
  String get menssagem => _menssagem;

  List<FuncionarioList> _funcionarios = [];
  List<FuncionarioList> get funcionarios => _funcionarios;

  String? token;

  // Método para pegar o token do SharedPreferences
  Future<void> pegarToken() async {
    var dados = await SharedPreferences.getInstance();
    token = dados.getString("token");
  }

  // Método para cadastrar o funcionário
  Future<void> cadastrarFuncionario(Funcionario funcionario) async {
    final url = '${AppUrl.baseUrl}api/Usuario/Criar';

    try {
      await pegarToken();
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(funcionario.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _cadastrado = true;
        _carregando = false;
        _menssagem = "Funcionário cadastrado com sucesso!";
      } else {
        _cadastrado = false;
        _carregando = false;
        _menssagem = "Erro ao cadastrar funcionário: ${response.body}";
      }
    } catch (error) {
      _cadastrado = false;
      _carregando = false;
      _menssagem = "Erro de servidor ou dados incorretos: $error";
    }

    notifyListeners();
  }

//Listar funcionários
  Future<void> listarFuncionarios() async {
    final url = '${AppUrl.baseUrl}api/Usuario';
    _carregando = true;
    notifyListeners();

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
        _funcionarios =
            data.map((json) => FuncionarioList.fromJson(json)).toList();
        _menssagem = "Funcionários carregados com sucesso!";

        _carregando = false;
        notifyListeners();
      } else {
        _menssagem = "Erro ao carregar funcionários!";
      }
    } catch (error) {
      _menssagem = "Erro ao carregar dados do servidor: $error";
    }
  }

  Future<void> atualizarFuncionario(FuncionarioEdit funcionario) async {
    final url = '${AppUrl.baseUrl}api/Usuario/${funcionario.id}';

    try {
      await pegarToken();

      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(funcionario.toJson()),
      );

      
      if (response.statusCode == 200 || response.statusCode == 204) {
        _menssagem = 'Funcionário atualizado com sucesso!';
        await listarFuncionarios();
      } else {
        _menssagem = 'Erro ao atualizar funcionário: ${response.body}';
      }
    } catch (error) {
      _menssagem = 'Erro ao atualizar funcionário: $error';
    }

    notifyListeners();
  }

  Future<void> deletarFuncionario(String id) async {
    final url = Uri.parse('${AppUrl.baseUrl}api/Usuario/$id');

    try {
      final response = await http.delete(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200 || response.statusCode == 204) {
        _menssagem = 'Funcionario Deletado com com Sucesso';
        listarFuncionarios();
        notifyListeners();
      } else {
        _menssagem = 'Erro ao deletar Funcionario';
        notifyListeners();
      }
    } catch (error) {
      _menssagem = 'Erro de conexão como servidor!';
      notifyListeners();
    }
  }
}
