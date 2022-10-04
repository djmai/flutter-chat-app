import 'package:chat/src/services/chat_service.dart';
import 'package:chat/src/services/usuarios_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:chat/src/models/usuario.dart';
import 'package:chat/src/services/auth_service.dart';
import 'package:chat/src/services/socket_service.dart';

class UsuariosPage extends StatefulWidget {
  const UsuariosPage({Key? key}) : super(key: key);

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  final usuariosService = UsuariosService();

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List<Usuario> usuarios = [];

  @override
  void initState() {
    this._cargarUsuarios();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    final usuario = authService.usuario;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          usuario.nombre,
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.exit_to_app,
            color: Colors.black87,
          ),
          onPressed: () {
            socketService.disconnect();
            Navigator.pushReplacementNamed(context, 'login');
            AuthService.deleteToken();
          },
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: (socketService.serverStatus == ServerStatus.Online)
                ? Icon(Icons.check_circle, color: Colors.blue.shade400)
                : Icon(Icons.disabled_by_default, color: Colors.red),
          ),
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: _cargarUsuarios,
        header: WaterDropHeader(
          complete: Icon(Icons.check, color: Colors.blue.shade400),
          waterDropColor: Colors.blue.shade400,
        ),
        child: _listViewUsuarios(),
      ),
    );
  }

  ListView _listViewUsuarios() {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemCount: usuarios.length,
      itemBuilder: (_, i) => _usuarioListTile(usuarios[i]),
      separatorBuilder: (_, i) => Divider(),
    );
  }

  ListTile _usuarioListTile(Usuario usuario) {
    return ListTile(
      title: Text(usuario.nombre),
      subtitle: Text(usuario.email),
      leading: CircleAvatar(
        child: Text(usuario.nombre.substring(0, 2)),
        backgroundColor: Colors.blue.shade100,
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: usuario.online ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      onTap: () {
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.usuarioPara = usuario;
        Navigator.pushNamed(context, 'chat');
      },
    );
  }

  void _cargarUsuarios() async {
    this.usuarios = await usuariosService.getUsuarios();
    setState(() {});
    // await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }
}
