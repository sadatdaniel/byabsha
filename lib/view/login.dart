import 'package:byabsha/controller/authentication.dart';
import 'package:byabsha/view/viewport.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:responsive_framework/responsive_framework.dart';
import 'package:byabsha/stub/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ndialog/ndialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool value = false;
  final FirebaseAuth auth = FirebaseAuth.instance;

  bool _isLogginIn = true;
  bool _isCreatingAccount = false;
  bool _isForgotPassword = false;

  final newEmailController = TextEditingController();
  final newPassController = TextEditingController();
  final newRePassController = TextEditingController();
  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();
  final resetEmailController = TextEditingController();

  final _newFormKey = GlobalKey<FormState>();
  final _loginformKey = GlobalKey<FormState>();
  final _resetformKey = GlobalKey<FormState>();

  Future<void> signup(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      // Getting users credential
      UserCredential result = await auth.signInWithCredential(authCredential);
      User user = result.user!;

      //Setting UID as a document

      createUIDDocument(user);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return ViewPort(
              user: user,
            );
          },
        ),
      );
    }
  }

  createUIDDocument(User user) async {
    CollectionReference users = FirebaseFirestore.instance.collection('User');
    await users.doc(user.uid).set({
      "uid": user.uid,
    });
  }

  toggleCreateAccount() {
    _isCreatingAccount = true;
    _isForgotPassword = false;
    _isLogginIn = false;
  }

  toggleLogginIn() {
    _isCreatingAccount = false;
    _isForgotPassword = false;
    _isLogginIn = true;
  }

  toggleForgotPassword() {
    _isCreatingAccount = false;
    _isForgotPassword = true;
    _isLogginIn = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // backgroundColor: const Color.fromARGB(255, 231, 231, 231),
      backgroundColor: const Color.fromARGB(255, 232, 232, 232),
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.8, // between 0 and 1
          heightFactor: 0.7,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    color: Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0),
                    ),
                  ),
                ),
              ),

              // _loginForm()
              // _newAccountForm()
              // _forgotPasswordForm(),
              if (_isCreatingAccount) _newAccountForm(),
              if (_isForgotPassword) _forgotPasswordForm(),
              if (_isLogginIn) _loginForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _newAccountForm() {
    return Form(
      key: _newFormKey,
      child: Expanded(
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0),
              // topLeft: Radius.circular(10.0),
              // bottomLeft: Radius.circular(10.0),
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 40, right: 40, top: 30, bottom: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 300,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Sign In", style: kH1TextStyle),
                        _backButton()
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  const Text("Email*", style: kH4TextStyle),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 300,
                    // height: 60,
                    child: TextFormField(
                      autofocus: false,
                      style: const TextStyle(
                          fontFamily: "BreezeSans",
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.w400),
                      keyboardType: TextInputType.emailAddress,
                      controller: newEmailController,
                      decoration: kTextFieldDecoration("mail@website.com"),
                      validator: (text) {
                        if (!(text!.contains('@')) && text.isNotEmpty) {
                          return "Enter a valid email address!";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Password*",
                    style: kH4TextStyle,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 300,
                    // height: 50,
                    child: TextFormField(
                      autofocus: false,
                      style: const TextStyle(
                          fontFamily: "BreezeSans",
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.w400),
                      // obscureText: true,
                      controller: newPassController,
                      decoration: kTextFieldDecoration("Min. 8 character"),
                      validator: (text) {
                        if (!(text!.length > 7) && text.isNotEmpty) {
                          return "Enter valid password of more then 8 characters";
                        }
                        return null;
                      },
                    ),
                  ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Confirm Password*",
                    style: kH4TextStyle,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 300,
                    // height: 40,
                    child: TextFormField(
                      style: const TextStyle(
                          fontFamily: "BreezeSans",
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.w400),
                      controller: newRePassController,
                      decoration: kTextFieldDecoration("Retype your password"),
                      validator: (text) {
                        if (!(text!.length > 7) && text.isNotEmpty) {
                          return "Enter valid password of more then 8 characters";
                        } else if (text != newPassController.text) {
                          return "Password did not match!";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 300,
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        // minimumSize: const Size(20, 10),
                        backgroundColor: Theme.of(context).primaryColor,
                        // padding: const EdgeInsets.symmetric(
                        //     horizontal: 100, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: Text(
                        'Create new acccount',
                        style: kH2TextStyle(14.0, Colors.white),
                      ),
                      onPressed: () {
                        if (_newFormKey.currentState!.validate()) {
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Processing Data')),
                          );
                          String email = newEmailController.text;
                          String password = newPassController.text;
                          AuthenticationHelper authHelper =
                              AuthenticationHelper();
                          authHelper
                              .signUp(email: email, password: password)
                              .then((result) async {
                            if (result == null) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ViewPort(user: authHelper.user),
                                ),
                              );
                            } else if (result ==
                                "The email address is already in use by another account.") {
                              await NDialog(
                                dialogStyle: DialogStyle(
                                  titleDivider: false,
                                  titlePadding: const EdgeInsets.only(
                                      left: 30, top: 30, right: 30),
                                  // contentPadding: EdgeInsets.only(
                                  //     left: 30, top: 25, right: 30),
                                ),
                                title: const Text(
                                  "You already have an account.",
                                  style: kH4TextStyle,
                                ),
                                // content:
                                //     Text("And here is your content, hoho... "),
                                actions: <Widget>[
                                  TextButton(
                                      child: const Text("Login"),
                                      onPressed: () {
                                        setState(() {
                                          Navigator.pop(context);
                                          toggleLogginIn();
                                          _newFormKey.currentState?.reset();
                                          newEmailController.clear();
                                          newPassController.clear();
                                          newRePassController.clear();
                                        });
                                      }),
                                  TextButton(
                                      child: const Text("Forgot Password?"),
                                      onPressed: () {
                                        setState(() {
                                          Navigator.pop(context);
                                          toggleForgotPassword();
                                          _newFormKey.currentState?.reset();
                                          newEmailController.clear();
                                          newPassController.clear();
                                          newRePassController.clear();
                                        });
                                      }),
                                ],
                              ).show(context);
                            } else {
                              // print(result);
                            }
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _backButton() {
    return TextButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            // side: BorderSide(color: Theme.of(context).primaryColor, width: 5.0),
          ),
        ),
      ),
      onPressed: () {
        setState(() {
          toggleLogginIn();
        });
      },
      child: const Text("Back", style: kH4TextStyle),
    );
  }

  Widget _forgotPasswordForm() {
    return Form(
      key: _resetformKey,
      child: Expanded(
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0),
              // topLeft: Radius.circular(10.0),
              // bottomLeft: Radius.circular(10.0),
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 40, right: 40, top: 30, bottom: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 300,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Reset Password", style: kH1TextStyle),
                        _backButton()
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text("Email*", style: kH4TextStyle),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 300,
                    // height: 40,
                    child: TextFormField(
                      autofocus: false,
                      style: const TextStyle(
                          fontFamily: "BreezeSans",
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.w400),
                      keyboardType: TextInputType.emailAddress,
                      controller: resetEmailController,
                      decoration: kTextFieldDecoration("mail@website.com"),
                      validator: (text) {
                        if (!(text!.contains('@')) && text.isNotEmpty) {
                          return "Enter a valid email address!";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 300,
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        // minimumSize: const Size(20, 10),
                        backgroundColor: Theme.of(context).primaryColor,
                        // padding: const EdgeInsets.symmetric(
                        //     horizontal: 100, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: Text(
                        'Get Mail to Reset Password',
                        style: kH2TextStyle(14.0, Colors.white),
                      ),
                      onPressed: () async {
                        if (_resetformKey.currentState!.validate()) {
                          String email = resetEmailController.text;
                          AuthenticationHelper().resetPassword(email: email);
                          await NDialog(
                            dialogStyle: DialogStyle(
                              titleDivider: false,
                              titlePadding: const EdgeInsets.only(
                                  left: 30, top: 30, right: 30),
                              // contentPadding: EdgeInsets.only(
                              //     left: 30, top: 25, right: 30),
                            ),
                            title: const Text(
                              "Please check your email to reset password",
                              style: kH4TextStyle,
                            ),
                            // content:
                            //     Text("And here is your content, hoho... "),
                            actions: <Widget>[
                              TextButton(
                                  child: const Text("Understood"),
                                  onPressed: () {
                                    setState(() {
                                      Navigator.pop(context);
                                      toggleLogginIn();
                                      _resetformKey.currentState?.reset();
                                      resetEmailController.clear();
                                    });
                                  }),
                            ],
                          ).show(context);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginForm() {
    return Form(
      key: _loginformKey,
      child: Expanded(
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0),
              // topLeft: Radius.circular(10.0),
              // bottomLeft: Radius.circular(10.0),
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 40, right: 40, top: 30, bottom: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Login", style: kH1TextStyle),
                  const SizedBox(height: 10),
                  const Text("See your growth and get consulting support!",
                      style: kS1TextStyle),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: 300,
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        // minimumSize: const Size(20, 10),
                        shadowColor: Colors.white, backgroundColor: Colors.white,
                        // padding: const EdgeInsets.symmetric(
                        //     horizontal: 100, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                          side:
                              const BorderSide(color: Colors.grey, width: 1.0),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.google,
                            color: Colors.black,
                            size: 16,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text('Sign in with Google',
                              style: kH2TextStyle(14.0, Colors.black)),
                        ],
                      ),
                      onPressed: () {
                        signup(context);
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    width: 300,
                    child: Row(children: [
                      Expanded(child: Divider()),
                      Text(" or Sign in with Email ", style: kS2TextStyle),
                      Expanded(child: Divider()),
                    ]),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text("Email*", style: kH4TextStyle),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 300,
                    // height: 40,
                    child: TextFormField(
                      autofocus: false,
                      style: const TextStyle(
                          fontFamily: "BreezeSans",
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.w400),
                      keyboardType: TextInputType.emailAddress,
                      controller: loginEmailController,
                      decoration: kTextFieldDecoration("mail@website.com"),
                      validator: (text) {
                        if (!(text!.contains('@')) && text.isNotEmpty) {
                          return "Enter a valid email address!";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Password*",
                    style: kH4TextStyle,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 300,
                    // height: 40,
                    child: TextFormField(
                      autofocus: false,
                      style: const TextStyle(
                          fontFamily: "BreezeSans",
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.w400),
                      // obscureText: true,
                      controller: loginPasswordController,
                      decoration: kTextFieldDecoration("Min. 8 character"),
                      validator: (text) {
                        if (!(text!.length > 7) && text.isNotEmpty) {
                          return "Enter valid password of more then 8 characters";
                        }
                        return null;
                      },
                    ),
                  ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  SizedBox(
                    width: 300,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 24,
                                  height: 48,
                                  child: Checkbox(
                                    activeColor: Theme.of(context).primaryColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6)),
                                    value: value,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        this.value = value!;
                                        // print(value ? "Checked" : "Unchecked");
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Remember me",
                                  style: kH2TextStyle(12.0, Colors.black),
                                ),
                              ],
                            )
                          ],
                        ),
                        Column(
                          children: [
                            TextButton(
                              onPressed: (() {
                                setState(() {
                                  toggleForgotPassword();
                                });
                              }),
                              child: Text(
                                "Forgot password?",
                                style: kH2TextStyle(
                                    12.0, Theme.of(context).primaryColor),
                              ),
                            ),
                            // const SizedBox(height: 10),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    // height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        // minimumSize: const Size(20, 10),
                        backgroundColor: Theme.of(context).primaryColor,
                        // padding: const EdgeInsets.symmetric(
                        //     horizontal: 100, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: Text(
                        'Login',
                        style: kH2TextStyle(14.0, Colors.white),
                      ),
                      onPressed: () {
                        if (_loginformKey.currentState!.validate()) {
                          String email = loginEmailController.text;
                          String password = loginPasswordController.text;
                          AuthenticationHelper authHelper =
                              AuthenticationHelper();
                          authHelper
                              .signIn(email: email, password: password)
                              .then((result) async {
                            if (result == null) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ViewPort(user: authHelper.user),
                                ),
                              );
                            }
                          });
                        }
                      },
                    ),
                  ),
                  // const SizedBox(
                  //   height: 15,
                  // ),
                  SizedBox(
                    width: 300,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Not registered yet?",
                          style: kH2TextStyle(12.0, Colors.black),
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          style: TextButton.styleFrom(
                            // padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () {
                            setState(() {
                              toggleCreateAccount();
                            });
                          },
                          child: Text(
                            "Create an Account",
                            style: kH2TextStyle(
                                12.0, Theme.of(context).primaryColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
