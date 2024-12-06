import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillup/Model/colaborador/funcedit.dart';
import 'package:skillup/Provider/admin/funcionario.dart';
import 'package:skillup/Utils/mensage.dart';
import 'package:skillup/pages/Admin/associar_curso_page.dart';
import 'package:skillup/pages/Admin/editfunc.dart';

class ColaboradorPage extends StatefulWidget {
  const ColaboradorPage({super.key});

  @override
  State<ColaboradorPage> createState() => _ColaboradorPageState();
}

class _ColaboradorPageState extends State<ColaboradorPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<FuncionarioProvider>(context, listen: false)
          .listarFuncionarios();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Colaboradores",
          style: TextStyle(
            color: Colors.white, // Cor do título da AppBar
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.cyan,
        iconTheme: const IconThemeData(color: Colors.white),
        actionsIconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/Cadastro');
            },
            icon: const Icon(Icons.add),
            tooltip: 'Adicionar novo colaborador',
          ),
        ],
      ),
      body: Consumer<FuncionarioProvider>(
        builder: (context, provider, _) {
          if (provider.carregando) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: provider.funcionarios.length,
            itemBuilder: (context, index) {
              final funcionario = provider.funcionarios[index];
              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AssociarCursoPage(
                          funcionarioId: funcionario.id,
                          funcionarioNome: funcionario.nome),
                    ),
                  );
                },
                title: Text(funcionario.nome),
                subtitle: Text(funcionario.cpf),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditarFuncionarioPage(
                                funcionario: FuncionarioEdit(
                              id: funcionario.id,
                              userName: funcionario.nome,
                              email: funcionario.email,
                              nome: funcionario.nome,
                              cpf: funcionario.cpf,
                            )),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      onPressed: () async {
                        bool? confirm = await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Confirmar Exclusão'),
                            content: Text(
                              'Tem certeza de que deseja excluir o colaborador: ${funcionario.nome}?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text('Confirmar'),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          await provider.deletarFuncionario(funcionario.id);
                          showMessage(
                            message: provider.menssagem,
                            context: context,
                          );
                        }
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
