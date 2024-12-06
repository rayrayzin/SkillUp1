import 'package:flutter/material.dart';
import 'package:skillup/Services/salvaroffline.dart';
import 'package:skillup/pages/mainAdmin.dart';


Widget? meudrawer(BuildContext contexto, String nome, String email) {
  final UsuarioService usuarioService = UsuarioService();
  bool _isLoading = false; // Controle de estado para o carregamento

  return Drawer(
    backgroundColor: const Color.fromRGBO(50, 64, 82, 1),
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        UserAccountsDrawerHeader(
          currentAccountPicture: const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: Color.fromRGBO(50, 64, 82, 1)),
          ),
          decoration: const BoxDecoration(
            color: Color.fromRGBO(50, 64, 82, 1),
          ),
          accountName: Text(
            nome.isNotEmpty ? nome : "Usuário não carregado",
            style: const TextStyle(color: Colors.white),
          ),
          accountEmail: Text(
            email.isNotEmpty ? email : "Email não carregado",
            style: const TextStyle(color: Colors.white70),
          ),
        ),
        ListTile(
          title: const Text('Lista de colaboradores',
              style: TextStyle(color: Colors.white)),
          onTap: () {
            Navigator.of(contexto).pushNamed("/ListaColab");
          },
        ),
        ListTile(
          title: const Text('Lista de cursos',
              style: TextStyle(color: Colors.white)),
          onTap: () {
            Navigator.of(contexto).pushNamed("/CursoPage");
          },
        ),
        ListTile(
          title: const Text('Cadastro de órgão emissor',
              style: TextStyle(color: Colors.white)),
          onTap: () {
            Navigator.of(contexto).pushNamed("/OrgaoEmissor");
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return ElevatedButton(
                onPressed: _isLoading
                    ? null // Desabilita o botão enquanto carrega
                    : () async {
                        setState(() {
                          _isLoading = true; // Ativa o estado de carregamento
                        });

                        try {
                          await usuarioService.salvarUsuariosComCursos();
                          ScaffoldMessenger.of(contexto).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Dados carregados e salvos com sucesso!')),
                          );
                          Navigator.push(
                            contexto,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const MainAdmin()),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(contexto).showSnackBar(
                            SnackBar(
                                content: Text('Erro ao carregar os dados: $e')),
                          );
                        } finally {
                          setState(() {
                            _isLoading = false; // Finaliza o carregamento
                          });
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isLoading
                      ? Colors.grey // Cor diferente enquanto carrega
                      : const Color.fromARGB(255, 76, 172, 214),
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _isLoading
                      ? const [
                          CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.0,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Carregando...',
                            style: TextStyle(
                                color: Color.fromARGB(255, 218, 218, 218)),
                          ),
                        ]
                      : const [
                          Icon(Icons.download, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            'Carregar Dados',
                            style: TextStyle(
                                color: Color.fromARGB(255, 218, 218, 218)),
                          ),
                        ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        ListTile(
          title: const Text('Sair',
              style: TextStyle(color: Color.fromARGB(255, 224, 66, 66))),
          onTap: () {
            Navigator.of(contexto).pushNamed("/");
          },
        ),
      ],
    ),
  );
}

Widget? colabdrawer(BuildContext contexto, String nome, String email) {
  return Drawer(
    backgroundColor: const Color.fromRGBO(50, 64, 82, 1),
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        UserAccountsDrawerHeader(
          currentAccountPicture: const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: Color.fromRGBO(50, 64, 82, 1)),
          ),
          decoration: const BoxDecoration(
            color: Color.fromRGBO(50, 64, 82, 1),
          ),
          accountName: Text(
            nome.isNotEmpty ? nome : "Usuário não carregado",
            style: const TextStyle(color: Colors.white),
          ),
          accountEmail: Text(
            email.isNotEmpty ? email : "Email não carregado",
            style: const TextStyle(color: Colors.white70),
          ),
        ),
        ListTile(
          title: const Text('Sair',
              style: TextStyle(color: Color.fromARGB(255, 224, 66, 66))),
          onTap: () {
            Navigator.of(contexto).pushNamed("/");
          },
        ),
      ],
    ),
  );
}
