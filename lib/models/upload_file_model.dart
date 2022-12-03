import 'dart:typed_data';

class UploadFileModel{
  String type;
  Uint8List fileBytes;
  String path;

  UploadFileModel({required this.type, required this.fileBytes, required this.path});
}