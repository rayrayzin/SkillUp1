import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:skillup/Constrain/url.dart';

class ValidarSenha extends ChangeNotifier {
  bool _valido = false;
  String _msgError = '';
  String _msgErrorApi = '';
  bool _carregando = false;

  bool get valido => _valido;
  String get msgError => _msgError;
  String get msgErrorApi => _msgErrorApi;
  bool get carregando => _carregando;

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

//Criar usuário
  Future createUser(String nome, String cpf, String password, String email, String telefone, String tipo) async {
    String url = '${AppUrl.baseUrl}api/Usuario/Criar';

    Map<String, dynamic> requestBody = {
      'nome' : nome,
      "cpf": cpf,
      "password": password,
      "email": email,
      "telefone": telefone,
      "tipo": tipo
    };

    _carregando = true;
    notifyListeners();

    http.Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(requestBody),
    );
   print("requição ok");
    if (response.statusCode == 200 || response.statusCode == 201) {
      _valido = true;
      _carregando = false;
      _msgErrorApi = "Usuário Cadastrado com sucesso";
      notifyListeners();
    } else {
      _carregando = false;
      _msgErrorApi = response.body;
      notifyListeners();
    }
  }
}