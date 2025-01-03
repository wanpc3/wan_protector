import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const authOutlineInputBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Colors.black),
  borderRadius: BorderRadius.all(Radius.circular(12)),
);

class VerifyCodeForm extends StatefulWidget {
  const VerifyCodeForm({super.key});

  @override
  State<VerifyCodeForm> createState() => _VerifyCodeFormState();
}

class _VerifyCodeFormState extends State<VerifyCodeForm> {
  //Get the value of that number:
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _verification_code = TextEditingController();

  @override
  void dispose() {
    _verification_code.dispose();
    super.dispose();
  }

  void _submitCode() {
    if (_formKey.currentState?.validate() ?? false) {
      //Handle valid code submission
      final code = _verification_code.text;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Code submitted: $code')),
      );
    } else {
      //Handle invalid input
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the correct numbers')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
              TextFormField(
                controller: _verification_code,
                decoration: const InputDecoration(
                  hintText: 'Enter 6-digit code',
                  border: authOutlineInputBorder,
                ),
                keyboardType: TextInputType.number, //Specifies the number keyboard
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, //Allows digits only
                ],
                //Verification code validation
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter 6-digit code';
                  }
                  if (value.length != 6) {
                    return 'The code must be exactly 6 digits';
                  }
                  return null;
                }
              ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _submitCode,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Color.fromARGB(255, 6, 84, 101),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
            ),
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }
}