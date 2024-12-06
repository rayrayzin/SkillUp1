import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillup/Provider/curso/orgaoEmissorProvider.dart';
import 'package:skillup/Utils/mensage.dart';
import 'package:skillup/pages/Admin/orgaoEmissorCad.dart';

class Orgaoemissor extends StatefulWidget {
  const Orgaoemissor({super.key});

  @override
  State<Orgaoemissor> createState() => _Orgaoemissor();
}

class _Orgaoemissor extends State<Orgaoemissor> {
  @override
  void initState() {
    Provider.of<OrgaoEmissorProvider>(context, listen: false)
        .listarOrgaoEmissors();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // Cor do ícone
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
          title: const Text("Cadastro de orgão emissor",style: TextStyle(color: Colors.white),),
          centerTitle: true,
          backgroundColor: Colors.cyan,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/OrgaoEmissorCad');
              },
              icon: const Icon(Icons.add),
              tooltip: 'Adicionar novo orgão emissor',
            ),
          ],
        ),
        body: Consumer<OrgaoEmissorProvider>(
          builder: (context, provider, _) {
            return ListView.builder(
              itemCount: provider.orgaoEmissores.length,
              itemBuilder: (context, index) {
                final orgao = provider.orgaoEmissores[index];
                return ListTile(
                    title: Text(orgao.nome),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      OrgaoemissorCad(orgao: orgao),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit)),
                        IconButton(
                            onPressed: () async {
                              bool? confirm = await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Confirmar Exclusão'),
                                  content: Text(
                                      'Tem certeza de que deseja excluir a sala: ${orgao.nome}?'),
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
                                await provider.deletarOrgaoEmissor(
                                    orgao.orgaoEmissorId as int);
                                // ignore: use_build_context_synchronously
                                showMessage(
                                    message: provider.menssagem,
                                    context: context);
                              }
                            },
                            icon: const Icon(Icons.delete)),
                      ],
                    ));
              },
            );
          },
        ));
  }
}
