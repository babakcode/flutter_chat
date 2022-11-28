part of 'chat.dart';

class ChatVoiceModel extends Chat {

  double? downloadProgress;
  bool isPlaying = false;
  AudioPlayer audioPlayer = AudioPlayer();

  late String fileUrl;
  ChatVoiceModel(Map json): super(json) {
    fileUrl = json['fileUrl'];
  }
  @override
  Map<String, dynamic> toSaveFormat() {
    Map<String, dynamic> _chatSaveFormat = super.toSaveFormat();
    _chatSaveFormat['fileUrl'] = fileUrl;
    _chatSaveFormat['type'] = 'voice';
    return _chatSaveFormat;
  }
}