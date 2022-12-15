import 'package:chat_babakcode/providers/chat_provider.dart';
import 'package:chat_babakcode/providers/global_setting_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../utils/utils.dart';

class SecurityProvider extends ChangeNotifier{
  bool visibilityPhrases = false;

  void copyPhrases(BuildContext context){
    if(myRecoveryPhrases == null){
      return;
    }
    context.read<GlobalSettingProvider>().hideSecurityRecoveryPhraseAlert();
    Utils.copyText(myRecoveryPhrases!);
  }
  bool loadingPhrases = false;
  String? myRecoveryPhrases;


  ChatProvider? chatProvider;
  void initChatProvider(ChatProvider chatProvider) =>
      this.chatProvider = chatProvider;

  void getRecoveryPhrases(){
    print('getRecoveryPhrases');
    loadingPhrases = true;
    visibilityPhrases = false;
    notifyListeners();

    chatProvider?.socket.emitWithAck('myRecoveryPhrase',
        'some data required', ack: (credential){
      loadingPhrases = false;
      visibilityPhrases = true;
      myRecoveryPhrases = credential['credential']['recoveryPhrase'];
      notifyListeners();
    });
  }

}