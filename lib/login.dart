import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'chat.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _Login createState() => _Login();
}

TextEditingController _loginEmailController = TextEditingController();
TextEditingController _loginPasswordController = TextEditingController();
TextEditingController _registerEmailController = TextEditingController();
TextEditingController _registerPasswordController = TextEditingController();

bool showLoginErrorWarning = false;
bool showRegisterErrorWarning = false;

class _Login extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("ログイン")),
        body: Center(
            child: SingleChildScrollView(
                child: Column(children: [
          inputField(
              textEditingController: _loginEmailController, title: "メールアドレス"),
          inputField(
              textEditingController: _loginPasswordController, title: "パスワード"),
          showLoginErrorWarning ? const Text("エラーが発生しました。") : const SizedBox(),
          Center(
              child: ElevatedButton(
            child: const Text("ログイン"),
            onPressed: () => onPressedLogin(
                _loginEmailController.text, _loginPasswordController.text),
          )),
          const Divider(),
          const Text("アカウントを持っていない場合"),
          inputField(
              textEditingController: _registerEmailController,
              title: "メールアドレス"),
          inputField(
              textEditingController: _registerPasswordController,
              title: "パスワード"),
          showRegisterErrorWarning
              ? const Text("エラーが発生しました。")
              : const SizedBox(),
          Center(
              child: ElevatedButton(
            child: const Text("登録"),
            onPressed: () => onPressedRegister(_registerEmailController.text,
                _registerPasswordController.text),
          )),
        ]))));
  }

  Widget inputField({
    required TextEditingController textEditingController,
    required String title,
  }) {
    return SizedBox(
        width: 300,
        child: TextField(
          controller: textEditingController,
          decoration: InputDecoration(hintText: title),
        ));
  }

  void onPressedLogin(String email, String password) async {
    try {
      final newUser = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (newUser.user != null) {
        print("ログインに成功!");
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return Chat();
            },
          ),
        );
      }
    } on FirebaseAuthException catch (_) {
      setState(() {
        showRegisterErrorWarning = true;
      });
    }
  }

  void onPressedRegister(String email, String password) async {
    try {
      final newUser = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      if (newUser.user != null) {
        print("登録成功!");
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return Chat();
            },
          ),
        );
      }
    } on FirebaseAuthException catch (_) {
      setState(() {
        showRegisterErrorWarning = true;
      });
    }
  }
}
