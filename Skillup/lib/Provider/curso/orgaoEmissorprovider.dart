import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillup/Constrain/url.dart';
import 'package:http/http.dart' as http;
import 'package:skillup/Model/orgaoEmissor.dart';


class OrgaoEmissorProvider with ChangeNotifier{
  
  bool _cadastrado = false;
  bool get cadastrado => _cadastrado;

  bool _carregando = false;
  bool get carregando => _carregando;

  String _menssagem = "";
  String get menssagem => _menssagem;

  List<OrgaoEmissor> _orgaoEmissors = [];

  List<OrgaoEmissor> get orgaoEmissores => _orgaoEmissors;

  String? token;

//pegar token
  Future<void> pegarToken() async {
    var dados = await SharedPreferences.getInstance();
    token = dados.getString("token");
  }


//cadastrar
Future<void> cadastrarOrgaoEmissor(OrgaoEmissor orgaoEmissor) async {
     final url = '${AppUrl.baseUrl}api/OrgaoEmissor';
    
    try {
      await pegarToken();
      final response = await http.post(
        Uri.parse(url),
        headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
        body: json.encode(orgaoEmissor.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
         _cadastrado = true;
         _carregando = false;
         _menssagem = "Orgão Emissor Cadastrado com sucesso!";
        notifyListeners();
      } else {
          _cadastrado = false;
         _carregando = false;
         _menssagem = "Erro ao cadastrar Orgão Emissor!";
         notifyListeners();
      }
    } catch (error) {
        _cadastrado = false;
         _carregando = false;
         _menssagem = "Dados Incorretos ou erro de servidor$error";
         notifyListeners();
    }
  }


//listar
  Future<void> listarOrgaoEmissors() async {
      final url = '${AppUrl.baseUrl}api/OrgaoEmissor';
    try {
      await pegarToken();
      final response = await http.get(Uri.parse(url),
       headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _orgaoEmissors = data.map((json) => OrgaoEmissor.fromJson(json)).toList();
        _carregando = false;
        notifyListeners();
      } else {
        _carregando = false;
         notifyListeners();
      }
    } catch (error) {
        _cadastrado = false;
         _carregando = false;
         _menssagem = "Erro ao carregar dos do servidor";
         notifyListeners();
    }
  }


    // Método para atualizar 
  Future<void> atualizarOrgaoEmissor(OrgaoEmissor orgaoEmissor)async {
    try {
      final response = await http.put(
        Uri.parse('${AppUrl.baseUrl}api/OrgaoEmissor/${orgaoEmissor.orgaoEmissorId}'),
         headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },

        body: jsonEncode(orgaoEmissor.toJson()),
      );
      
      if (response.statusCode == 200 || response.statusCode == 204) {
        _menssagem = 'Órgão Emissor atualizado com sucesso!';
        listarOrgaoEmissors();
        notifyListeners();
      } else {
        _menssagem = 'Erro ao atualizar Órgão Emissor!';
        notifyListeners();
      }
    } catch (error) {
      _menssagem = 'Ocorreu algum erro no servidor!';
      notifyListeners();
    }
  }

  // Função para deletar 
  Future<void> deletarOrgaoEmissor(int id) async {
    final url = Uri.parse('${AppUrl.baseUrl}api/OrgaoEmissor/$id');

    try {
      final response = await http.delete(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200 || response.statusCode == 204) {
         _menssagem = 'Órgão Emissor Deletado com com Sucesso';
       listarOrgaoEmissors(); 
        notifyListeners();
      } else {
         _menssagem = 'Erro ao deletar Órgão Emissor';
        notifyListeners();
      }
    } catch (error) {
      _menssagem = 'Erro de conexão como servidor!';
      notifyListeners();
    }
  }

}