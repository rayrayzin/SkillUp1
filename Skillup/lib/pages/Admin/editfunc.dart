import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillup/Model/colaborador/funcedit.dart';
import 'package:skillup/Provider/admin/funcionario.dart';
import 'package:flutter/services.dart';
import 'package:brasil_fields/brasil_fields.dart';

class EditarFuncionarioPage extends StatefulWidget {
  final FuncionarioEdit funcionario;

  EditarFuncionarioPage({required this.funcionario});

  @override
  _EditarFuncionarioPageState createState() => _EditarFuncionarioPageState();
}

class _EditarFuncionarioPageState extends State<EditarFuncionarioPage> {
  final _formKey = GlobalKey<FormState>();
  late String userName;
  late String email;
  late String nome;
  late String cpf;

  @override
  void initState() {
    super.initState();
    userName = widget.funcionario.userName;
    email = widget.funcionario.email;
    nome = widget.funcionario.nome;
    cpf = widget.funcionario.cpf;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Editar Funcionário', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Campo para Username
              TextFormField(
                initialValue: userName,
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(color: Colors.cyan),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.cyan),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  prefixIcon: Icon(Icons.person, color: Colors.cyan),
                ),
                onSaved: (value) => userName = value!,
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 12),

              // Campo para E-mail
              TextFormField(
                initialValue: email,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  labelStyle: TextStyle(color: Colors.cyan),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.cyan),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  prefixIcon: Icon(Icons.email, color: Colors.cyan),
                ),
                onSaved: (value) => email = value!,
                validator: (value) =>
                    value!.contains('@') ? null : 'Digite um e-mail válido',
              ),
              const SizedBox(height: 12),

              // Campo para Nome
              TextFormField(
                initialValue: nome,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  labelStyle: TextStyle(color: Colors.cyan),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.cyan),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  prefixIcon: Icon(Icons.person_add, color: Colors.cyan),
                ),
                onSaved: (value) => nome = value!,
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 12),

              // Campo para CPF
              TextFormField(
                initialValue: cpf,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CpfInputFormatter(),
                ],
                decoration: InputDecoration(
                  labelText: 'CPF',
                  labelStyle: TextStyle(color: Colors.cyan),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.cyan),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  prefixIcon: Icon(Icons.credit_card, color: Colors.cyan),
                ),
                onSaved: (value) => cpf = value!,
                validator: (value) =>
                    value!.length == 14 ? null : 'Digite um CPF válido',
              ),
              const SizedBox(height: 20),

              // Botão de salvar
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    final provider =
                        Provider.of<FuncionarioProvider>(context, listen: false);

                    final funcionarioAtualizado = FuncionarioEdit(
                      id: widget.funcionario.id,
                      userName: userName,
                      email: email,
                      nome: nome,
                      cpf: cpf.replaceAll(RegExp(r'[^0-9]'), ''),
                    );

                    await provider.atualizarFuncionario(funcionarioAtualizado);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(provider.menssagem)),
                    );

                    if (provider.menssagem == 'Funcionario atualizado com sucesso!') {
                      Navigator.pop(context);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan, // Cor do botão
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Salvar Alterações',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
