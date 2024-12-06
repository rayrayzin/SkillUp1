import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillup/Model/orgaoEmissor.dart';
import 'package:skillup/Provider/curso/orgaoEmissorProvider.dart';
import 'package:skillup/Utils/mensage.dart';

class OrgaoemissorCad extends StatefulWidget {
  final OrgaoEmissor? orgao;
  const OrgaoemissorCad({super.key, this.orgao});

  @override
  State<OrgaoemissorCad> createState() => _OrgaoemissorcadState();
}

class _OrgaoemissorcadState extends State<OrgaoemissorCad> {
  final TextEditingController _nomecontroller = TextEditingController();

  @override
  void initState() {
    if (widget.orgao != null) {
      _nomecontroller.text = widget.orgao!.nome;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
          title: const Text(''),
          backgroundColor: Colors.cyan,
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(color: Colors.white),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Cadastro de Órgão Emissor',
                style: TextStyle(
                  color: Colors.cyan,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Consumer<OrgaoEmissorProvider>(
                    builder: (context, provider, child) {
                      return TextField(
                        controller: _nomecontroller,
                        decoration: InputDecoration(
                          labelText: 'Nome',
                          labelStyle: const TextStyle(color: Colors.cyan),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(color: Colors.cyan),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(color: Colors.cyan),
                          ),
                          filled: true,
                          fillColor: Colors.cyan.withOpacity(0.1),
                          suffixIcon: IconButton(
                            icon: const Icon(
                              Icons.arrow_circle_right_outlined,
                              color: Colors.cyan,
                            ),
                            onPressed: () async {
                              final orgaoEmissor = OrgaoEmissor(
                                orgaoEmissorId: widget.orgao?.orgaoEmissorId,
                                nome: _nomecontroller.text,
                              );

                              if (widget.orgao == null) {
                                await provider
                                    .cadastrarOrgaoEmissor(orgaoEmissor);
                                ;
                              } else {
                                await provider
                                    .atualizarOrgaoEmissor(orgaoEmissor);
                              }

                              showMessage(
                                  message: provider.menssagem,
                                  context: context);

                               Navigator.of(context)
                                    .pushNamed("/OrgaoEmissor");
                            },
                          ),
                        ),
                        style: const TextStyle(color: Colors.cyan),
                      );
                    },
                  )),
            ],
          ),
        ));
  }
}
