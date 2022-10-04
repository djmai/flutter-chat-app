// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

import 'package:chat/src/models/usuario.dart';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  LoginResponse({
    required this.ok,
    required this.msg,
    required this.usuario,
    required this.token,
  });

  bool ok;
  String msg;
  Usuario usuario;
  String token;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    ok: json["ok"],
    msg: json["msg"],
    usuario: Usuario.fromJson(json["usuario"]),
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "ok": ok,
    "msg": msg,
    "usuario": usuario.toJson(),
    "token": token,
  };
}

// class Usuario {
//   Usuario({
//     required this.nombre,
//     required this.email,
//     required  this.online,
//     required this.uuid,
//   });
//
//   String nombre;
//   String email;
//   bool online;
//   String uuid;
//
//   factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
//     nombre: json["nombre"],
//     email: json["email"],
//     online: json["online"],
//     uuid: json["uuid"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "nombre": nombre,
//     "email": email,
//     "online": online,
//     "uuid": uuid,
//   };
// }
