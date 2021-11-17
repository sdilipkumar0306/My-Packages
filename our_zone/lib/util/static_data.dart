import 'modals/common_modals.dart';
import 'modals/firebase_modals.dart';

class UserData {
  static FBUser? primaryUser;
  static FBUser? secondaryUser;
  static List<UserChatCount> usersChatCount = List<UserChatCount>.empty(growable: true);
  static List<UserChatList> userChatList = List<UserChatList>.empty(growable: true);
  static List<UserChatMessages> userChatMessages = List<UserChatMessages>.empty(growable: true);
}
