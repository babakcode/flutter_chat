part of 'chat.dart';

class ChatVoiceModel extends Chat {

  double? downloadProgress;
  bool isPlaying = false;
  AudioPlayer audioPlayer = AudioPlayer();

  Uint8List? fakeFile;
  String? fileUrl;
  String? text;
  ChatVoiceModel(Map json): super(json) {
    if(json.containsKey('fileUrl')){
      fileUrl = json['fileUrl'];
    }
    if(json.containsKey('fakeFile')){
      fakeFile = json['fakeFile'];
    }
    text = json['text'];
  }
  @override
  Map<String, dynamic> toSaveFormat() {
    Map<String, dynamic> _chatSaveFormat = super.toSaveFormat();
    _chatSaveFormat['fileUrl'] = fileUrl;
    _chatSaveFormat['type'] = 'voice';
    return _chatSaveFormat;
  }
}