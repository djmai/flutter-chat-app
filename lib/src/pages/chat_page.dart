import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat/src/models/mensajes_response.dart';
import 'package:chat/src/services/auth_service.dart';
import 'package:chat/src/services/chat_service.dart';
import 'package:chat/src/services/socket_service.dart';
import 'package:chat/src/widgets/chat_message.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focuNode = FocusNode();

  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;

  List<ChatMessage> _messages = [];

  bool _estraEscribiendo = false;

  @override
  void initState() {
    super.initState();
    this.chatService = Provider.of<ChatService>(context, listen: false);
    this.socketService = Provider.of<SocketService>(context, listen: false);
    this.authService = Provider.of<AuthService>(context, listen: false);

    this.socketService.socket.on('mensaje-personal', _escucharMensaje);

    _cargarHistorial(this.chatService.usuarioPara.uuid);
  }

  void _cargarHistorial(String uuid) async {
    List<Mensaje> chat = await this.chatService.getChat(uuid);
    final history = chat.map((m) => ChatMessage(
          texto: m.mensaje,
          uuid: m.de,
          animationController: AnimationController(
            vsync: this,
            duration: Duration(milliseconds: 0),
          )..forward(),
        ));
    setState(() {
      _messages.insertAll(0, history);
    });
  }

  void _escucharMensaje(dynamic data) {
    ChatMessage message = ChatMessage(
      texto: data['mensaje'],
      uuid: data['de'],
      animationController: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 500),
      ),
    );

    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    // final chatService = Provider.of<ChatService>(context);
    final usuarioPara = chatService.usuarioPara;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              child: Text(
                usuarioPara.nombre.substring(0, 2),
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              backgroundColor: Colors.blue.shade100,
              maxRadius: 14,
            ),
            SizedBox(height: 3),
            Text(
              usuarioPara.nombre,
              style: TextStyle(color: Colors.black87, fontSize: 12),
            )
          ],
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: _messages.length,
                itemBuilder: (_, i) => _messages[i],
                reverse: true,
              ),
            ),
            Divider(height: 1),
            // TODO: Caja de texto
            Container(
              color: Colors.white,
              child: _inputChat(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit,
                onChanged: (String texto) {
                  // TODO: cuando hay un valor para poder enviar mensaje
                  setState(() {
                    if (texto.trim().length > 0) {
                      _estraEscribiendo = true;
                    } else {
                      _estraEscribiendo = false;
                    }
                  });
                },
                decoration: InputDecoration.collapsed(
                  hintText: 'Enviar mensaje',
                ),
                focusNode: _focuNode,
              ),
            ),

            // Botón de enviar
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 4.0,
              ),
              child: Platform.isIOS
                  ? CupertinoButton(
                      child: Text('Enviar'),
                      onPressed: _estraEscribiendo
                          ? () => _handleSubmit(_textController.text.trim())
                          : null,
                    )
                  : Container(
                      // margin: EdgeInsets.symmetric(horizontal: 2.0),
                      child: IconTheme(
                        data: IconThemeData(color: Colors.blue.shade300),
                        child: IconButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          icon: Icon(
                            Icons.send,
                          ),
                          onPressed: _estraEscribiendo
                              ? () => _handleSubmit(_textController.text.trim())
                              : null,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  _handleSubmit(String texto) {
    if (texto.length == 0) return;

    _textController.clear();
    _focuNode.requestFocus();

    final newMessage = ChatMessage(
      uuid: authService.usuario.uuid,
      texto: texto,
      animationController: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 500),
      ),
    );

    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() {
      _estraEscribiendo = false;
    });

    this.socketService.emit('mensaje-personal', {
      'de': this.authService.usuario.uuid,
      'para': this.chatService.usuarioPara.uuid,
      'mensaje': texto
    });
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    this.socketService.socket.off('mensaje-personal');
    super.dispose();
  }
}
