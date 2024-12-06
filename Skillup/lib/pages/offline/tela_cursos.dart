import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para formatar e manipular datas

class TelaCursos extends StatelessWidget {
  final String nomeFuncionario;
  final List<dynamic> cursos;

  const TelaCursos({super.key, required this.nomeFuncionario, required this.cursos});

  @override
  Widget build(BuildContext context) {
    // Data atual
    final DateTime hoje = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cursos de $nomeFuncionario',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.cyan,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), 
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: cursos.isEmpty
          ? Center(
              child: Text(
                'Nenhum curso encontrado para $nomeFuncionario',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              itemCount: cursos.length,
              itemBuilder: (context, index) {
                final curso = cursos[index];
                final DateTime dataValidade =
                    DateFormat('yyyy-MM-dd').parse(curso['dataValidade']);
                final bool expirado = dataValidade.isBefore(hoje);

                return Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Colors.cyan, 
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Icon(
                      expirado ? Icons.warning : Icons.check_circle,
                      color: expirado ? Colors.red : Colors.green,
                    ),
                    title: Text(
                      curso['nomeCurso'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ID do Curso: ${curso['idCurso']}'),
                        Text(
                          'Validade: ${DateFormat('dd/MM/yyyy').format(dataValidade)}',
                          style: TextStyle(
                            color: expirado ? Colors.red : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    trailing: expirado
                        ? const Text(
                            'Expirado',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : const Text(
                            'Válido',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                );
              },
            ),
    );
  }
}
