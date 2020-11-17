import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final String Function(String) validator;
  final void Function(String) onSaved;

  CustomTextField({
    @required this.labelText,
    this.controller,
    this.validator,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        minLines: 1,
        maxLines: 100,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(15),
          //prefixIcon: Icon(Icons.account_circle_rounded),
          labelText: labelText,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide(
              color: Theme.of(context).accentColor,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 1,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide(
              color: Theme.of(context).errorColor,
              width: 1,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide(
              color: Theme.of(context).errorColor,
              width: 1,
            ),
          ),
        ),
        controller: controller,
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }
}
