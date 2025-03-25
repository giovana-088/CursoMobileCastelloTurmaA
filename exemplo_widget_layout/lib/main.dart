import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: MyApp(),
      debugShowCheckedModeBanner: false,
      //routes - rotas de navegação +1 tela
    ),
  );
}

//janela para estudo de layout (Colums,Rows,Stackes,Container)
class MyApp extends StatelessWidget {
  //Sobrescrever o metodo build
  @override
  Widget build(BuildContext context) {
    return Scaffold( //suporte da janela (appbar, body, bottonNB)
      appBar: AppBar(title:Text("Exemplo de Layout")),
      body: Container(
        color: Colors.blueGrey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  color: Colors.black,
                  height: 200,
                  width: 200,
                ),
                Container(
                  color: Colors.red,
                  height: 150,
                  width: 150,
                ),
                Icon(Icons.person, size: 100)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  color: Colors.green,
                  height: 100,
                  width: 100,
                ),
                Container(
                  color: Colors.yellow,
                  height: 100,
                  width: 100,
                ),
                Container(
                  color: Colors.orange,
                  height: 100,
                  width: 100,
                ),
              ],
            ),
            Text("Observação Importantes")
          ]),
      ),
    );
  }
}
