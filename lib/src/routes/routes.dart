import 'package:flutter/material.dart';

import 'package:chat/src/pages/chat_page.dart';
import 'package:chat/src/pages/loading_page.dart';
import 'package:chat/src/pages/login_page.dart';
import 'package:chat/src/pages/register_page.dart';
import 'package:chat/src/pages/usuarios_pages.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'usuarios': (_) => UsuariosPage(),
  'chat': (_) => ChatPage(),
  'login': (_) => LoginPage(),
  'register': (_) => RegisterPage(),
  'loading': (_) => LoadingPage(),
};
