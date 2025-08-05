//converter Json <-> Dart
import 'dart:convert'; //não precisa instalar no PubSpec

void main(){
 String jsonString = '''{
                        "id": "abc123",
                        "name": "Pedro",
                        "idade": 25,
                        "ativo": true,
                        "login": "UserPedro",
                        "password": "1234"
 
                    }''';
//decode jsonString
Map<String, dynamic> usuario = json.decode(jsonString);
  print(usuario["name"]); //Pedro
  print(usuario["login"]);

  //modificar a senha para 6 digitos / Salvar no jsonString
  usuario["password"] = "123456";

  //gravar no json
  jsonString = json.encode(usuario);

  print(jsonString);
}
