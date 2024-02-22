// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:io';

import 'package:amhtts/components/modelSelectionBottomSheet.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dio = Dio();
  var url = "";
  var amharicTTS =
      "https://api-inference.huggingface.co/models/Walelign/SpeechT5_Amharic_TTS_V1";
  var microsoft =
      "https://api-inference.huggingface.co/models/microsoft/speecht5_tts";
  var facebook =
      "https://api-inference.huggingface.co/models/facebook/fastspeech2-en-ljspeech";
  var coqui = "https://api-inference.huggingface.co/models/coqui/xtts-v2";
  var token = "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";

  var currentModel = 0;
  var modelName = "DeviceTTS";
  void setModel(index) {
    currentModel = index;
    if (index == 0) {
      modelName = "DeviceTTS";
    } else if (index == 1) {
      url = amharicTTS;
      modelName = "AmharicTTS";
    } else if (index == 2) {
      url = microsoft;
      modelName = "Microsoft/SpeechT5_TTS";
    } else if (index == 3) {
      url = facebook;
      modelName = "Facebook/FastSpeech2";
    } else if (index == 4) {
      url = coqui;
      modelName = "Coqui/XTTS-V2";
    }
    setState(() {});
  }

  var apiResponse = "";
  var isLoading = false;
  void callAPI() async {
    apiResponse = "";
    isLoading = true;
    setState(() {});
    print("Sending Request...");
    var userInput = userInputController.text.trim().toString();
    try {
      var abc = await dio.post(
        url,
        data: {"inputs": userInput},
        options: Options(
          headers: {
            "Authorization": "Bearer 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",
          },
        ),
      );
      apiResponse = "";
      isLoading = false;
      setState(() {});

      final Directory tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/temp3_file.flac';

      // print('Downloading...');
      // var res = await dio.download(
      //   url,
      //   filePath,
      //   data: {"inputs": userInput},
      //   options: Options(
      //     headers: {
      //       "Authorization": "Bearer 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",
      //     },
      //   ),
      //   onReceiveProgress: (received, total) {
      //     if (total <= 0) return;
      //     print('percentage: ${(received / total * 100).toStringAsFixed(0)}%');
      //   },
      // );
      // var music = File(filePath);
      // print(await music.exists());
      // print(await music.path);
      // print(await music.stat());
      // print(res.data);
      // print(await file.readAsString());
      // print(abc.data);

      print("Writing to temp file...");
      final file = File(filePath);
      await file.writeAsString(
        abc.data,
        mode: FileMode.writeOnly,
      );
      // await AssetsAudioPlayer.newPlayer().open(
      //   Audio(filePath),
      //   autoStart: true,
      //   showNotification: true,
      // );

      final audioPlayer = AudioPlayer();
      await audioPlayer.setFilePath(filePath);
      await audioPlayer.setAudioSource(file as AudioSource);
      await audioPlayer.play();

      // print("Setting audio source...");
      // UriAudioSource audioFile = AudioSource.file(filePath);
      // await audioPlayer.setAudioSource(audioFile);
      // await audioPlayer.setFilePath(filePath);
      // await audioPlayer.load();

      // print("Playing...");
      // await audioPlayer.play();
      // await audioPlayer.dispose();
    } catch (e) {
      apiResponse = "Server Error!";
      print(e);
    }
    print("Done! Response...");
    isLoading = false;
    setState(() {});
  }

  TextEditingController userInputController = TextEditingController();
  void onDeviceTTS() async {
    var tts = FlutterTts();
    await tts.setLanguage("en-US");
    tts.speak(userInputController.text.trim());
    // var langs = await tts.getLanguages;
    // print(langs);
  }

  void showAvailableModels() {
    showModalBottomSheet(
      context: context,
      builder: (context) => ModelSelectionBottomSheet(setModel: setModel),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.voice_chat,
            ),
            SizedBox(width: 10.0),
            Text("Text To Speech"),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              showAvailableModels();
            },
            icon: Icon(
              Icons.account_tree_outlined,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    // width: MediaQuery.of(context).size.width * 0.7,
                    padding: EdgeInsets.only(left: 20.0, right: 10.0),
                    child: TextField(
                      controller: userInputController,
                      decoration: InputDecoration(
                        hintText: "Enter text to convert to speech",
                      ),
                    ),
                  ),
                ),
                isLoading == true
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () {
                          if (currentModel == 0) {
                            onDeviceTTS();
                          } else {
                            callAPI();
                          }
                        },
                        child: Text(
                          "Speak",
                        ),
                      ),
                SizedBox(width: 10.0),
              ],
            ),
            SizedBox(height: 10.0),
            // Current Model
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: [
                  Text("Selected Model: "),
                  Text(
                    modelName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.0),
            // ERROR
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                apiResponse,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
