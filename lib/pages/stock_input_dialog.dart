import 'package:flutter/material.dart';

class StockInputDialog extends StatefulWidget {
  const StockInputDialog({
    super.key,
  });

  @override
  State<StockInputDialog> createState() => _StockInputDialogState();
}

class _StockInputDialogState extends State<StockInputDialog> {
  final _companyNameController = TextEditingController(text:'amzn');

  @override
  void dispose() {
    _companyNameController.dispose();
    super.dispose();
  }

  void submitUserInput() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: Text(
          'Searching ticker: ${_companyNameController.text}',
        ),
      ),
    );

    Navigator.pop(context, _companyNameController.text);
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      semanticLabel: 'Dialog box for seraching company stocks',
      title: const Text('Add company'),
      contentPadding: const EdgeInsets.fromLTRB(26, 12, 26, 16),
      children: [
        const Text(
          'Enter ticker of the company whose stock you would like to see',
          softWrap: true,
          textWidthBasis: TextWidthBasis.parent,
        ),
        // const SizedBox(height: 16),
        TextFormField(
          keyboardType: TextInputType.name,
          autofocus: true,
          controller: _companyNameController,
          onTapOutside: (event) => FocusScope.of(context).unfocus(),
          validator: (String? username) {
            if (username == null || username.isEmpty) {
              return 'Company name cannot be empty.';
            }
            return null;
          },
          onFieldSubmitted: (value) => submitUserInput(),
          textInputAction: TextInputAction.done,
          decoration: const InputDecoration(
            label: Text('Company Ticker'),
          ),
          enableSuggestions: true,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => submitUserInput(),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Search '),
              Icon(Icons.search),
            ],
          ),
        ),
      ],
    );
  }
}
