import 'package:rentcarapp/apis/chatting/chatgroupcrud_api.dart';
import 'package:rentcarapp/models/chatting/groupchat_model.dart';
import 'package:rentcarapp/models/responseAPI/returndataapi_model.dart';

class ChatGroupCrudRepository {
  Future<String> getChatGroupCari(String roomId, int hal) async {
    ChatGroupCrudAPI api = ChatGroupCrudAPI();
    return await api.getChatgroupCariAPI(roomId, hal);
  }

  Future<ReturnDataAPI> addTextMessageGroupChat(GroupchatModel chatmsg) async {
    ChatGroupCrudAPI api = ChatGroupCrudAPI();
    return api.addTextMessageGroupChatAPI(chatmsg);
  }

  Future<ReturnDataAPI> addAttachmentGroupChat(GroupchatModel chatmsg) async {
    ChatGroupCrudAPI api = ChatGroupCrudAPI();
    return api.addAttachmentGroupChatAPI(chatmsg);
  }
}