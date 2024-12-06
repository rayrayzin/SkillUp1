import 'package:flutter/material.dart';
import 'package:skillup/Services/funcionariocurso.dart';

class FuncionarioCursoProvider with ChangeNotifier {
  final ApiServiceFuncCurso apiService = ApiServiceFuncCurso();

  List<dynamic> funcionarios = [];
  List<dynamic> cursos = [];
  int? selectedFuncionario;
  String? nomeFuncionario;
  int? selectedCurso;
  String? dataValidade;
  bool carregando = false;
  bool sucesso = false;

  Future<void> fetchFuncionarios() async {
    carregando = true;
    funcionarios = await apiService.fetchFuncionarios();
    carregando = false;
    notifyListeners();
  }

  Future<void> fetchCursos() async {
    carregando = true;
    cursos = await apiService.fetchCursos();
    carregando = false;
    notifyListeners();
  }

  Future<void> criarEntrega() async {
    carregando = true;
    try {
      final response = await apiService.cadastrar(
          selectedFuncionario!, selectedCurso!, dataValidade!);

      if (response.statusCode == 200 || response.statusCode == 201) {
        sucesso = true;
        carregando = false;
        notifyListeners();
      } else {
        sucesso = false;
        notifyListeners();
      }
    } catch (e) {
      sucesso = false;
      notifyListeners();
    }
  }

  void setSelectedColaborador(int idCol, String nome) {
    nomeFuncionario = nome;
    selectedFuncionario = idCol;
    notifyListeners();
  }

  void setSelectedEpi(int idEpi) {
    selectedCurso = idEpi;
    notifyListeners();
  }

  void setDataValidade(String validade) {
    dataValidade = validade;
    notifyListeners();
  }

  //Delete colaborador
  Future<void> deleteFuncionario(int idCol) async {
    carregando = true;
    final response = await apiService.deleteFuncionario(idCol);
    if (response.statusCode == 200 || response.statusCode == 204) {
      funcionarios.removeWhere((funcionario) => funcionario['funcId'] == idCol);
      notifyListeners();
    } else {
      throw Exception('Falha ao excluir Funcionario');
    }
    carregando = false;
    notifyListeners();
  }

//Deleta Epi
  Future<bool> deleteCurso(int idCurso) async {
    final response = await apiService.deleteCurso(idCurso);

    if (response.statusCode == 200 || response.statusCode == 204) {
      cursos.removeWhere((curso) => curso['cursoId'] == idCurso);
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }
}