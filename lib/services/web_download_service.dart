// import 'dart:convert';
// import 'dart:html';
// import 'package:flutter/foundation.dart';
//
// class WebDownloadService{
//   static void download(
//       List<int> bytes, {
//         String? downloadName,
//       }) {
//
//     // Encode our file in base64
//     final _base64 = base64Encode(bytes);
//     // Create the link with the file
//     final anchor =
//     AnchorElement(href: 'data:application/octet-stream;base64,$_base64')
//       ..target = 'blank';
//     // add the name
//     if (downloadName != null) {
//       anchor.download = downloadName;
//     }
//     // trigger download
//     document.body?.append(anchor);
//     anchor.click();
//     anchor.remove();
//     return;
//   }
//
//   static void openInANewTab(url){
//     window.open(url, 'PlaceholderName');
//   }
// }