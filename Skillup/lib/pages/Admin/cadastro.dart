import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:skillup/Model/funcionario.dart';
import 'package:skillup/Utils/mensage.dart';
import '../../Provider/admin/funcionario.dart';

class Cadastro extends StatefulWidget {
  final Funcionario? funcionario;
  const Cadastro({super.key, this.funcionario});

  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final bool _isChecked = false;
  final maskFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  String? _tipoController;

  @override
  void initState() {
    if (widget.funcionario != null) {
      _nomeController.text = widget.funcionario!.nome;
      _cpfController.text = widget.funcionario!.cpf;
      _emailController.text = widget.funcionario!.email;
      _senhaController.text = widget.funcionario!.password;
      _telefoneController.text = widget.funcionario!.telefone;
      _tipoController = widget.funcionario!.tipo;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(child: Consumer<FuncionarioProvider>(
        builder: (context, provider, _) {
          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'CADASTRE-SE',
                  style: TextStyle(
                    color: Colors.cyan,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                _buildTextField('Nome*', _nomeController, TextInputType.text),
                const SizedBox(height: 10),
                _buildTextField('CPF*', _cpfController, TextInputType.number,
                    inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              CpfInputFormatter(),
                            ],),
                const SizedBox(height: 10),
                _buildTextField(
                    'Email*', _emailController, TextInputType.emailAddress),
                const SizedBox(height: 10),
                _buildTextField('Senha*', _senhaController, TextInputType.text,
                    obscureText: true),
                const SizedBox(height: 10),
                _buildTextField('Número de telefone*', _telefoneController,
                    TextInputType.phone,
                    inputFormatters: [maskFormatter]),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: DropdownButtonFormField<String>(
                    value: _tipoController,
                    items: ['Colaborador', 'Administrador']
                        .map((tipo) => DropdownMenuItem<String>(
                              value: tipo == 'Colaborador' ? 'C' : 'A',
                              child: Text(tipo),
                            ))
                        .toList(),
                    decoration: InputDecoration(
                      labelText: 'Tipo de Usuário',
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
                      fillColor: Colors.white.withOpacity(0.3),
                    ),
                    dropdownColor: Colors.white,
                    onChanged: (value) {
                      setState(() {
                        _tipoController = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 30),
                provider.carregando
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () async {
                          if (_tipoController != null) {
                            await provider.cadastrarFuncionario(Funcionario(
                              id: "",
                              nome: _nomeController.text,
                              cpf: _cpfController.text.replaceAll(RegExp(r'[^0-9]'), ''),
                              password: _senhaController.text,
                              email: _emailController.text,
                              telefone: _telefoneController.text,
                              tipo: _tipoController!,
                            ));

                            if (provider.cadastrado) {
                              showMessage(
                                  message: provider.menssagem,
                                  context: context);
                              Navigator.of(context).pushNamed('/ListaColab');
                            } else {
                              showMessage(
                                  message: provider.menssagem,
                                  context: context);
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Complete o cadastro!'),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyan,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 60, vertical: 25),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text(
                          'CRIAR',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      )),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      TextInputType keyboardType,
      {bool obscureText = false, List<TextInputFormatter>? inputFormatters}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
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
          fillColor: Colors.white.withOpacity(0.3),
        ),
        style: const TextStyle(color: Colors.black), // Alterado para preto
        keyboardType: keyboardType,
        obscureText: obscureText,
        inputFormatters: inputFormatters,
      ),
    );
  }
}
