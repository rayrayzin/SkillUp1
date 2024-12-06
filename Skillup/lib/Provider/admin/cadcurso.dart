import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:skillup/Constrain/url.dart';
import 'package:skillup/Utils/mensage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CadCursoProvider with ChangeNotifier {
  
  bool _carregando = false;
  bool get carregando => _carregando;

  Future cadastrar(
    BuildContext context,
    String nome,
    String descricao,
    int orgaoEmissorId,
  ) async {
    var dados = await SharedPreferences.getInstance();
    String? token = dados.getString("token");

    String url = '${AppUrl.baseUrl}api/Curso';

    _carregando = false;
    notifyListeners();

  
    Map<String, dynamic> requestBody = {
      "cursoId": 0,
      "nome": nome,
      "observacao": descricao,
      "orgaoEmissorId": orgaoEmissorId,
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(requestBody),
    );

    _carregando = false;
    notifyListeners();

    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint("certo");
      showMessage(
          message: 'Curso cadastrado com sucesso!',
          // ignore: use_build_context_synchronously
          context: context);
    } else {
      debugPrint(response.body);
      showMessage(
          message: 'Erro ao cadastrar Curso!',
          // ignore: use_build_context_synchronously
          context: context);
    }
  }
}