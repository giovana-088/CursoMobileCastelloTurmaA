import 'package:firebase_auth/firebase_auth.dart'; //classe modelo do user
import 'package:flutter/material.dart';
import 'package:todo_list_firebase/views/login_view.dart';
import 'package:todo_list_firebase/views/tarefas_view.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>( //widget de construção de telas a partir de uma tomada de decisão
        //a mudança de tela é determianda pela conexão do usuário ao firebase
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, Snapshot){
        if(Snapshot.hasData){
          //se o snapshot tem dados do usuário, sif que o usuario esta logado
          return TarefasView();
        }
        //caso ao contraio
        return LoginView();
      } 
      );

  }
}