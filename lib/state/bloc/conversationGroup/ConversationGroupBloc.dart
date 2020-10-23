import 'package:bloc/bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:snschat_flutter/database/sembast/index.dart';
import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/objects/rest/index.dart';
import 'package:snschat_flutter/rest/services/conversation_group/ConversationGroupAPIService.dart';

import 'bloc.dart';

// Idea from Official Documentation. Link: https://bloclibrary.dev/#/fluttertodostutorial
class ConversationGroupBloc extends Bloc<ConversationGroupEvent, ConversationGroupState> {
  ConversationGroupBloc() : super(ConversationGroupsLoading());

  ConversationGroupAPIService conversationGroupAPIService = Get.find();
  ConversationDBService conversationGroupDBService = Get.find();

  @override
  Stream<ConversationGroupState> mapEventToState(ConversationGroupEvent event) async* {
    if (event is InitializeConversationGroupsEvent) {
      yield* _mapInitializeConversationGroup(event);
    } else if (event is AddConversationGroupEvent) {
      yield* _addConversationGroup(event);
    } else if (event is EditConversationGroupEvent) {
      yield* _editConversationGroup(event);
    } else if (event is DeleteConversationGroupEvent) {
      yield* _deleteConversationGroup(event);
    } else if (event is GetUserOwnConversationGroupsEvent) {
      yield* _getUserOwnConversationGroups(event);
    } else if (event is AddGroupMemberEvent) {
      yield* _addGroupMember(event);
    } else if (event is CreateConversationGroupEvent) {
      yield* _createConversationGroup(event);
    } else if (event is RemoveConversationGroupsEvent) {
      yield* _removeAllConversationGroups(event);
    }
  }

  Stream<ConversationGroupState> _mapInitializeConversationGroup(InitializeConversationGroupsEvent event) async* {
    if (state is ConversationGroupsLoading || state is ConversationGroupsNotLoaded) {
      try {
        List<ConversationGroup> conversationGroupListFromDB = await conversationGroupDBService.getAllConversationGroups();
        if (conversationGroupListFromDB.isNotEmpty) {
          yield ConversationGroupsLoaded(conversationGroupListFromDB);
          functionCallback(event, true);
        }
      } catch (e) {
        yield ConversationGroupsNotLoaded();
        functionCallback(event, false);
      }
    }
  }

  // Add Conversation Group to LocalDB and State
  Stream<ConversationGroupState> _addConversationGroup(AddConversationGroupEvent event) async* {
    ConversationGroup conversationGroupFromServer;
    bool added = false;
    if (state is ConversationGroupsLoaded) {
      if (!event.createConversationGroupRequest.isNull) {
        conversationGroupFromServer = await conversationGroupAPIService.addConversationGroup(event.createConversationGroupRequest);
        if (!conversationGroupFromServer.isNull) {
          added = await conversationGroupDBService.addConversationGroup(conversationGroupFromServer);

          if(added) {
            List<ConversationGroup> existingConversationGroupList = (state as ConversationGroupsLoaded).conversationGroupList;

            existingConversationGroupList.add(conversationGroupFromServer);

            yield ConversationGroupsLoading();
            yield ConversationGroupsLoaded(existingConversationGroupList);
            functionCallback(event, conversationGroupFromServer);
          } else {

          }
        }
      }
    }

    if (conversationGroupFromServer.isNull || !added) {
      showToast('Unable to add conversation group. Please try again later.', Toast.LENGTH_LONG);
      functionCallback(event, null);
    }
  }

  Stream<ConversationGroupState> _editConversationGroup(EditConversationGroupEvent event) async* {
    ConversationGroup updatedConversationGroup;
    bool saved = false;
    if (state is ConversationGroupsLoaded) {
      updatedConversationGroup = await conversationGroupAPIService.editConversationGroup(event.editConversationGroupRequest);

      if (!updatedConversationGroup.isNull) {
        saved = await conversationGroupDBService.editConversationGroup(updatedConversationGroup);
        if (saved) {
          List<ConversationGroup> existingConversationGroupList = (state as ConversationGroupsLoaded).conversationGroupList;

          existingConversationGroupList
              .removeWhere((ConversationGroup existingConversationGroup) => existingConversationGroup.id == updatedConversationGroup.id);

          existingConversationGroupList.add(updatedConversationGroup);

          yield ConversationGroupsLoaded(existingConversationGroupList);
          functionCallback(event, updatedConversationGroup);
        }
      }
    }

    if (updatedConversationGroup.isNull || !saved) {
      functionCallback(event, null);
    }
  }

  // AddConversationGroupMember

  // RemoveConversationGroupMember

  // PromoteConversationGroupMemberToAdmin

  // DemoteConversationGroupAdminToMember

  // LeaveConversationGroup

  // BlockNotification

  // UnblockNotification

  Stream<ConversationGroupState> _deleteConversationGroup(DeleteConversationGroupEvent event) async* {
    bool deletedInREST = false;
    bool deleted = false;
    if (state is ConversationGroupsLoaded) {
      deletedInREST = await conversationGroupAPIService.deleteConversationGroup(event.conversationGroup.id);

      if (deletedInREST) {
        deleted = await conversationGroupDBService.deleteConversationGroup(event.conversationGroup.id);

        if (deleted) {
          List<ConversationGroup> existingConversationGroupList = (state as ConversationGroupsLoaded).conversationGroupList;

          existingConversationGroupList
              .removeWhere((ConversationGroup existingConversationGroup) => existingConversationGroup.id == event.conversationGroup.id);

          yield ConversationGroupsLoaded(existingConversationGroupList);
          functionCallback(event, true);
        }
      }
    }

    if (!deletedInREST || !deleted) {
      functionCallback(event, false);
    }
  }

  Stream<ConversationGroupState> _getUserOwnConversationGroups(GetUserOwnConversationGroupsEvent event) async* {
    ConversationPageableResponse conversationPageableResponse = await conversationGroupAPIService.getUserOwnConversationGroups(event.getConversationGroupsRequest);
    if (state is ConversationGroupsLoaded) {
      List<ConversationGroup> existingConversationGroupList = (state as ConversationGroupsLoaded).conversationGroupList;

      if (!conversationPageableResponse.isNull &&
          !conversationPageableResponse.conversationGroupResponses.content.isNull &&
          !conversationPageableResponse.conversationGroupResponses.content.isNotEmpty) {
        List<ConversationGroup> conversationGroupList = conversationPageableResponse.conversationGroupResponses.content.map((e) => ConversationGroup.fromJson(e)).toList();
        // Update the current info of the conversationGroup to latest information
        for (ConversationGroup conversationGroupFromServer in conversationGroupList) {
          // Unable to use contains() method here. Will cause concurrent modification during iteration problem.
          // Link: https://stackoverflow.com/questions/22409666/exception-concurrent-modification-during-iteration-instancelength17-of-gr
          bool conversationGroupExist = false;

          for (ConversationGroup existingConversationGroup in existingConversationGroupList) {
            if (existingConversationGroup.id == conversationGroupFromServer.id) {
              conversationGroupExist = true;
            }
          }

          if (conversationGroupExist) {
            conversationGroupDBService.editConversationGroup(conversationGroupFromServer);

            existingConversationGroupList.removeWhere(
                (ConversationGroup existingConversationGroup) => existingConversationGroup.id == conversationGroupFromServer.id);
          } else {
            conversationGroupDBService.addConversationGroup(conversationGroupFromServer);
          }

          existingConversationGroupList.add(conversationGroupFromServer);
        }
      }

      yield ConversationGroupsLoaded(existingConversationGroupList);
      functionCallback(event, true);
    }
  }

  Stream<ConversationGroupState> _addGroupMember(AddGroupMemberEvent event) async* {
    if (state is ConversationGroupsLoaded) {
      List<ConversationGroup> conversationGroupList = (state as ConversationGroupsLoaded).conversationGroupList;

      ConversationGroup conversationGroup = conversationGroupList.firstWhere((ConversationGroup existingConversationGroup) {
        return existingConversationGroup.id == event.conversationGroupId;
      }, orElse: () => null);

      conversationGroup.memberIds.add(event.userContactId);
      // TODO: To be continued?
    }
  }

  Stream<ConversationGroupState> _createConversationGroup(CreateConversationGroupEvent event) async* {
    CreateConversationGroupRequest createConversationGroupRequest = event.createConversationGroupRequest;

    showLoading('Loading conversation....');

    ConversationGroup conversationGroupFromServer = await conversationGroupAPIService.addConversationGroup(createConversationGroupRequest);

    if (conversationGroupFromServer.isNull) {
      throw Exception("Failed when creating conversation Group. Please try again.");
    }

    bool savedIntoDB = await conversationGroupDBService.addConversationGroup(conversationGroupFromServer);

    if (!savedIntoDB) {
      throw Exception("Failed when saving conversation Group into the DB. Please try again.");
    }

    if (!(state is ConversationGroupsLoaded)) {
      throw Exception("Failed when saving conversation Group: conversationGroupState is not ready. Please restart the application.");
    }

    List<ConversationGroup> existingConversationGroupList = (state as ConversationGroupsLoaded).conversationGroupList;

    existingConversationGroupList.removeWhere((element) => element.id == conversationGroupFromServer.id);

    existingConversationGroupList.add(conversationGroupFromServer);

    yield ConversationGroupsLoaded(existingConversationGroupList);

    Get.back(); // Close show loading...

    functionCallback(event, conversationGroupFromServer);
  }

  Stream<ConversationGroupState> _removeAllConversationGroups(RemoveConversationGroupsEvent event) async* {
    conversationGroupDBService.deleteAllConversationGroups();
    yield ConversationGroupsNotLoaded();
    functionCallback(event, true);
  }

  // To send response to those dispatched Actions
  void functionCallback(event, value) {
    if (!isObjectEmpty(event)) {
      event?.callback(value);
    }
  }
}
