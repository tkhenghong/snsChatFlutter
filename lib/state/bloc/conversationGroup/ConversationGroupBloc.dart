import 'package:snschat_flutter/database/sembast/index.dart';
import 'package:snschat_flutter/general/functions/validation_functions.dart';
import 'package:snschat_flutter/objects/index.dart';

import 'bloc.dart';
import 'package:bloc/bloc.dart';

// Idea from Official Documentation. Link: https://bloclibrary.dev/#/fluttertodostutorial
class ConversationGroupBloc extends Bloc<ConversationGroupEvent, ConversationGroupState> {
  ConversationDBService conversationGroupDBService = new ConversationDBService();

  @override
  ConversationGroupState get initialState => ConversationGroupsLoading();

  @override
  Stream<ConversationGroupState> mapEventToState(ConversationGroupEvent event) async* {
    // TODO: implement mapEventToState
    if (event is InitializeConversationGroupsEvent) {
      yield* _mapInitializeConversationGroupToState(event);
    } else if (event is AddConversationGroupToStateEvent) {
      yield* _addConversationGroupToState(event);
    } else if (event is EditConversationGroupEvent) {
      yield* _editConversationGroupToState(event);
    } else if (event is DeleteConversationGroupEvent) {
      yield* _deleteConversationGroupToState(event);
    } else if (event is CreateConversationGroupEvent) {
      yield* _createConversationGroup(event);
    }
  }

  Stream<ConversationGroupState> _mapInitializeConversationGroupToState(InitializeConversationGroupsEvent event) async* {
    try {
      List<ConversationGroup> conversationGroupListFromDB = await conversationGroupDBService.getAllConversationGroups();

      print("conversationGroupListFromDB.length: " + conversationGroupListFromDB.length.toString());

      yield ConversationGroupsLoaded(conversationGroupListFromDB);

      functionCallback(event, true);
    } catch (e) {
      functionCallback(event, false);
    }
  }

  Stream<ConversationGroupState> _addConversationGroupToState(AddConversationGroupToStateEvent event) async* {
    if (state is ConversationGroupsLoaded) {
      List<ConversationGroup> existingConversationGroupList = (state as ConversationGroupsLoaded).conversationGroupList;

      existingConversationGroupList
          .removeWhere((ConversationGroup existingConversationGroup) => existingConversationGroup.id == event.conversationGroup.id);

      existingConversationGroupList.add(event.conversationGroup);

      yield ConversationGroupsLoaded(existingConversationGroupList);
    }
  }

  Stream<ConversationGroupState> _editConversationGroupToState(EditConversationGroupEvent event) async* {
    if (state is ConversationGroupsLoaded) {
      List<ConversationGroup> existingConversationGroupList = (state as ConversationGroupsLoaded).conversationGroupList;

      existingConversationGroupList
          .removeWhere((ConversationGroup existingConversationGroup) => existingConversationGroup.id == event.conversationGroup.id);

      existingConversationGroupList.add(event.conversationGroup);

      yield ConversationGroupsLoaded(existingConversationGroupList);
    }
  }

  Stream<ConversationGroupState> _deleteConversationGroupToState(DeleteConversationGroupEvent event) async* {
    if (state is ConversationGroupsLoaded) {
      List<ConversationGroup> existingConversationGroupList = (state as ConversationGroupsLoaded).conversationGroupList;

      existingConversationGroupList
          .removeWhere((ConversationGroup existingConversationGroup) => existingConversationGroup.id == event.conversationGroup.id);

      yield ConversationGroupsLoaded(existingConversationGroupList);
    }
  }

  Stream<ConversationGroupState> _createConversationGroup(CreateConversationGroupEvent event) async* {
    // TODO: Add all other objects first

    UserContact yourOwnUserContact = UserContact(
      id: null,
      // userIds: Which User owns this UserContact
      userIds: [currentState.userState.id],
      displayName: currentState.userState.displayName,
      realName: currentState.userState.realName,
      block: false,
      lastSeenDate: new DateTime.now().millisecondsSinceEpoch,
      // make unknown time, let server decide
      mobileNo: currentState.userState.mobileNo,
    );

    List<ConversationGroup> existingConversationGroupList = (state as ConversationGroupsLoaded).conversationGroupList;

    yield ConversationGroupsLoaded(existingConversationGroupList);
  }

  // To send response to those dispatched Actions
  void functionCallback(event, value) {
    if (!isObjectEmpty(event)) {
      event.callback(value);
    }
  }
}
