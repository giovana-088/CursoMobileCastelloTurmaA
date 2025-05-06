import 'package:exemplo_shared_preferences/tela_todo_list.dart';
import 'package:flutter/material.dart';

import "tela_inicial.dart";

void main(){
  runApp(MaterialApp(
    title: "Shared Preferences Exemplo",
    initialRoute: "/",
    theme: ThemeData(brightness: Brightness.light),
    darkTheme: ThemeData(brightness: Brightness.dark),
    routes: {
      "/tarefas": (context) => TelaTodoList(),
      "/": (context) => TelaInicial()
    },

  ));
}