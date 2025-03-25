import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: MyApp(), debugShowCheckedModeBanner: false));
}

//construir janela
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Exemplo Widget de Exibição"),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Olá, Flutter!!!", style: TextStyle(fontSize: 20,color: Colors.blue),),
            Text("Flutter é Incrivel!!!", textAlign: TextAlign.center,style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.red,
              letterSpacing: 2,
            ),), 
            Icon(Icons.star, size: 50, color: Colors.amber,),
            IconButton(onPressed: ()=> print("Icone Pressicionado"),
             icon: Icon(Icons.notifications, size: 50,)),
             //Imagens
             Image.network("https://pbs.twimg.com/media/FGG1eZeXoAYuwal.jpg",
             height: 300,
             width: 300,
             fit: BoxFit.cover,),
             //Imagem Local
            Image.asset("assets/img/image.png",
            height: 300,
            width: 300,
            fit: BoxFit.cover,)
          ],
        ),

      )
     );
  }
}
