import 'package:snschat_flutter/backend/rest/chat/ConversationGroupAPIService.dart';
import 'package:snschat_flutter/database/sembast/index.dart';
import 'package:snschat_flutter/general/functions/validation_functions.dart';
import 'package:snschat_flutter/objects/index.dart';

import 'bloc.dart';
import 'package:bloc/bloc.dart';

// Idea from Official Documentation. Link: https://bloclibrary.dev/#/fluttertodostutorial
class ConversationGroupBloc extends Bloc<ConversationGroupEvent, ConversationGroupState> {
  ConversationGroupAPIService conversationGroupAPIService = ConversationGroupAPIService();
  ConversationDBService conversationGroupDBService = ConversationDBService();

  @override
  ConversationGroupState get initialState => ConversationGroupsLoading();

  @override
  Stream<ConversationGroupState> mapEventToState(ConversationGroupEvent event) async* {
    // TODO: implement mapEventToState
    if (event is InitializeConversationGroupsEvent) {
      yield* _mapInitializeConversationGroup(event);
    } else if (event is AddConversationGroupEvent) {
      yield* _addConversationGroup(event);
    } else if (event is EditConversationGroupEvent) {
      yield* _editConversationGroup(event);
    } else if (event is DeleteConversationGroupEvent) {
      yield* _deleteConversationGroup(event);
    } else if (event is GetUserPreviousConversationGroupsEvent) {
      yield* _getUserPreviousConversationGroups(event);
    } else if (event is AddGroupMemberEvent) {
      yield* _addGroupMember(event);
    }
  }

  Stream<ConversationGroupState> _mapInitializeConversationGroup(InitializeConversationGroupsEvent event) async* {
    if (state is ConversationGroupsLoading || state is ConversationGroupsNotLoaded) {
      print('ConversationGroupBloc.dart if(state is ConversationGroupsLoading || state is ConversationGroupsNotLoaded)');
      try {
        List<ConversationGroup> conversationGroupListFromDB = await conversationGroupDBService.getAllConversationGroups();
        if (isObjectEmpty(conversationGroupListFromDB)) {
          yield ConversationGroupsNotLoaded();
          functionCallback(event, false);
        } else {
          print('ConversationGroupBloc.dart conversationGroupListFromDB: ' + conversationGroupListFromDB.toString());
          print('ConversationGroupBloc.dart conversationGroupListFromDB.length: ' + conversationGroupListFromDB.length.toString());
          conversationGroupListFromDB.forEach((ConversationGroup conversationGroup) {
            print('ConversationGroupBloc.dart conversationGroup.id.toString(): ' + conversationGroup.id.toString());
            print('ConversationGroupBloc.dart conversationGroup.name.toString(): ' + conversationGroup.name.toString());
            print('ConversationGroupBloc.dart conversationGroup.type.toString(): ' + conversationGroup.type.toString());
            print('ConversationGroupBloc.dart conversationGroup.memberIds.toString(): ' + conversationGroup.memberIds.toString());
            print('ConversationGroupBloc.dart conversationGroup.adminMemberIds.toString(): ' + conversationGroup.adminMemberIds.toString());
          });
          yield ConversationGroupsLoaded(conversationGroupListFromDB);
          functionCallback(event, true);
        }
      } catch (e) {
        yield ConversationGroupsNotLoaded();
        functionCallback(event, false);
      }
    } else if (state is ConversationGroupsLoaded) {
      List<ConversationGroup> conversationGroupList = (state as ConversationGroupsLoaded).conversationGroupList;
      print('ConversationGroupBloc.dart conversationGroupList: ' + conversationGroupList.toString());
      print('ConversationGroupBloc.dart conversationGroupList.length: ' + conversationGroupList.length.toString());
      conversationGroupList.forEach((ConversationGroup conversationGroup) {
        print('ConversationGroupBloc.dart conversationGroup.id.toString(): ' + conversationGroup.id.toString());
        print('ConversationGroupBloc.dart conversationGroup.name.toString(): ' + conversationGroup.name.toString());
        print('ConversationGroupBloc.dart conversationGroup.type.toString(): ' + conversationGroup.type.toString());
        print('ConversationGroupBloc.dart conversationGroup.memberIds.toString(): ' + conversationGroup.memberIds.toString());
        print('ConversationGroupBloc.dart conversationGroup.adminMemberIds.toString(): ' + conversationGroup.adminMemberIds.toString());
      });
    }
  }

  Stream<ConversationGroupState> _addConversationGroup(AddConversationGroupEvent event) async* {
    ConversationGroup newConversationGroup;
    bool added = false;
    if (state is ConversationGroupsLoaded) {
      newConversationGroup = await conversationGroupAPIService.addConversationGroup(event.conversationGroup);

      if (!isObjectEmpty(newConversationGroup)) {
        added = await conversationGroupDBService.addConversationGroup(newConversationGroup);
        if (added) {
          List<ConversationGroup> existingConversationGroupList = (state as ConversationGroupsLoaded).conversationGroupList;

          existingConversationGroupList
              .removeWhere((ConversationGroup existingConversationGroup) => existingConversationGroup.id == event.conversationGroup.id);

          existingConversationGroupList.add(newConversationGroup);

          yield ConversationGroupsLoaded(existingConversationGroupList);
          functionCallback(event, newConversationGroup);
        }
      }
    }

    if (isObjectEmpty(newConversationGroup) || !added) {
      functionCallback(event, null);
    }
  }

  Stream<ConversationGroupState> _editConversationGroup(EditConversationGroupEvent event) async* {
    bool updatedInREST = false;
    bool saved = false;
    if (state is ConversationGroupsLoaded) {
      updatedInREST = await conversationGroupAPIService.editConversationGroup(event.conversationGroup);

      if (updatedInREST) {
        saved = await conversationGroupDBService.editConversationGroup(event.conversationGroup);
        if (saved) {
          List<ConversationGroup> existingConversationGroupList = (state as ConversationGroupsLoaded).conversationGroupList;

          existingConversationGroupList
              .removeWhere((ConversationGroup existingConversationGroup) => existingConversationGroup.id == event.conversationGroup.id);

          existingConversationGroupList.add(event.conversationGroup);

          yield ConversationGroupsLoaded(existingConversationGroupList);
          functionCallback(event, event.conversationGroup);
        }
      }
    }

    if (!updatedInREST || !saved) {
      functionCallback(event, null);
    }
  }

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

  Stream<ConversationGroupState> _getUserPreviousConversationGroups(GetUserPreviousConversationGroupsEvent event) async* {
    List<ConversationGroup> conversationGroupListFromServer =
        await conversationGroupAPIService.getConversationGroupsForUserByMobileNo(event.user.mobileNo);
    if (state is ConversationGroupsLoaded) {
      List<ConversationGroup> existingConversationGroupList = (state as ConversationGroupsLoaded).conversationGroupList;

      if (!isObjectEmpty(conversationGroupListFromServer) && conversationGroupListFromServer.length > 0) {
        // Update the current info of the conversationGroup to latest information
        for (ConversationGroup conversationGroupFromServer in conversationGroupListFromServer) {
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

  // To send response to those dispatched Actions
  void functionCallback(event, value) {
    if (!isObjectEmpty(event)) {
      event.callback(value);
    }
  }
}
