import 'package:flutter/material.dart';
import 'package:skillup/Provider/admin/cadcurso.dart';
import 'package:skillup/Provider/admin/funccurso.dart';
import 'package:skillup/Provider/admin/funcionario.dart';
import 'package:skillup/Provider/curso/cursoprovider.dart';
import 'package:skillup/Provider/curso/orgaoEmissorProvider.dart';
import 'package:skillup/Provider/funcionario/providertelafunc.dart';
import 'package:skillup/Provider/login/logar.dart';
import 'package:skillup/Provider/usuario/create_user.dart';
import 'package:skillup/Provider/usuario/verifica_usuario.dart';
import 'package:skillup/pages/Admin/cadastro.dart';
import 'package:skillup/pages/Admin/criaCurso.dart';
import 'package:skillup/pages/Admin/curso.dart';
import 'package:skillup/pages/Admin/listaColab.dart';
import 'package:skillup/pages/Admin/login.dart';
import 'package:skillup/pages/Admin/orgaoEmissor.dart';
import 'package:skillup/pages/Admin/orgaoEmissorCad.dart';
import 'package:skillup/pages/Admin/perfilAdmin.dart';
import 'package:skillup/pages/mainAdmin.dart';
import 'package:provider/provider.dart';
import 'package:skillup/pages/mainColaborador.dart';
import 'package:skillup/pages/offline/tela_funcionarios.dart';

void main() async {
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ValidarSenha()),
        ChangeNotifierProvider(create: (_) => UsuarioCadastrado()),
        ChangeNotifierProvider(create: (_) => Logar()),
        ChangeNotifierProvider(create: (_) => CadCursoProvider()),
        ChangeNotifierProvider(create: (_) => FuncionarioCursoProvider()),
        ChangeNotifierProvider(create: (_) => CursoProvider()),
        ChangeNotifierProvider(create: (_) => FuncionarioProvider()),
        ChangeNotifierProvider(create: (_) => OrgaoEmissorProvider()),
        ChangeNotifierProvider(create: (_) => FuncionarioCursoProviderTela()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        
        initialRoute: "/",
        routes: {
          "/": (context) => const Login(),
          "/PerfilAdmin": (context) => const PerfilAdmin(),
          "/Cadastro": (context) => const Cadastro(),
          "/MainAdmin": (context) => const MainAdmin(),
          "/CursoPage": (context) => const CursoPage(),
          "/CriaCursoPage": (context) => const CriaCursoPage(),
          "/ListaColab": (context) => const ColaboradorPage(),
          "/MainColaborador": (context) => const MainColaborador(),
          "/OrgaoEmissorCad": (context) => const OrgaoemissorCad(),
          "/OrgaoEmissor": (context) => const Orgaoemissor(),
          "/funcoffline": (context) => const TelaFuncionarios(),
        },
      )));
} 