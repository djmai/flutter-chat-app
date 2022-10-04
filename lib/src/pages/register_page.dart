import 'package:chat/helpers/mostrar_alerta.dart';
import 'package:chat/src/services/auth_service.dart';
import 'package:chat/src/services/socket_service.dart';
import 'package:flutter/material.dart';

import 'package:chat/src/widgets/boton_azul.dart';
import 'package:chat/src/widgets/custom_input.dart';
import 'package:chat/src/widgets/labels.dart';
import 'package:chat/src/widgets/logo.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Logo(texto: 'Registro', img: 'assets/logo.png'),
                _Form(),
                Labels(
                  titulo: '¿Ya tienes cuenta?',
                  subtitulo: 'Iniciar sesión',
                  ruta: 'login',
                ),
                Text(
                  'Terminos y condiciones de uso',
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.perm_identity,
            placeholder: 'Nombre',
            keyboardType: TextInputType.text,
            textController: nameCtrl,
          ),
          CustomInput(
            icon: Icons.mail_outline,
            placeholder: 'Correo',
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeholder: 'Contraseña',
            textController: passCtrl,
            isPassword: true,
          ),
          BotonAzul(
            text: 'Registrar',
            onPressed: authService.autenticando
                ? null
                : () async {
                    FocusScope.of(context).unfocus();
                    final registroOk = await authService.register(
                      nameCtrl.text.trim(),
                      emailCtrl.text.trim(),
                      passCtrl.text.trim(),
                    );
                    if (registroOk == true) {
                      socketService.connect();
                      Navigator.pushReplacementNamed(context, 'usuarios');
                    } else {
                      mostrarAlerta(context, 'Registro incorrecto', registroOk);
                    }
                  },
          ),
        ],
      ),
    );
  }
}
