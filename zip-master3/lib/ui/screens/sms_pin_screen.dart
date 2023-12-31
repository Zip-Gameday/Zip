import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:zip/business/auth.dart';
import 'package:zip/ui/widgets/custom_flat_button.dart';

class SmsPinScreen extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;
  final bool isNewUser;

  SmsPinScreen({Key key, this.verificationId, this.phoneNumber, this.isNewUser})
      : super(key: key);

  @override
  State<SmsPinScreen> createState() => _SmsPinScreenState();
}

class _SmsPinScreenState extends State<SmsPinScreen> {
  @override
  void initState() {}

  String phoneNumber;
  final auth = AuthService();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String otpCode;

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Colors.white),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(35),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.yellow,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 350),
                  child: PinPut(
                    fieldsCount: 6,
                    enabled: true,
                    autofocus: true,
                    withCursor: true,
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    eachFieldConstraints:
                        const BoxConstraints(minHeight: 60.0, minWidth: 50.0),
                    submittedFieldDecoration: _pinPutDecoration.copyWith(
                        borderRadius: BorderRadius.circular(20)),
                    selectedFieldDecoration: _pinPutDecoration,
                    followingFieldDecoration: _pinPutDecoration.copyWith(
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(
                        color: Colors.yellowAccent.withOpacity(.5),
                      ),
                    ),
                    pinAnimationType: PinAnimationType.fade,
                    onChanged: (value) => {
                      setState(() {
                        otpCode = value;
                      }),
                    },
                  ),
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 70,
                  child: CustomTextButton(
                    title: "Verify",
                    fontSize: 20,
                    color: Colors.yellowAccent,
                    textColor: Colors.black,
                    splashColor: Color.fromRGBO(255, 242, 0, 1.0),
                    borderColor: Color.fromRGBO(212, 20, 15, 1.0),
                    borderWidth: 0,
                    onPressed: () {
                      if (otpCode != null && otpCode.length == 6) {
                        print("Verification started");
                        verifyOtp(context, otpCode);
                      } else {
                        showInvalidCodeSnackBar();
                      }
                    },
                  ),
                ),
                const SizedBox(height: 30),
                const Text("Didn't recieve a code?",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    )),
                const SizedBox(height: 30),
                const Text(
                  "Resend new Code",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.yellow),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showInvalidCodeSnackBar() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: const Text(
        "Invalid Code",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.red,
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.yellow,
      duration: Duration(seconds: 5),
    ));
  }

  bool verifyOtp(BuildContext context, String otp) {
    if (widget.isNewUser) {
      auth.verifyOtpForAddingPhoneAuth(
          context: context,
          verificationId: widget.verificationId,
          otp: otp,
          onSuccess: () {
            print("Phone number verification added to current account");
            int count = 0;
            Navigator.of(context).popUntil((_) => count++ >= 2);
            return true;
          });
    } else {
      auth.verifyOtpForLogin(
          context: context,
          verificationId: widget.verificationId,
          otp: otp,
          onSuccess: () {
            print("Login success");
            Navigator.of(context).popUntil((route) => route.isFirst);
            return true;
          });
      return false;
    }
  }
}
