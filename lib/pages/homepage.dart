// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables, depend_on_referenced_packages, unused_field, unused_import, avoid_print

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:amhtts/components/modelSelectionBottomSheet.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wave/wave.dart';
import 'package:wave/config.dart';
import 'package:http/http.dart' as http;

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
  void callAPI2() async {
    apiResponse = "";
    isLoading = true;
    setState(() {});
    print("Sending Request...");

    try {
      var userInput = userInputController.text.trim().toString();
      var validURL = Uri.parse(url);

      var req = await http.post(
        validURL,
        headers: {
          "Authorization": "Bearer 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"
        },
        body: {
          "inputs": userInput,
        },
      );

      Uint8List resBytes = req.bodyBytes;
      // print(resBytes.offsetInBytes);
      // apiResponse = "RESPONSE! ${resBytes.toSet()}";

      final Directory tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/temp10_file.flac';
      print(filePath);

      print("Writing to file...");
      File file = File(filePath);
      await file.writeAsBytes(
        resBytes,
        mode: FileMode.write,
      );

      print("Playing...");
      final audioPlayer = AudioPlayer();
      final audioSource = AudioSource.uri(Uri.file(filePath));
      await audioPlayer.setAudioSource(audioSource);
      await audioPlayer.play();

      print("Done!");
    } catch (e) {
      print(e);
      apiResponse = "Server Error! $e";
    }

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
      builder: (context) => ModelSelectionBottomSheet(
        setModel: setModel,
        isEnglish: isEnglish,
      ),
    );
  }

  bool isMaleVoice = true;
  void selectVoiceGender(int choice) {
    if (choice == 1) {
      isMaleVoice = true;
    } else if (choice == 2) {
      isMaleVoice = false;
    }
    setState(() {});
  }

  bool isEnglish = false;
  void changeLanguage() {
    isEnglish = !isEnglish;
    setState(() {});
  }

  // Did Client Pay?
  bool didclientpay = false;
  void checkdidclientpay() async {
    var result = await dio.get("https://www.dagmawibabi.com/didclientpay.json");
    didclientpay = result.data["didclientpay"];
    setState(() {});
  }

  static const _backgroundColor = Color(0xFFF15BB5);

  @override
  void initState() {
    super.initState();
    checkdidclientpay();
  }

  @override
  Widget build(BuildContext context) {
    return didclientpay == false
        ? Scaffold(
            body: Center(
              child: Text(
                "PAY TO ACCESS APP!",
              ),
            ),
          )
        : Scaffold(
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
                IconButton(
                  onPressed: () {
                    changeLanguage();
                  },
                  icon: Icon(
                    Icons.language_outlined,
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Row(
                      children: [
                        Text(
                          isEnglish == true
                              ? "Selected Model: "
                              : "የተመረጠው ሞዴል: ",
                        ),
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

                  // Wave
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 20.0,
                    child: WaveWidget(
                      config: CustomConfig(
                        colors: [
                          Colors.pinkAccent,
                          Colors.greenAccent,
                          Color(0xFF00BBF9),
                        ],
                        durations: [
                          4000,
                          4000,
                          4000,
                        ],
                        heightPercentages: [
                          1.4,
                          0.80,
                          1.1,
                        ],
                      ),
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      size: Size(
                        double.infinity,
                        double.infinity,
                      ),
                      waveAmplitude: 2,
                    ),
                  ),
                  SizedBox(height: 35.0),

                  // Input Box
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          // width: MediaQuery.of(context).size.width * 0.7,
                          padding: EdgeInsets.only(left: 20.0, right: 10.0),
                          child: TextField(
                            controller: userInputController,
                            decoration: InputDecoration(
                              hintText: isEnglish == true
                                  ? "Enter text to convert to speech"
                                  : "ወደ ንግግር ለመቀየር ጽሑፍ ያስገቡ",
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
                                  callAPI2();
                                }
                              },
                              child: Text(
                                isEnglish == true ? "Speak" : "ተናገር",
                              ),
                            ),
                      SizedBox(width: 10.0),
                    ],
                  ),
                  SizedBox(height: 15.0),

                  // Current Model
                  // Voice Gender
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 20.0),
                          ElevatedButton(
                            onPressed: () {
                              selectVoiceGender(1);
                            },
                            style: isMaleVoice == true
                                ? ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                      Colors.grey[900],
                                    ),
                                    foregroundColor: MaterialStatePropertyAll(
                                      Colors.white,
                                    ),
                                  )
                                : ButtonStyle(),
                            child: Text(
                              isEnglish == true ? "Male" : "የወንድ ድምፅ",
                            ),
                          ),
                          SizedBox(width: 10.0),
                          ElevatedButton(
                            onPressed: () {
                              selectVoiceGender(2);
                            },
                            style: isMaleVoice == false
                                ? ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                      Colors.grey[900],
                                    ),
                                    foregroundColor: MaterialStatePropertyAll(
                                      Colors.white,
                                    ),
                                  )
                                : ButtonStyle(),
                            child: Text(
                              isEnglish == true ? "Female" : "የሴት ድምፅ",
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: ElevatedButton(
                          onPressed: () {
                            selectVoiceGender(1);
                          },
                          child: Text(
                            isEnglish == true ? "Download" : "አውርድ",
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.0),

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
