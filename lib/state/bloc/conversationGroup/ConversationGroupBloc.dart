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
    if (event is LoadConversationGroupsEvent) {
      yield* _loadConversationGroups(event);
    } else if (event is AddConversationGroupEvent) {
      yield* _addConversationGroup(event);
    } else if (event is EditConversationGroupEvent) {
      yield* _editConversationGroup(event);
    } else if (event is UpdateConversationGroupEvent) {
      yield* _updateConversationGroup(event);
    } else if (event is DeleteConversationGroupEvent) {
      yield* _deleteConversationGroup(event);
    } else if (event is GetUserOwnConversationGroupsEvent) {
      yield* _getUserOwnConversationGroups(event);
    } else if (event is AddGroupMembersEvent) {
      yield* _addGroupMember(event);
    } else if (event is CreateConversationGroupEvent) {
      yield* _createConversationGroup(event);
    } else if (event is GetSingleConversationGroupEvent) {
      yield* _getSingleConversationGroup(event);
    } else if (event is RemoveConversationGroupsEvent) {
      yield* _removeAllConversationGroups(event);
    }
  }

  Stream<ConversationGroupState> _loadConversationGroups(LoadConversationGroupsEvent event) async* {
    try {
      List<ConversationGroup> conversationGroupListFromDB = await conversationGroupDBService.getAllConversationGroupsWithPagination(event.page, event.size);
      yield ConversationGroupsLoaded(conversationGroupListFromDB);
      functionCallback(event, true);
    } catch (e) {
      yield ConversationGroupsNotLoaded();
      functionCallback(event, false);
    }
  }

  // Add Conversation Group to LocalDB and State
  Stream<ConversationGroupState> _addConversationGroup(AddConversationGroupEvent event) async* {
    ConversationGroup conversationGroupFromServer;
    bool added = false;
    try {
      if (state is ConversationGroupsLoaded) {
        if (!isObjectEmpty(event.createConversationGroupRequest)) {
          conversationGroupFromServer = await conversationGroupAPIService.addConversationGroup(event.createConversationGroupRequest);
          if (!isObjectEmpty(conversationGroupFromServer)) {
            added = await conversationGroupDBService.addConversationGroup(conversationGroupFromServer);

            if (added) {
              yield* updateConversationGroupsLoadedState(conversationGroup: conversationGroupFromServer);
              functionCallback(event, conversationGroupFromServer);
            } else {
              added = false;
            }
          }
        }
      }
    } catch (e) {
      added = false;
      functionCallback(event, null);
    }

    if (isObjectEmpty(conversationGroupFromServer) || !added) {
      showToast('Unable to add conversation group. Please try again later.', Toast.LENGTH_LONG);
      functionCallback(event, null);
    }
  }

  /// Add ConversationGroup object to state and DB.
  Stream<ConversationGroupState> _updateConversationGroup(UpdateConversationGroupEvent event) async* {
    try {
      conversationGroupDBService.addConversationGroup(event.conversationGroup);
      yield* updateConversationGroupsLoadedState(conversationGroup: event.conversationGroup);
      functionCallback(event, true);
    } catch (e) {
      showToast('Unable to add conversation group into the database. Please try again.', Toast.LENGTH_SHORT, toastGravity: ToastGravity.CENTER);
      functionCallback(event, false);
    }
  }

  Stream<ConversationGroupState> _editConversationGroup(EditConversationGroupEvent event) async* {
    ConversationGroup updatedConversationGroup;
    bool saved = false;
    try {
      if (state is ConversationGroupsLoaded) {
        updatedConversationGroup = await conversationGroupAPIService.editConversationGroup(event.editConversationGroupRequest);

        if (!isObjectEmpty(updatedConversationGroup)) {
          saved = await conversationGroupDBService.editConversationGroup(updatedConversationGroup);
          if (saved) {
            yield* updateConversationGroupsLoadedState(conversationGroup: updatedConversationGroup);
            functionCallback(event, updatedConversationGroup);
          }
        }
      }
    } catch (e) {
      saved = false;
    }

    if (isObjectEmpty(updatedConversationGroup) || !saved) {
      showToast('Unable to update conversation group. Please try again later.', Toast.LENGTH_LONG);
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
    try {
      if (state is ConversationGroupsLoaded) {
        deletedInREST = await conversationGroupAPIService.deleteConversationGroup(event.conversationGroup.id);

        if (deletedInREST) {
          deleted = await conversationGroupDBService.deleteConversationGroup(event.conversationGroup.id);

          if (deleted) {
            List<ConversationGroup> existingConversationGroupList = (state as ConversationGroupsLoaded).conversationGroupList;
            int totalConversationGroups = (state as ConversationGroupsLoaded).totalConversationGroups;

            existingConversationGroupList.removeWhere((ConversationGroup existingConversationGroup) => existingConversationGroup.id == event.conversationGroup.id);

            yield ConversationGroupsLoaded(existingConversationGroupList, totalConversationGroups);
            functionCallback(event, true);
          }
        }
      }
    } catch (e) {
      deleted = false;
    }

    if (!deletedInREST || !deleted) {
      functionCallback(event, false);
    }
  }

  Stream<ConversationGroupState> _getUserOwnConversationGroups(GetUserOwnConversationGroupsEvent event) async* {
    try {
      ConversationPageableResponse conversationPageableResponse = await conversationGroupAPIService.getUserOwnConversationGroups(event.getConversationGroupsRequest);
      if (!isObjectEmpty(conversationPageableResponse) && !isObjectEmpty(conversationPageableResponse.conversationGroupResponses.content) && conversationPageableResponse.conversationGroupResponses.content.isNotEmpty) {
        List<ConversationGroup> conversationGroupList = conversationPageableResponse.conversationGroupResponses.content.map((e) => ConversationGroup.fromJson(e)).toList();

        conversationGroupDBService.addConversationGroups(conversationGroupList);

        yield* updateConversationGroupsLoadedState(conversationPageableResponse: conversationPageableResponse);
        functionCallback(event, conversationPageableResponse);
      } else {
        yield* updateConversationGroupsLoadedState(updatedConversationGroupList: []);
        functionCallback(event, null);
      }
    } catch (e) {
      GetConversationGroupsRequest getConversationGroupsRequest = event.getConversationGroupsRequest;
      int page = getConversationGroupsRequest.pageable.page;
      int size = getConversationGroupsRequest.pageable.size;
      add(LoadConversationGroupsEvent(
          page: page,
          size: size,
          callback: (bool done) {
            functionCallback(event, null);
          }));
      showToast('Failed to get conversation groups. Please try again later.', Toast.LENGTH_LONG);
      functionCallback(event, null);
    }
  }

  Stream<ConversationGroupState> _addGroupMember(AddGroupMembersEvent event) async* {
    bool updated = false;
    try {
      if (state is ConversationGroupsLoaded) {
        List<ConversationGroup> conversationGroupList = (state as ConversationGroupsLoaded).conversationGroupList;

        ConversationGroup conversationGroup = conversationGroupList.firstWhere((ConversationGroup existingConversationGroup) {
          return existingConversationGroup.id == event.conversationGroupId;
        }, orElse: () => null);
        conversationGroup.memberIds.addAll(event.userContactIds);

        ConversationGroup updatedConversationGroup = await conversationGroupAPIService.addConversationGroupMember(event.conversationGroupId, AddConversationGroupMemberRequest(groupMemberIds: event.userContactIds));

        updated = await conversationGroupDBService.editConversationGroup(updatedConversationGroup);

        if (updated) {
          yield* updateConversationGroupsLoadedState(conversationGroup: updatedConversationGroup);
          functionCallback(event, updatedConversationGroup);
        }
      }
    } catch (e) {
      updated = false;
    }

    if (!updated) {
      showToast('Unable to add group members. Please try again later.', Toast.LENGTH_LONG);
      functionCallback(event, null);
    }
  }

  Stream<ConversationGroupState> _createConversationGroup(CreateConversationGroupEvent event) async* {
    CreateConversationGroupRequest createConversationGroupRequest = event.createConversationGroupRequest;

    ConversationGroup conversationGroup;

    try {
      // Check Personal conversation group duplication.
      if (event.createConversationGroupRequest.conversationGroupType == ConversationGroupType.Personal) {
        conversationGroup = await conversationGroupDBService.getConversationGroupWithTypeAndMembers(event.createConversationGroupRequest.conversationGroupType, event.createConversationGroupRequest.memberIds);
      }

      if (isObjectEmpty(conversationGroup)) {
        conversationGroup = await conversationGroupAPIService.addConversationGroup(createConversationGroupRequest);

        if (isObjectEmpty(conversationGroup)) {
          throw Exception("Failed when creating conversation Group. Please try again.");
        }

        bool savedIntoDB = await conversationGroupDBService.addConversationGroup(conversationGroup);

        if (!savedIntoDB) {
          throw Exception("Failed when saving conversation Group into the DB. Please try again.");
        }

        if (!(state is ConversationGroupsLoaded)) {
          throw Exception("Failed when saving conversation Group: conversationGroupState is not ready. Please restart the application.");
        }

        yield* updateConversationGroupsLoadedState(conversationGroup: conversationGroup);
      }
      functionCallback(event, conversationGroup);
    } catch (e) {
      showToast('Failed to load a conversation. Please try again later.', Toast.LENGTH_LONG);
      functionCallback(event, null);
    }
  }

  /// Get & Update a single Conversation group from local DB & backend.
  Stream<ConversationGroupState> _getSingleConversationGroup(GetSingleConversationGroupEvent event) async* {
    try {
      ConversationGroup conversationGroupFromDB = await conversationGroupDBService.getSingleConversationGroup(event.conversationGroupId);

      yield* updateConversationGroupsLoadedState(conversationGroup: conversationGroupFromDB);
      ConversationGroup conversationGroupFromServer = await conversationGroupAPIService.getSingleConversationGroup(event.conversationGroupId);
      yield* updateConversationGroupsLoadedState(conversationGroup: conversationGroupFromServer);
      functionCallback(event, conversationGroupFromServer);
    } catch (e) {
      showToast('Failed to get latest info of the conversation group. Please try again.later.', Toast.LENGTH_LONG);
      functionCallback(event, null);
    }
  }

  Stream<ConversationGroupState> _removeAllConversationGroups(RemoveConversationGroupsEvent event) async* {
    conversationGroupDBService.deleteAllConversationGroups();
    yield ConversationGroupsNotLoaded();
    functionCallback(event, true);
  }

  /// Add single ConversationGroup object or List of ConversationGroup.
  Stream<ConversationGroupState> updateConversationGroupsLoadedState({ConversationPageableResponse conversationPageableResponse, List<ConversationGroup> updatedConversationGroupList, ConversationGroup conversationGroup}) async* {
    if (state is ConversationGroupsLoaded) {
      ConversationGroupsLoaded currentState = (state as ConversationGroupsLoaded);
      List<ConversationGroup> existingConversationGroupList = currentState.conversationGroupList;
      int totalConversationGroups = currentState.totalConversationGroups;

      if (!isObjectEmpty(conversationPageableResponse)) {
        if (!isObjectEmpty(conversationPageableResponse.conversationGroupResponses)) {
          updatedConversationGroupList = conversationPageableResponse.conversationGroupResponses.content.map((e) => ConversationGroup.fromJson(e)).toList();
          existingConversationGroupList.addAll(updatedConversationGroupList);
        }

        // Update total conversation groups from backend.
        totalConversationGroups = conversationPageableResponse.conversationGroupResponses.totalElements;
      }

      if (!isObjectEmpty(conversationGroup)) {
        existingConversationGroupList.removeWhere((existingConversationGroup) => existingConversationGroup.id == conversationGroup.id);

        existingConversationGroupList.add(conversationGroup);
      }

      if (!isObjectEmpty(updatedConversationGroupList)) {
        updatedConversationGroupList.forEach((updatedConversationGroup) {
          existingConversationGroupList.removeWhere((existingConversationGroup) => existingConversationGroup.id == updatedConversationGroup.id);
        });

        existingConversationGroupList.addAll(updatedConversationGroupList);
      }

      yield ConversationGroupsLoading();
      yield ConversationGroupsLoaded(existingConversationGroupList, totalConversationGroups);
    } else {
      List<ConversationGroup> existingConversationGroupList = [];
      int totalConversationGroups = 0;
      if (!isObjectEmpty(conversationPageableResponse)) {
        if (!isObjectEmpty(conversationPageableResponse.conversationGroupResponses)) {
          existingConversationGroupList = conversationPageableResponse.conversationGroupResponses.content.map((e) => ConversationGroup.fromJson(e)).toList();
        }

        totalConversationGroups = conversationPageableResponse.conversationGroupResponses.totalElements;
      }

      if (!isObjectEmpty(updatedConversationGroupList)) {
        updatedConversationGroupList.forEach((updatedConversationGroup) {
          existingConversationGroupList.removeWhere((existingConversationGroup) => existingConversationGroup.id == updatedConversationGroup.id);
        });
        existingConversationGroupList.addAll(updatedConversationGroupList);
      }

      if (!isObjectEmpty(conversationGroup)) {
        existingConversationGroupList.removeWhere((existingConversationGroup) => existingConversationGroup.id == conversationGroup.id);
        existingConversationGroupList.add(conversationGroup);
      }

      yield ConversationGroupsLoaded(existingConversationGroupList, totalConversationGroups);
    }
  }

  void functionCallback(event, value) {
    if (!isObjectEmpty(event) && !isObjectEmpty(event.callback)) {
      event.callback(value);
    }
  }
}
