import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:skillup/Constrain/url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ApiServiceFuncCurso {
  Future<List<dynamic>> fetchCursos() async {
    var dados = await SharedPreferences.getInstance();
    String? token = dados.getString("token");

    final response =
        await http.get(Uri.parse('${AppUrl.baseUrl}api/Curso'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Falha ao carregar Cursos');
    }
  }

  Future<List<dynamic>> fetchFuncionarios() async {
    var dados = await SharedPreferences.getInstance();
    String? token = dados.getString("token");

    final response =
        await http.get(Uri.parse('${AppUrl.baseUrl}api/Usuario'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Falha ao carregar Funcionario');
    }
  }

  Future<http.Response> cadastrar(
    int id,
    int cursoId,
    String dataValidade,
  ) async {
    var dados = await SharedPreferences.getInstance();
    String? token = dados.getString("token");

    String url = '${AppUrl.baseUrl}api/FuncionarioCurso';
  
    //converter data válidade
    DateFormat formatBrasil = DateFormat("dd/MM/yyyy");
    DateTime dataBrParse = formatBrasil.parse(dataValidade);

    DateFormat formatAmericano = DateFormat("yyyy-MM-dd");
    String dataAmericanaV = formatAmericano.format(dataBrParse);


    Map<String, dynamic> requestBody = {
 
    "funcCursoId": 0,
    "id": String,
    "cursoId": 0,
    "dataValidade": dataAmericanaV
  
    };

  

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(requestBody),
    );

    return response;
  }

// Delete Colaborador
  Future<http.Response> deleteFuncionario(int id) async {
    var dados = await SharedPreferences.getInstance();
    String? token = dados.getString("token");
    final response = await http.delete(headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    }, Uri.parse('${AppUrl.baseUrl}api/Funcionario/$id'));
    return response;
  }

  Future<http.Response> deleteCurso(int cursoId) async {
    var dados = await SharedPreferences.getInstance();
    String? token = dados.getString("token");
    final response = await http.delete(headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    }, Uri.parse('${AppUrl.baseUrl}api//Epi/$cursoId'));
    return response;
  }
}
