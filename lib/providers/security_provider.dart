import 'package:chat_babakcode/providers/chat_provider.dart';
import 'package:flutter/foundation.dart';

import '../utils/utils.dart';

class SecurityProvider extends ChangeNotifier{
  bool visibilityPhrases = false;

  void copyPhrases(){
    if(myRecoveryPhrases == null){
      return;
    }
    Utils.coptText(myRecoveryPhrases!);
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
      print(credential);
      loadingPhrases = false;
      visibilityPhrases = true;
      myRecoveryPhrases = credential['credential']['recoveryPhrase'];
      notifyListeners();
    });
  }

}