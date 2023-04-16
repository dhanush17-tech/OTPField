import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int otp = 12456;
  bool _isMatched = false;
  int? _secondsRemaining;
  Timer? _timer;
  bool is_TimerFinished = false;
  @override
  void initState() {
    super.initState();
    _secondsRemaining = 2 * 60;
    startTimer();
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      setState(() {
        if (_secondsRemaining! < 1) {
          timer.cancel();
          is_TimerFinished = true;
        } else {
          _secondsRemaining = _secondsRemaining! - 1;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String minutes = (_secondsRemaining! ~/ 60).toString().padLeft(2, '0');
    String seconds = (_secondsRemaining! % 60).toString().padLeft(2, '0');
    return Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
                top: 18.0, bottom: 24, left: 24, right: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Verify Your Phone",
                        style: GoogleFonts.inter(
                            color: Color(4279049523),
                            fontSize: 27,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(" Enter the verification code sent to you",
                          style: GoogleFonts.inter(
                            color: Color(4282207846),
                            fontSize: 14,
                          )),
                    ),
                    const SizedBox(height: 5),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(" +91731232121",
                          style: GoogleFonts.inter(
                              color: Color(4279049523),
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    otpTextField(
                      seconds,
                      minutes,
                    )
                  ],
                ),
                optionButtons()
              ],
            ),
          ),
        ));
  }

  Widget optionButtons() {
    return Column(
      children: [
        Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.6),
                  )),
              child: Align(
                alignment: Alignment.center,
                child: Text("Resend Code",
                    style: GoogleFonts.inter(
                        fontSize: 16,
                        color: is_TimerFinished == false
                            ? Color(4285102220)
                            : _isMatched == true
                                ? Color(4285102220)
                                : Colors.black,
                        fontWeight: FontWeight.w500)),
              ),
            )),
        const SizedBox(
          height: 30,
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: Colors.grey.withOpacity(0.5), width: 1)),
              child: Align(
                alignment: Alignment.center,
                child: Text("Change Number",
                    style: GoogleFonts.inter(
                        fontSize: 16,
                        color: _isMatched == true
                            ? Color(4285102220)
                            : Colors.black,
                        fontWeight: FontWeight.w500)),
              ),
            ))
      ],
    );
  }

  Widget otpTextField(seconds, minutes) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.all(19),
        decoration: _isMatched == true
            ? BoxDecoration(
                color: Color(4282630007),
                borderRadius: BorderRadius.circular(15))
            : BoxDecoration(),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 238, 236, 236),
                borderRadius: BorderRadius.circular(10),
              ),
              child: OtpTextField(
                fieldWidth: 37.6,
                textStyle: GoogleFonts.inter(fontSize: 18),
                numberOfFields: 6,
                enabledBorderColor: Colors.transparent,
                borderColor: Colors.transparent,
                cursorColor: Colors.transparent,
                focusedBorderColor: Colors.transparent,
                //set to true to show as box or false to show as dash
                showFieldAsBox: true,
                //runs when a code is typed in
                onCodeChanged: (String code) {
                  //handle validation or checks here
                },
                //runs when every textfield is filled
                onSubmit: (String verificationCode) {
                  if (verificationCode == "123456") {
                    setState(() {
                      _isMatched = true;
                    });
                  } else {
                    setState(() {
                      _isMatched = false;
                    });
                  }
                }, // end onSubmit
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            _isMatched == false
                ? Text("Verification code expires in $minutes:$seconds",
                    style: GoogleFonts.inter(
                      color: Color(4285102220),
                      fontSize: 14,
                    ))
                : Container(),
            const SizedBox(
              height: 14,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.done,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 6,
                ),
                Text(
                  "Verified",
                  style: GoogleFonts.inter(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
