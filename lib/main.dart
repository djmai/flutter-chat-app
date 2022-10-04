import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat/src/routes/routes.dart';
import 'package:chat/src/services/auth_service.dart';
import 'package:chat/src/services/chat_service.dart';
import 'package:chat/src/services/socket_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => SocketService()),
        ChangeNotifierProvider(create: (_) => ChatService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chat App',
        initialRoute: 'loading',
        routes: appRoutes,
      ),
    );
  }
}
