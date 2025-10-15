import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: SafeArea(child: HomePage()),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _image;
  String _location = 'Nenhuma localização';
  String _httpResult = 'Nenhuma requisição';
  final ImagePicker _picker = ImagePicker();

  Future<void> _captureAndSavePhoto() async {
    try {
      // pedir permissão de câmera (e armazenamento dependendo do Android)
      final camStatus = await Permission.camera.request();
      if (!camStatus.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Permissão de câmera negada')));
        return;
      }

      final XFile? picked = await _picker.pickImage(source: ImageSource.camera, maxWidth: 2048);
      if (picked == null) return;

      // obter localização (tenta solicitar permissão se necessário)
      String locationText = 'Localização não disponível';
      try {
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (serviceEnabled) {
          LocationPermission permission = await Geolocator.checkPermission();
          if (permission == LocationPermission.denied) {
            permission = await Geolocator.requestPermission();
          }
          if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
            Position pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
            locationText = 'Lat: ${pos.latitude.toStringAsFixed(6)}, Lon: ${pos.longitude.toStringAsFixed(6)}';
            setState(() => _location = locationText);
          } else {
            locationText = 'Permissão de localização negada';
            setState(() => _location = locationText);
          }
        } else {
          locationText = 'Serviço de localização desativado';
          setState(() => _location = locationText);
        }
      } catch (e) {
        locationText = 'Erro localização: $e';
        setState(() => _location = locationText);
      }

      // carregar bytes da imagem
      final Uint8List originalBytes = await picked.readAsBytes();

      // montar texto com data/hora e localização
      final now = DateTime.now();
      final String dateText = '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      final String timeText = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
      final String overlayText = '$dateText $timeText\n$locationText';

      // desenhar overlay usando Canvas (dart:ui)
      final Uint8List annotated = await _drawTextOnImage(originalBytes, overlayText);

      // solicitar permissão de armazenamento (Android pré-33) — permission_handler faz checagem geral
      if (Platform.isAndroid) {
        final storageStatus = await Permission.storage.request();
        if (!storageStatus.isGranted && !storageStatus.isLimited) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Permissão de armazenamento negada')));
          // mesmo sem salvar na galeria, mostra a imagem anotada na tela
          final tmp = await _writeTempFile(annotated);
          setState(() => _image = File(tmp.path));
          return;
        }
      }

      // salvar na galeria
      final String fileName = 'photo_${now.millisecondsSinceEpoch}';
      final result = await ImageGallerySaver.saveImage(annotated, quality: 100, name: fileName);
      final bool success = result['isSuccess'] == true || result['filePath'] != null;
      if (success) {
        // mostrar a imagem no app (arquivo temporário)
        final tmp = await _writeTempFile(annotated);
        setState(() => _image = File(tmp.path));
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Foto salva na galeria')));
      } else {
        final tmp = await _writeTempFile(annotated);
        setState(() => _image = File(tmp.path));
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erro ao salvar na galeria')));
      }
    } catch (e) {
      debugPrint('Erro ao capturar/salvar: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $e')));
    }
  }

  Future<File> _writeTempFile(Uint8List bytes) async {
    final tempDir = Directory.systemTemp;
    final tmpFile = File('${tempDir.path}/annotated_${DateTime.now().millisecondsSinceEpoch}.png');
    await tmpFile.writeAsBytes(bytes);
    return tmpFile;
  }

  Future<Uint8List> _drawTextOnImage(Uint8List imageBytes, String text) async {
    // decode image to ui.Image
    final ui.Codec codec = await ui.instantiateImageCodec(imageBytes);
    final ui.FrameInfo fi = await codec.getNextFrame();
    final ui.Image image = fi.image;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()));
    final paint = Paint();
    canvas.drawImage(image, Offset.zero, paint);

    // preparação do texto
    final double padding = (image.width * 0.02).clamp(8.0, 32.0);
    final double maxWidth = image.width.toDouble() - padding * 2;
    final ui.ParagraphStyle pStyle = ui.ParagraphStyle(
      textAlign: ui.TextAlign.left,
      maxLines: 3,
    );
    final ui.TextStyle tStyle = ui.TextStyle(
      color: ui.Color(0xFFFFFFFF),
      fontSize: (image.width / 20).clamp(14.0, 48.0),
      shadows: [
        ui.Shadow(offset: const Offset(1, 1), blurRadius: 2, color: ui.Color(0x80000000)),
      ],
    );
    final ui.ParagraphBuilder pb = ui.ParagraphBuilder(pStyle)..pushStyle(tStyle)..addText(text);
    final ui.Paragraph paragraph = pb.build()..layout(ui.ParagraphConstraints(width: maxWidth));

    // desenhar fundo semitransparente atrás do texto (rodapé)
    final double rectHeight = paragraph.height + padding * 2;
    final Rect rect = Rect.fromLTWH(0, image.height.toDouble() - rectHeight, image.width.toDouble(), rectHeight);
    final Paint rectPaint = Paint()..color = ui.Color(0x80000000);
    canvas.drawRect(rect, rectPaint);

    // desenhar o parágrafo
    canvas.drawParagraph(paragraph, Offset(padding, image.height.toDouble() - rectHeight + padding));

    final ui.Picture picture = recorder.endRecording();
    final ui.Image finalImage = await picture.toImage(image.width, image.height);
    final ByteData? pngBytes = await finalImage.toByteData(format: ui.ImageByteFormat.png);
    return pngBytes!.buffer.asUint8List();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? picked = await _picker.pickImage(source: source, maxWidth: 1024);
      if (picked != null) {
        setState(() => _image = File(picked.path));
      }
    } catch (e) {
      debugPrint('Erro ao pegar imagem: $e');
    }
  }

  Future<void> _getLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _location = 'Serviço de localização desativado');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        setState(() => _location = 'Permissão negada permanentemente');
        return;
      }
      if (permission == LocationPermission.denied) {
        setState(() => _location = 'Permissão negada');
        return;
      }

      Position pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() => _location = 'Lat: ${pos.latitude}, Lon: ${pos.longitude}');
    } catch (e) {
      setState(() => _location = 'Erro ao obter localização: $e');
    }
  }

  Future<void> _doHttpGet() async {
    try {
      final uri = Uri.parse('https://jsonplaceholder.typicode.com/todos/1');
      final resp = await http.get(uri);
      if (resp.statusCode == 200) {
        final body = jsonDecode(resp.body);
        setState(() => _httpResult = body.toString());
      } else {
        setState(() => _httpResult = 'Erro HTTP: ${resp.statusCode}');
      }
    } catch (e) {
      setState(() => _httpResult = 'Erro na requisição: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text('Tirar foto (salva na galeria) com data/hora/local', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _captureAndSavePhoto,
                icon: const Icon(Icons.camera_alt),
                label: const Text('Tirar foto (salvar)'),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () => _pickImage(ImageSource.gallery),
                icon: const Icon(Icons.photo_library),
                label: const Text('Abrir Galeria'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _image != null
              ? Image.file(_image!, width: 300, height: 300, fit: BoxFit.cover)
              : Container(width: 300, height: 300, color: Colors.grey[200], alignment: Alignment.center, child: const Text('Nenhuma imagem')),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _getLocation,
            icon: const Icon(Icons.my_location),
            label: const Text('Obter localização'),
          ),
          const SizedBox(height: 8),
          Text(_location),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _doHttpGet,
            icon: const Icon(Icons.http),
            label: const Text('Fazer requisição HTTP'),
          ),
          const SizedBox(height: 8),
          Text(_httpResult),
        ],
      ),
    );
  }
}
// ...existing code...