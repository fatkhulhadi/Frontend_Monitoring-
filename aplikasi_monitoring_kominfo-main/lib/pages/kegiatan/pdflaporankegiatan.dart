import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';

class LihatLaporan extends StatelessWidget {
  final String assetPath;
  final String downloadUrl;
  // final String downloadUrl2;

  LihatLaporan(
      {Key? key,
      required this.assetPath,
      required this.downloadUrl,
      // required this.downloadUrl2
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<File>(
        future: _loadFileFromAssets(assetPath),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error loading document: ${snapshot.error}'));
          } else {
            // Open the document with the default application
            WidgetsBinding.instance.addPostFrameCallback((_) {
              OpenFile.open(snapshot.data!.path);
            });
            return Center(child: Text('Opening document...'));
          }
        },
      ),
    );
  }

  Future<File> _loadFileFromAssets(String assetPath) async {
    final byteData = await rootBundle.load(assetPath);
    final file = File(
        '${(await getTemporaryDirectory()).path}/${assetPath.split('/').last}');
    await file.writeAsBytes(byteData.buffer.asUint8List());
    return file;
  }

  Future<void> _downloadFile(String url, BuildContext context) async {
    try {
      final response = await Dio()
          .get(url, options: Options(responseType: ResponseType.bytes));
      final bytes = response.data;

      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/${url.split('/').last}');

      await file.writeAsBytes(bytes);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Document downloaded to ${file.path}')),
      );

      // Open the downloaded file
      OpenFile.open(file.path);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error downloading document: $e')),
      );
    }
  }
}
