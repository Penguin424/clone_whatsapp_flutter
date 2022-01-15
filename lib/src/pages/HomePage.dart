// ignore_for_file: file_names
import 'dart:convert';

import 'package:chat_flutter/src/models/MensajeModel.dart';
import 'package:chat_flutter/src/utils/HttpUtils.dart';
import 'package:chat_flutter/src/utils/PrefsSIngle.dart';
import 'package:circular_reveal_animation/circular_reveal_animation.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:math' show pi;

import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  List<Mensajes> mensajes = [];
  String mensaje = "";
  TextEditingController mensajeCOntroller = TextEditingController();
  bool emojiShowing = false;
  bool isClipPresed = false;
  FocusNode focus = FocusNode();
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    handleGetMenssages();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeIn,
    );
  }

  void onFocusKeyBoard() {
    if (emojiShowing) {
      FocusScope.of(context).requestFocus(FocusNode());
    }
  }

  Future<void> handleGetMenssages() async {
    await PreferenceUtils.init();

    focus.addListener(onFocusKeyBoard);

    final mensajesDB = await Http.get(
      'mensajes',
      {
        "populate": "usuario",
        "pagination[pageSize]": 100.toString(),
      },
    );

    if (mensajesDB.statusCode == 200) {
      List<Mensajes> mensajesConvert = mensajesDB.data["data"]
          .map<Mensajes>((json) => Mensajes.fromMap(json))
          .toList();

      setState(() {
        mensajes = mensajesConvert;
      });
    }
  }

  Future handleSendMessage() async {
    final idUsuarioActual = PreferenceUtils.getInteger("idUser");

    final mensajeDB = await Http.post(
      'mensajes',
      jsonEncode(
        {
          "data": {
            "mensaje": mensaje,
            "usuario": idUsuarioActual,
          }
        },
      ),
    );

    if (mensajeDB.statusCode == 200) {
      setState(() {
        mensaje = "";
        mensajeCOntroller.text = "";
        FocusScope.of(context).requestFocus(FocusNode());
        emojiShowing = false;
      });
      handleGetMenssages();
    }
  }

  _onEmojiSelected(Emoji emoji) {
    setState(() {
      mensaje = mensaje + emoji.emoji;
    });
    mensajeCOntroller
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(
        TextPosition(
          offset: mensajeCOntroller.text.length,
        ),
      );
  }

  _onBackspacePressed() {
    setState(() {
      mensaje = mensaje.substring(0, mensaje.length - 1);
    });
    mensajeCOntroller
      ..text = mensajeCOntroller.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
        TextPosition(
          offset: mensajeCOntroller.text.length,
        ),
      );
  }

  Future<void> getImageFilePicker() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final mensajeDB = await Http.post(
        'mensajes',
        jsonEncode(
          {
            "data": {
              "mensaje": "",
              "usuario": PreferenceUtils.getInteger("idUser"),
              "imagen": image.path,
            }
          },
        ),
      );

      if (mensajeDB.statusCode == 200) {
        setState(() {
          mensaje = "";
          mensajeCOntroller.text = "";
          FocusScope.of(context).requestFocus(FocusNode());
          emojiShowing = false;
        });
        handleGetMenssages();
      }
    }
  }

  Future<void> getImadeForImagePIckerSourceCamera() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      final mensajeDB = await Http.post(
        'mensajes',
        jsonEncode(
          {
            "data": {
              "mensaje": "",
              "usuario": PreferenceUtils.getInteger("idUser"),
              "imagen": image.path,
            }
          },
        ),
      );

      if (mensajeDB.statusCode == 200) {
        setState(() {
          mensaje = "";
          mensajeCOntroller.text = "";
          FocusScope.of(context).requestFocus(FocusNode());
          emojiShowing = false;
        });
        handleGetMenssages();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();

    focus.removeListener(onFocusKeyBoard);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                        "https://avatars1.githubusercontent.com/u/17098981?s=460&v=4",
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Pablo Rizo",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Hoy",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white60,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                const Icon(
                  Icons.videocam,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 12,
                ),
                const Icon(
                  Icons.phone,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 12,
                ),
                const Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          color: Theme.of(context).colorScheme.secondary,
          width: size.width,
          height: size.height,
          child: Stack(
            children: [
              SizedBox(
                height: size.height * 0.75,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: mensajes.length,
                    itemBuilder: (context, index) {
                      final mensaje = mensajes[index].attributes;
                      final idUsuarioMensaje = mensaje.usuario.data.id;
                      final idUsuarioActual =
                          PreferenceUtils.getInteger('idUser');
                      final isMe = idUsuarioMensaje == idUsuarioActual;

                      return Row(
                        mainAxisAlignment: isMe
                            ? MainAxisAlignment.start
                            : MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 1.8,
                            ),
                            padding: const EdgeInsets.all(8.0),
                            constraints: BoxConstraints(
                              maxWidth: size.width * 0.8,
                              minHeight: size.height * 0.06,
                              minWidth: size.width * 0.3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  mensaje.mensaje,
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  DateFormat('HH:mm a').format(
                                    mensaje.createdAt.toLocal(),
                                  ),
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                bottom: !emojiShowing ? 0 : 250,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    emojiShowing = !emojiShowing;
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                  });
                                },
                                icon: !emojiShowing
                                    ? const Icon(Icons.insert_emoticon_sharp)
                                    : const Icon(Icons.keyboard),
                              ),
                              Expanded(
                                child: TextField(
                                  controller: mensajeCOntroller,
                                  onChanged: (value) {
                                    setState(() {
                                      mensaje = value;
                                    });
                                  },
                                  focusNode: focus,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.only(
                                      left: 15,
                                      bottom: 11,
                                      top: 11,
                                      right: 15,
                                    ),
                                    hintText: 'Mensaje',
                                  ),
                                ),
                              ),
                              Transform.rotate(
                                angle: -pi / 4,
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isClipPresed = !isClipPresed;
                                      if (animationController.status ==
                                              AnimationStatus.forward ||
                                          animationController.status ==
                                              AnimationStatus.completed) {
                                        animationController.reverse();
                                      } else {
                                        animationController.forward();
                                      }
                                    });
                                  },
                                  icon: const Icon(Icons.attach_file),
                                ),
                              ),
                              IconButton(
                                onPressed: getImadeForImagePIckerSourceCamera,
                                icon: const Icon(Icons.camera_alt),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        width: size.width * 0.12,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: IconButton(
                          onPressed:
                              mensaje.isNotEmpty ? handleSendMessage : null,
                          icon: mensaje.isNotEmpty
                              ? const Icon(
                                  Icons.send,
                                  color: Colors.white,
                                )
                              : const Icon(
                                  Icons.keyboard_voice_sharp,
                                  color: Colors.white,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 70,
                child: CircularRevealAnimation(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    height: 250,
                    width: size.width * 0.95,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  animation: animation,
                  centerAlignment: Alignment.bottomCenter,
                ),
              ),
              Positioned(
                bottom: 0,
                child: Offstage(
                  offstage: !emojiShowing,
                  child: SizedBox(
                    height: 250,
                    width: size.width,
                    child: EmojiPicker(
                      onEmojiSelected: (Category category, Emoji emoji) {
                        _onEmojiSelected(emoji);
                      },
                      onBackspacePressed: _onBackspacePressed,
                      config: Config(
                        columns: 7,
                        emojiSizeMax: 32 * 1,
                        verticalSpacing: 0,
                        horizontalSpacing: 0,
                        initCategory: Category.RECENT,
                        bgColor: Theme.of(context).colorScheme.secondary,
                        indicatorColor: Theme.of(context).colorScheme.primary,
                        iconColor: Colors.grey,
                        iconColorSelected:
                            Theme.of(context).colorScheme.primary,
                        progressIndicatorColor:
                            Theme.of(context).colorScheme.primary,
                        backspaceColor: Theme.of(context).colorScheme.primary,
                        showRecentsTab: true,
                        recentsLimit: 28,
                        noRecentsText: 'No Recents',
                        noRecentsStyle: const TextStyle(
                            fontSize: 20, color: Colors.black26),
                        tabIndicatorAnimDuration: kTabScrollDuration,
                        categoryIcons: const CategoryIcons(),
                        buttonMode: ButtonMode.MATERIAL,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
