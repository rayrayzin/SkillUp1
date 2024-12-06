import 'package:shared_preferences/shared_preferences.dart';

const idUser = "id";
const token = "token";
const nivel = "nivel";

class GetId {
  final SharedPreferences usuario;

  GetId(this.usuario);

  Future<void> gravarId(String value) async {
    await usuario.setString(idUser, value);
  }

  String pegarId() {
    return usuario.getString(idUser) ?? "0";
  }

  Future<void> gravarToken(String value) async {
    await usuario.setString(token, value);
  }

  String pegarToken() {
    return usuario.getString(token) ?? "";
  }

  Future<void> gravarNivel(String value) async {
    await usuario.setString(nivel, value);
  }

  String pegarNivel() {
    return usuario.getString(nivel) ?? "";
  }
}