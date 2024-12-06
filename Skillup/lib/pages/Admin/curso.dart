import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillup/Provider/curso/cursoprovider.dart';
import 'package:skillup/Utils/mensage.dart';
import 'package:skillup/pages/Admin/criaCurso.dart';

class CursoPage extends StatefulWidget {
  const CursoPage({super.key});

  @override
  State<CursoPage> createState() => _CursoPageState();
}

class _CursoPageState extends State<CursoPage> {

  @override
  void initState() {
     Provider.of<CursoProvider>(context, listen: false).listarCursos();
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
        title: const Text("Criar Curso",style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: const Color(0xFF6ECBDE),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/CriaCursoPage');
            },
            icon: const Icon(Icons.add),
            tooltip: 'Adicionar novo curso', 
          ),
        ],
      ),
      body: 
      
      Consumer<CursoProvider>(builder: (context, provider, _) {
        return ListView.builder(
          itemCount: provider.cursos.length,
          itemBuilder:  (context, index) {
              final curso = provider.cursos[index];
            return ListTile(
              title: Text(curso.nome),
              subtitle: Text(curso.descricao),
              
               trailing:  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(onPressed: (){
                        Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CriaCursoPage(
                                            curso: curso),
                                      ),
                                    );

                      }, icon: const Icon(Icons.edit)),
                      IconButton(onPressed: () async{

                           // Exibe a confirmação antes de excluir
                                    bool? confirm = await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Confirmar Exclusão'),
                                        content: Text(
                                            'Tem certeza de que deseja excluir a sala: ${curso.nome}?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context)
                                                    .pop(false),
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
                                      await  provider.deletarCurso(
                                              curso.cursoId);
                                       // ignore: use_build_context_synchronously
                                     showMessage(message: provider.menssagem, context: context);
                            
                                    }

                                    
              

                      }, icon: const Icon(Icons.delete)),
                    ],
                  )            );
          }, 
          );
      },)
      
      
    );
  }

}
