import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillup/Provider/funcionario/providertelafunc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillup/Provider/login/logar.dart';
import 'package:skillup/Utils/drawer.dart';

class MainColaborador extends StatefulWidget {
  const MainColaborador({super.key});

  @override
  State<MainColaborador> createState() => _MainColaboradorState();
}

class _MainColaboradorState extends State<MainColaborador>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _filteredCursos = [];
  late String funcionarioId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadFuncionarioId();
    _searchController.addListener(() {
      setState(() {
        _filterCursos();
      });
    });
  }

  Future<void> _loadFuncionarioId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      funcionarioId = prefs.getString("id") ?? "0";
    });

    // Carrega os cursos do funcionário assim que o ID é carregado
    if (funcionarioId.isNotEmpty) {
      await Provider.of<FuncionarioCursoProviderTela>(context, listen: false)
          .fetchCursos(funcionarioId);
      _filterCursos();
    }
  }

  void _filterCursos() {
    final provider =
        Provider.of<FuncionarioCursoProviderTela>(context, listen: false);
    final cursos = provider.cursos;

    _filteredCursos = cursos
        .where((curso) => curso.nomeCurso
            .toLowerCase()
            .contains(_searchController.text.toLowerCase()))
        .map((curso) =>
            {"idCurso": curso.idCurso.toString(), "nomeCurso": curso.nomeCurso})
        .toList();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isLargeScreen = width > 800;
    final provider = Provider.of<FuncionarioCursoProviderTela>(context);

    // Acessa os dados do usuário pelo Provider
    final logarProvider = Provider.of<Logar>(context);
    final String nomeUsuario =
        logarProvider.dadosUser["nome"] ?? "Usuário não identificado";
    final String emailUsuario =
        logarProvider.dadosUser["email"] ?? "Email não disponível";

    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Column(
          children: [
            // Header com barra de busca
            Container(
              color: const Color.fromARGB(255, 110, 203, 224),
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  isLargeScreen
                      ? _buildUserAccountInfo()
                      : IconButton(
                          icon: const Icon(
                            Icons.menu,
                            color: Colors.white,
                          ),
                          onPressed: () =>
                              _scaffoldKey.currentState?.openDrawer(),
                        ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Buscar curso',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                               horizontal: 10),
                        ),
                      ),
                    ),
                  ),
                  Image.asset('assets/images/logop.png'),
                ],
              ),
            ),
            // Conteúdo principal com abas
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildColaboradorList(provider),
                  const Center(child: Text('Lista de Cursos')),
                ],
              ),
            ),
          ],
        ),
      ),
      drawer: colabdrawer(context, nomeUsuario, emailUsuario), // Dados dinâmicos
    );
  }

  Widget _buildUserAccountInfo() {
    return Consumer<Logar>(builder: (context, provider, _) {
      return Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 20,
            child: Text(
              provider.dadosUser["nome"] != null
                  ? provider.dadosUser["nome"].substring(0, 1).toUpperCase()
                  : "U",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(50, 64, 82, 1),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                provider.dadosUser["nome"] ?? "Usuário não identificado",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                provider.dadosUser["email"] ?? "Email não disponível",
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildColaboradorList(FuncionarioCursoProviderTela provider) {
    final cursos = _filteredCursos;

    if (cursos.isEmpty) {
      return const Center(child: Text("Nenhum curso encontrado."));
    }

    return ListView.builder(
      itemCount: cursos.length,
      itemBuilder: (context, index) {
        final curso = cursos[index];
        final nomeCurso = curso["nomeCurso"];
        int idCurso = int.parse(curso["idCurso"].toString());

        return ListTile(
          title: Text(nomeCurso ?? 'Curso não disponível'),
          onTap: () async {
            // Buscar validade do curso ao clicar
            await provider.fetchValidadeCurso( idCurso );

            // Mostrar a validade em um dialog
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Validade do Curso"),
                content: Text(provider.validadeCurso?.dataValidade ??
                    "Validade não encontrada"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Fechar"),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
