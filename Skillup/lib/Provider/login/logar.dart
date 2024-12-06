import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:skillup/Constrain/url.dart';
import 'package:skillup/Data/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io'; // Para lidar com erros de conexão

class Logar with ChangeNotifier {
  bool _valido = false;
  bool _logado = false;
  String _msgError = '';
  bool _carregando = false;
  String _rota = "";
  Map<String, dynamic> _dadosUser = {};

  bool get ehvalido => _valido;
  bool get logado => _logado;
  String get msgError => _msgError;
  bool get carregando => _carregando;
  String get rota => _rota;
  Map<String, dynamic> get dadosUser => _dadosUser;

  void validatePassword(String password) {
    _msgError = '';
    if (password.length < 8) {
      _msgError = 'Mínimo 8 dígitos';
    } else if (!password.contains(RegExp(r'[a-z]'))) {
      _msgError = 'Pelo menos uma letra minúscula';
    } else if (!password.contains(RegExp(r'[A-Z]'))) {
      _msgError = 'Pelo menos uma letra maiúscula';
    } else if (!password
        .contains(RegExp(r'[!@#$%^&*()_+\-=\[\]{};:\|,.<>\/?]'))) {
      _msgError = 'Pelo menos um carácter especial';
    } else if (!password.contains(RegExp(r'[0-9]'))) {
      _msgError = 'Pelo menos um número';
    }
    _valido = _msgError.isEmpty;
    notifyListeners();
  }

  // Logar usuário
  Future logarUsuario(String cpf, String password) async {
    _carregando = true;
    _msgError = ''; // Limpa mensagens anteriores
    notifyListeners();

    cpf  = cpf.replaceAll(RegExp(r'[^0-9]'), '');

    String url = '${AppUrl.baseUrl}api/Usuario/Login';

    Map<String, dynamic> requestBody = {
      'password': password,
      'cpf': cpf,
    };

    try {
      http.Response response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBody),
      );

      _carregando = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map dados = jsonDecode(response.body);

        // Gravar dados do usuário
        SharedPreferences idUser = await SharedPreferences.getInstance();
        var ds = GetId(idUser);
        await ds.gravarId(dados['id']);
        await ds.gravarToken(dados['token']);
        await ds.gravarNivel(dados['roles'][0]);
        await dadosUsuario(dados['id']);

        if (dados['roles'][0] == "Basic") {
          _rota = "/MainColaborador";
        } else {
          _rota = "/MainAdmin";
        }
        _logado = true;
        _msgError = ''; // Limpa mensagem de erro após sucesso
        notifyListeners();
      } else if (response.statusCode == 400) {
        _logado = false;
        _msgError = 'CPF ou senha incorretos'; // Mensagem específica
        notifyListeners();
      } else {
        _logado = false;
        _msgError = 'Erro ao realizar login. Tente novamente.';
        notifyListeners();
      }
    } on SocketException {
      _carregando = false;
      _logado = false;
      _msgError = 'Erro de conexão. Verifique sua internet.';
      notifyListeners();
    } catch (e) {
      _carregando = false;
      _logado = false;
      _msgError = 'Erro inesperado. Tente novamente.';
      notifyListeners();
    }
  }

  Future dadosUsuario(String id) async {
    _carregando = true;
    notifyListeners();

    try {
      String url = '${AppUrl.baseUrl}api/Usuario/$id';

      http.Response response = await http.get(Uri.parse(url));

      if (response.statusCode == 200 || response.statusCode == 405) {
        _dadosUser = jsonDecode(response.body);
        _carregando = false;
        notifyListeners();
      } else {
        _carregando = false;
        _msgError = 'Erro ao carregar dados do usuário.';
        notifyListeners();
      }
    } catch (e) {
      _carregando = false;
      _msgError = 'Erro de conexão ao buscar dados do usuário.';
      notifyListeners();
    }
  }
}
