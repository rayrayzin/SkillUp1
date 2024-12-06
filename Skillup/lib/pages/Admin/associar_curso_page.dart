import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillup/Provider/curso/cursoprovider.dart';
import 'package:intl/intl.dart';
import 'package:skillup/Utils/mensage.dart';

class AssociarCursoPage extends StatefulWidget {
  final String funcionarioId;
  final String funcionarioNome;

  const AssociarCursoPage({
    super.key,
    required this.funcionarioId,
    required this.funcionarioNome,
  });

  @override
  State<AssociarCursoPage> createState() => _AssociarCursoPageState();
}

class _AssociarCursoPageState extends State<AssociarCursoPage> {
  DateTime? _dataValidade;

  @override
  void initState() {
    super.initState();
    final cursoProvider = Provider.of<CursoProvider>(context, listen: false);
    cursoProvider.listarCursos();
    cursoProvider.listarCursosFuncionario(widget.funcionarioId);
  }

  @override
  Widget build(BuildContext context) {
    final cursoProvider = Provider.of<CursoProvider>(context);
    final cursosAssociadosIds =
        cursoProvider.cursosAssociados.map((curso) => curso.idCurso).toSet();

    return Scaffold(
      appBar: AppBar(
        title: Text('Associar Curso a ${widget.funcionarioNome}'),
        centerTitle: true,
        backgroundColor: const Color(0xFF6ECBDE),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Campo de Data de Validade movido para cima
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Data de Validade",
                labelStyle: TextStyle(color: Colors.cyan),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyan),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyan),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                hintText: 'Selecione a data de validade',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              onTap: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (selectedDate != null) {
                  setState(() {
                    _dataValidade = selectedDate;
                  });
                }
              },
              readOnly: true,
              controller: TextEditingController(
                text: _dataValidade != null
                    ? DateFormat('yyyy-MM-dd').format(_dataValidade!)
                    : '',
              ),
            ),
            const SizedBox(height: 20),

            // Lista de Cursos
            Expanded(
              child: cursoProvider.carregando
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: cursoProvider.cursos.length,
                      itemBuilder: (context, index) {
                        final curso = cursoProvider.cursos[index];
                        final isAssociado =
                            cursosAssociadosIds.contains(curso.cursoId);

                        return ListTile(
                          title: Text(curso.nome),
                          trailing: isAssociado
                              ? ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.cyan,
                                  ),
                                  onPressed: () async {
                                    await cursoProvider.dissociarFuncionarioCurso(
                                      widget.funcionarioId,
                                      curso.cursoId,
                                    );
                                    showMessage(
                                      message: cursoProvider.menssagem,
                                      context: context,
                                    );
                                  },
                                  child: const Text("Dissociar",style: TextStyle(color: Colors.white),),
                                )
                              : ElevatedButton(
                                  onPressed: () async {
                                    if (_dataValidade != null) {
                                      await cursoProvider.associarFuncionarioCurso(
                                        widget.funcionarioId,
                                        curso.cursoId,
                                        _dataValidade!,
                                      );
                                      showMessage(
                                        message: cursoProvider.menssagem,
                                        context: context,
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Selecione uma data de validade')),
                                      );
                                    }
                                  },
                                  child: const Text("Associar",style: TextStyle(color: Colors.cyan),),
                                ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
