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
    }
  }

  Stream<ConversationGroupState> _mapInitializeConversationGroup(InitializeConversationGroupsEvent event) async* {
    try {
      List<ConversationGroup> conversationGroupListFromDB = await conversationGroupDBService.getAllConversationGroups();

      print("conversationGroupListFromDB.length: " + conversationGroupListFromDB.length.toString());

      yield ConversationGroupsLoaded(conversationGroupListFromDB);

      functionCallback(event, true);
    } catch (e) {
      functionCallback(event, false);
    }
  }

  Stream<ConversationGroupState> _addConversationGroup(AddConversationGroupEvent event) async* {
    ConversationGroup newConversationGroup;
    bool added = false;
    if (state is ConversationGroupsLoaded) {
      newConversationGroup = await conversationGroupAPIService.addConversationGroup(event.conversationGroup);

      if(!isObjectEmpty(newConversationGroup)) {
        added = await conversationGroupDBService.addConversationGroup(newConversationGroup);
        if(added) {
          List<ConversationGroup> existingConversationGroupList = (state as ConversationGroupsLoaded).conversationGroupList;

          existingConversationGroupList.add(newConversationGroup);

          functionCallback(event, newConversationGroup);
          yield ConversationGroupsLoaded(existingConversationGroupList);
        }
      }
    }

    if(isObjectEmpty(newConversationGroup) || !added) {
      functionCallback(event, null);
    }
  }

  Stream<ConversationGroupState> _editConversationGroup(EditConversationGroupEvent event) async* {
    bool updatedInREST = false;
    bool saved = false;
    if (state is ConversationGroupsLoaded) {

      updatedInREST = await conversationGroupAPIService.editConversationGroup(event.conversationGroup);

      if(updatedInREST) {
        saved = await conversationGroupDBService.editConversationGroup(event.conversationGroup);
        if(saved) {
          List<ConversationGroup> existingConversationGroupList = (state as ConversationGroupsLoaded).conversationGroupList;

          existingConversationGroupList
              .removeWhere((ConversationGroup existingConversationGroup) => existingConversationGroup.id == event.conversationGroup.id);

          existingConversationGroupList.add(event.conversationGroup);

          functionCallback(event, event.conversationGroup);
          yield ConversationGroupsLoaded(existingConversationGroupList);
        }
      }
    }

    if(!updatedInREST|| !saved) {
      functionCallback(event, null);
    }
  }

  Stream<ConversationGroupState> _deleteConversationGroup(DeleteConversationGroupEvent event) async* {
    bool deletedInREST = false;
    bool deleted = false;
    if (state is ConversationGroupsLoaded) {

      deletedInREST = await conversationGroupAPIService.deleteConversationGroup(event.conversationGroup.id);

      if(deletedInREST) {
        deleted = await conversationGroupDBService.deleteConversationGroup(event.conversationGroup.id);

        if(deleted) {
          List<ConversationGroup> existingConversationGroupList = (state as ConversationGroupsLoaded).conversationGroupList;

          existingConversationGroupList
              .removeWhere((ConversationGroup existingConversationGroup) => existingConversationGroup.id == event.conversationGroup.id);

          functionCallback(event, true);
          yield ConversationGroupsLoaded(existingConversationGroupList);
        }
      }
    }

    if(!deletedInREST || !deleted) {
      functionCallback(event, false);
    }
  }

  // To send response to those dispatched Actions
  void functionCallback(event, value) {
    if (!isObjectEmpty(event)) {
      event.callback(value);
    }
  }
}
