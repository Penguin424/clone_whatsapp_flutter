// ignore_for_file: file_names

import 'dart:convert';

List<Mensajes> mensajesFromMap(String str) =>
    List<Mensajes>.from(json.decode(str).map((x) => Mensajes.fromMap(x)));

String mensajesToMap(List<Mensajes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Mensajes {
  Mensajes({
    required this.id,
    required this.attributes,
  });

  int id;
  MensajeAttributes attributes;

  factory Mensajes.fromMap(Map<String, dynamic> json) => Mensajes(
        id: json["id"],
        attributes: MensajeAttributes.fromMap(json["attributes"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "attributes": attributes.toMap(),
      };
}

class MensajeAttributes {
  MensajeAttributes({
    required this.mensaje,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
    required this.usuario,
  });

  String mensaje;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime publishedAt;
  Usuario usuario;

  factory MensajeAttributes.fromMap(Map<String, dynamic> json) =>
      MensajeAttributes(
        mensaje: json["mensaje"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        publishedAt: DateTime.parse(json["publishedAt"]),
        usuario: Usuario.fromMap(json["usuario"]),
      );

  Map<String, dynamic> toMap() => {
        "mensaje": mensaje,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "publishedAt": publishedAt.toIso8601String(),
        "usuario": usuario.toMap(),
      };
}

class Usuario {
  Usuario({
    required this.data,
  });

  Data data;

  factory Usuario.fromMap(Map<String, dynamic> json) => Usuario(
        data: Data.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "data": data.toMap(),
      };
}

class Data {
  Data({
    required this.id,
    required this.attributes,
  });

  int id;
  DataAttributes attributes;

  factory Data.fromMap(Map<String, dynamic> json) => Data(
        id: json["id"],
        attributes: DataAttributes.fromMap(json["attributes"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "attributes": attributes.toMap(),
      };
}

class DataAttributes {
  DataAttributes({
    required this.username,
    required this.email,
    required this.provider,
    required this.confirmed,
    required this.blocked,
    required this.createdAt,
    required this.updatedAt,
  });

  String username;
  String email;
  String provider;
  bool confirmed;
  bool blocked;
  DateTime createdAt;
  DateTime updatedAt;

  factory DataAttributes.fromMap(Map<String, dynamic> json) => DataAttributes(
        username: json["username"],
        email: json["email"],
        provider: json["provider"],
        confirmed: json["confirmed"],
        blocked: json["blocked"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toMap() => {
        "username": username,
        "email": email,
        "provider": provider,
        "confirmed": confirmed,
        "blocked": blocked,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
