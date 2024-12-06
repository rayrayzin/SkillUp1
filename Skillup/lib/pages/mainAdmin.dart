import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillup/Provider/login/logar.dart';
import 'package:skillup/Utils/drawer.dart';
import 'package:skillup/pages/Admin/curso.dart';
import 'package:skillup/pages/Admin/listaColab.dart';
import 'package:skillup/pages/offline/tela_cursos.dart';

class MainAdmin extends StatefulWidget {
  const MainAdmin({super.key});

  @override
  State<MainAdmin> createState() => _MainAdminState();
}

class _MainAdminState extends State<MainAdmin> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> funcionariosComCursos = [];
  List<dynamic> filteredFuncionarios = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    carregarDados();

    _searchController.addListener(() {
      setState(() {
        filteredFuncionarios = funcionariosComCursos
            .where((funcionario) => (funcionario['usuario']['nome'] ?? '')
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()))
            .toList();
      });
    });
  }

  Future<void> carregarDados() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString('usuariosComCursos');
      if (jsonString != null) {
        setState(() {
          funcionariosComCursos = json.decode(jsonString);
          filteredFuncionarios = List.from(funcionariosComCursos);
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
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isLargeScreen = width > 800;

    final List<Widget> pages = [
      SafeArea(
        child: Column(
          children: [
            Container(
              color: const Color.fromARGB(255, 110, 203, 224),
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  isLargeScreen
                      ? _buildUserAccountInfo()
                      : IconButton(
                          icon: const Icon(Icons.menu, color: Colors.white),
                          onPressed: () =>
                              _scaffoldKey.currentState?.openDrawer(),
                        ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Buscar colaborador',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                        ),
                      ),
                    ),
                  ),
                  Image.asset('assets/images/logop.png'),
                ],
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: const BoxDecoration(
                  color: Color(0xFF2282FF),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: const [
                  Tab(text: 'Colaboradores'),
                  Tab(text: 'Administrador'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildColaboradorList(),
                  _buildAdminInfo(),
                ],
              ),
            ),
          ],
        ),
      ),
      const CursoPage(),
      const ColaboradorPage(),
    ];

    return Consumer<Logar>(builder: (context, provider, child) {
      return Scaffold(
        key: _scaffoldKey,
        body: pages[_selectedIndex],
        drawer: meudrawer(
          context,
          provider.dadosUser["nome"] ?? "Usuário não identificado",
          provider.dadosUser["email"] ?? "Email não disponível",
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.cyan,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Curso'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), label: 'Funcionário'),
          ],
        ),
      );
    });
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

  Widget _buildColaboradorList() {
    if (funcionariosComCursos.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: filteredFuncionarios.length,
      itemBuilder: (context, index) {
        final funcionario = filteredFuncionarios[index]['usuario'];
        final cursos = filteredFuncionarios[index]['cursos'];

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
    );
  }

  Widget _buildAdminInfo() {
    return Consumer<Logar>(builder: (context, provider, _) {
      final nomeUsuario = provider.dadosUser["nome"] ?? "Nome não disponível";
      final emailUsuario =
          provider.dadosUser["email"] ?? "Email não disponível";

      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, 
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue, 
              radius: 40, 
              child: Text(
                nomeUsuario.isNotEmpty
                    ? nomeUsuario[0].toUpperCase()
                    : "U", 
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30, 
                  color: Colors.white, 
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              nomeUsuario,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              emailUsuario,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    });
  }
}
