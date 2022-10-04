import 'package:chat/global/environment.dart';
import 'package:chat/src/models/mensajes_response.dart';
import 'package:chat/src/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:chat/src/models/usuario.dart';

class ChatService with ChangeNotifier {
  late Usuario usuarioPara;

  Future<List<Mensaje>> getChat(String usuarioID) async {
    final resp = await http.get(
      Uri.https('${Environment.apiUrl}', 'api/mensajes/$usuarioID'),
      headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken() ?? ''
      },
    );

    final mesnajesResp = mensajesResponseFromJson(resp.body);
    return mesnajesResp.mensajes;
  }
}
