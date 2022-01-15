// ignore_for_file: file_names
import 'dart:convert';

import 'package:chat_flutter/src/models/LoginResModel.dart';
import 'package:chat_flutter/src/utils/HttpUtils.dart';
import 'package:chat_flutter/src/utils/PrefsSIngle.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";

  @override
  void initState() {
    super.initState();
    handleInitShareds();
  }

  Future<void> handleInitShareds() async {
    await PreferenceUtils.init();
    if (PreferenceUtils.getBool('isLogged')) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  SafeArea(
                    child: SizedBox(
                      height: size.height * 0.2,
                    ),
                  ),
                  Container(
                    width: size.width,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 20.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 3.0,
                          offset: Offset(
                            0.0,
                            5.0,
                          ),
                          spreadRadius: 3.0,
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'BIENVENIDO INCIA SESION',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Por favor ingresa tu correo';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() {
                                    email = value;
                                  });
                                },
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                  hintText: 'CORREO',
                                  icon: Icon(
                                    Icons.email,
                                    size: 32.0,
                                  ),
                                  label: Text(
                                    'CORREO',
                                  ),
                                ),
                              ),
                              TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Por favor ingresa tu contraseña';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.text,
                                obscureText: true,
                                onChanged: (value) {
                                  setState(() {
                                    password = value;
                                  });
                                },
                                decoration: const InputDecoration(
                                  hintText: 'CORREO',
                                  icon: Icon(
                                    Icons.lock_outline,
                                    size: 32.0,
                                  ),
                                  label: Text(
                                    'CONTRASEÑA',
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 26,
                              ),
                              ElevatedButton(
                                onPressed: _onSubmit,
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                child: const Text("INICIAR SESION"),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      Response loginData = await Http.login(
        'auth/local',
        jsonEncode(
          {
            'identifier': email,
            'password': password,
          },
        ),
      );

      if (loginData.statusCode == 200) {
        final loginRes = LoginRes.fromMap(loginData.data);

        PreferenceUtils.putString('jwt', loginRes.jwt);
        PreferenceUtils.putString('user', jsonEncode(loginRes.user.toMap()));
        PreferenceUtils.putBool('isLogged', true);
        PreferenceUtils.putInteger('idUser', loginRes.user.id);

        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }
}
