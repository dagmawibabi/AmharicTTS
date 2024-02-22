// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

import 'package:amhtts/components/eachModel.dart';
import 'package:flutter/material.dart';

class ModelSelectionBottomSheet extends StatefulWidget {
  const ModelSelectionBottomSheet({super.key, required this.setModel});

  final Function setModel;

  @override
  State<ModelSelectionBottomSheet> createState() =>
      _ModelSelectionBottomSheetState();
}

class _ModelSelectionBottomSheetState extends State<ModelSelectionBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          // height: MediaQuery.of(context).size.height * 0.5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 18.0),
                child: Text(
                  "Models",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Divider(),
              ),
              SizedBox(height: 2.0),
              GestureDetector(
                onTap: () {
                  widget.setModel(0);
                  Navigator.pop(context);
                },
                child: EachModel(
                  image:
                      "https://cdn2.iconfinder.com/data/icons/font-awesome/1792/phone-1024.png",
                  name: "DeviceTTS",
                  detail: "Device's Built-in TTS",
                ),
              ),
              GestureDetector(
                onTap: () {
                  widget.setModel(1);
                  Navigator.pop(context);
                },
                child: EachModel(
                  image:
                      "https://upload.wikimedia.org/wikipedia/commons/thumb/7/71/Flag_of_Ethiopia.svg/383px-Flag_of_Ethiopia.svg.png",
                  name: "AmharicTTS",
                  detail: "Fine-tuned on Tigabu Dataset",
                ),
              ),
              GestureDetector(
                onTap: () {
                  widget.setModel(2);
                  Navigator.pop(context);
                },
                child: EachModel(
                  image: "https://pngimg.com/d/microsoft_PNG13.png",
                  name: "Microsoft/Speecht5_TTS",
                  detail: "SpeechT5 Model",
                ),
              ),
              GestureDetector(
                onTap: () {
                  widget.setModel(3);
                  Navigator.pop(context);
                },
                child: EachModel(
                  image:
                      "https://w7.pngwing.com/pngs/36/959/png-transparent-meta-logo-facebook-social-media-chat-message-communication-icon.png",
                  name: "Facebook/FastSpeech2",
                  detail: "Trained on LJSpeech",
                ),
              ),
              GestureDetector(
                onTap: () {
                  widget.setModel(4);
                  Navigator.pop(context);
                },
                child: EachModel(
                  image:
                      "https://avatars.githubusercontent.com/u/75583352?s=200&v=4",
                  name: "Coqui/XTTS-V2",
                  detail: "SpeechT5 Model",
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
