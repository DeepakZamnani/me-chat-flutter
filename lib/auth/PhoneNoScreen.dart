import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:me_chat_update/auth/AuthPage.dart';

class otpAuth extends ConsumerStatefulWidget {
  static String route = '/otp-screen';
  const otpAuth({super.key});

  @override
  ConsumerState<otpAuth> createState() => _otpAuthState();
}

class _otpAuthState extends ConsumerState<otpAuth>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  TextEditingController numberController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  bool isOtpSent = false;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    numberController.dispose();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            decoration: InputDecoration(
                hintText: 'Enter Phone no',
                label: Text('Enter your phone number')),
            controller: numberController,
          ),
          isOtpSent
              ? TextField(
                  decoration:
                      InputDecoration(hintText: 'OTP', label: Text('OTP')),
                  controller: otpController,
                )
              : Container(),
          isOtpSent
              ? ElevatedButton(
                  onPressed: () {
                    ref
                        .watch(AuthRepositoryProvider.notifier)
                        .verifyOTP(otpController.text);
                  },
                  child: Text('submit otp'))
              : ElevatedButton(
                  onPressed: () async {
                    final ifSent = await ref
                        .watch(AuthRepositoryProvider.notifier)
                        .autoSignInUserWithMobileNumer(numberController.text);
                    setState(() {
                      isOtpSent = true;
                    });
                  },
                  child: Text('Get Otp'))
        ],
      ),
    );
  }
}
