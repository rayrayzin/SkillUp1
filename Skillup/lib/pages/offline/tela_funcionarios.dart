import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillup/pages/offline/tela_cursos.dart';

class TelaFuncionarios extends StatefulWidget {
  const TelaFuncionarios({super.key});

  @override
  _TelaFuncionariosState createState() => _TelaFuncionariosState();
}

class _TelaFuncionariosState extends State<TelaFuncionarios> {
  List<dynamic> funcionariosComCursos = [];

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  // Método para carregar dados do SharedPreferences
  Future<void> carregarDados() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString('usuariosComCursos');

      print(jsonString);

      if (jsonString != null) {
        setState(() {
          funcionariosComCursos = json.decode(jsonString);
        });
      } else {
        throw Exception('Nenhum dado encontrado no armazenamento.');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar os dados: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: funcionariosComCursos.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: funcionariosComCursos.length,
              itemBuilder: (context, index) {
                final funcionario = funcionariosComCursos[index]['usuario'];
                final cursos = funcionariosComCursos[index]['cursos'];

                return ListTile(
                  title: Text(funcionario['nome'] ?? 'Nome não disponível'),
                  subtitle: Text(funcionario['email'] ?? 'Email não disponível'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TelaCursos(
                          nomeFuncionario: funcionario['nome'],
                          cursos: cursos,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
