import 'package:intl/intl.dart';


class FuncionarioCurso {
  final int funcId;
  final String id;
  final int cursoId;
  final String dataValidade;

  FuncionarioCurso({
    required this.funcId,
    required this.id,
    required this.cursoId,
    required this.dataValidade,
  });

 

  factory FuncionarioCurso.fromJson(Map<String, dynamic> json) {
  var dateFormat = DateFormat("dd/MM/yyyy");
  
  DateTime? parsedDV;
  try {
    parsedDV = dateFormat.parse(json['dtValidade']);
  } catch (e) {
    throw FormatException('Formato de data inválido: ${json['dtValidade']}');
  }

  final databrv = DateFormat("dd/MM/yyyy").format(parsedDV);

  return FuncionarioCurso(
    funcId: json['FuncionarioId'],
    id: json['Id'],
    cursoId: json['CursoId'],
    dataValidade: databrv.toString(),
  );
}

}