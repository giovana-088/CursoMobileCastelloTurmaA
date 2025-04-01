import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
      home: MyApp(),
      debugShowCheckedModeBanner: false,
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
        color: const Color.fromARGB(255, 0, 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  color: const Color.fromARGB(255, 156, 156, 156),
                  height: 200,
                  width: 200,
                  
                ),
                Container(
                  color: const Color.fromARGB(255, 190, 190, 190),
                  height: 150,
                  width: 150,
                ),
            Image.network("https://64.media.tumblr.com/1ac70ff97e771237cc086feb16e9de11/766f4953e9638ac7-ab/s1280x1920/6e1fe67d5e58a42b61b2fb3b1b305cd0a0949071.jpg",
             height: 150,
             width: 150,
             fit: BoxFit.cover,),
        
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  color: const Color.fromARGB(255, 255, 154, 238),
                  height: 100,
                  width: 100,
                ),
                Container(
                  color: Colors.amberAccent,
                  height: 100,
                  width: 100,
                ),
                Container(
                  color: Colors.green,
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
