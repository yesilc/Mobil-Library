import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../rafDatabase/rafModel.dart';

// ignore: must_be_immutable
class CreateRafWidget extends StatefulWidget {
  final Raf? raf;
  final String operationTur;
  final ValueChanged<String> onSubmit;
  CreateRafWidget(
      {super.key,
      this.raf,
      required this.onSubmit,
      required this.operationTur});

  @override
  State<CreateRafWidget> createState() => _CreateRafWidgetState();
}

class _CreateRafWidgetState extends State<CreateRafWidget> {
  late final TextEditingController _controller;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.raf?.rafName ?? '');
  }

  @override
  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final String _operationTur = widget.operationTur;
    return AlertDialog(
      title: Text(_operationTur),
      content: Form(
        key: _formKey,
        child: TextFormField(
          inputFormatters: [
            FilteringTextInputFormatter.deny(RegExp('-')),
          ],
          autofocus: true,
          controller: _controller,
          decoration: const InputDecoration(hintText: "raf adı"),
          validator: (value) =>
              value != null && value.isEmpty ? "raf adı gerekli" : null,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(("İptal")),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onSubmit(_controller.text);
            }
          },
          child: const Text("Ekle"),
        )
      ],
    );
  }
}
