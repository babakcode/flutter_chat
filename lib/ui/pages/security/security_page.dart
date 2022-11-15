import 'package:chat_babakcode/providers/security_provider.dart';
import 'package:chat_babakcode/ui/widgets/app_button.dart';
import 'package:chat_babakcode/ui/widgets/app_button_rounded.dart';
import 'package:flutter/material.dart';
import 'package:phlox_animations/phlox_animations.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_constants.dart';
import '../../widgets/app_text.dart';

class SecurityPage extends StatefulWidget {
  const SecurityPage({Key? key}) : super(key: key);

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {

  @override
  void initState() {
    final securityProvider = context.read<SecurityProvider>();
    securityProvider.myRecoveryPhrases = null;
    securityProvider.visibilityPhrases = false;
    securityProvider.loadingPhrases = false;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final securityProvider = context.watch<SecurityProvider>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_rounded)),
        title: const Text('Security'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: AppText('Protect your account',
                        size: 20, fontWeight: FontWeight.bold),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: AppText(
                        'press the show button to see your recovery phrases'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    child: Card(
                      color: Colors.red[100],
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AppText(
                          'Do not share these phrases with other accounts !!',
                          size: 14,
                          color: Colors.red[900],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),

                  SizedBox(
                    width: 330,
                    child: Card(
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                            color: AppConstants.primarySwatch[50]!, width: 2),
                      ),
                      borderOnForeground: true,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: AppText(
                          securityProvider.myRecoveryPhrases ??
                              'ooo oooo ooooo oo ooooo oooo',
                          size: 16,
                          textAlign: securityProvider.visibilityPhrases
                              ? null
                              : TextAlign.center,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),

                  !securityProvider.visibilityPhrases
                      ? PhloxAnimations(
                          duration: const Duration(seconds: 1),
                          auto: true,
                          loop: true,
                          fromX: -2,
                          toX: 2,
                          child: AppButton(
                            onPressed: securityProvider.getRecoveryPhrases,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text('Show'),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(Icons.visibility_rounded)
                              ],
                            ),
                          ),
                        )
                      : AppButtonRounded(
                          onPressed: securityProvider.copyPhrases,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text('copy and don\'t show alert'),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(Icons.copy_all_rounded)
                            ],
                          ),
                        )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
