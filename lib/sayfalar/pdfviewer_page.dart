import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'raflar.dart';

// ignore: must_be_immutable
class PDFViewerPage extends StatefulWidget {
  String pdfName;
  PDFViewerPage({super.key, required this.pdfName});

  @override
  State<PDFViewerPage> createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            "PDF Viewer",
            style: TextStyle(color: Colors.white),
          ),
          leading: BackButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Raflar()));
            },
            color: Colors.white,
          ),
        ),
        body: SfPdfViewer.file(File(widget.pdfName)));
  }
}
