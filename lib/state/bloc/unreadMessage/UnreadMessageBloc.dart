import 'package:bloc/bloc.dart';
import 'package:get/get.dart';
import 'package:snschat_flutter/database/sembast/index.dart';
import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/rest/index.dart';
import 'package:snschat_flutter/state/bloc/unreadMessage/bloc.dart';

class UnreadMessageBloc extends Bloc<UnreadMessageEvent, UnreadMessageState> {
  UnreadMessageBloc() : super(UnreadMessageLoading());

  UnreadMessageAPIService unreadMessageAPIService = Get.find();
  UnreadMessageDBService unreadMessageDBService = Get.find();

  @override
  Stream<UnreadMessageState> mapEventToState(UnreadMessageEvent event) async* {
    if (event is LoadUnreadMessagesEvent) {
      yield* _loadUnreadMessages(event);
    } else if (event is UpdateUnreadMessageEvent) {
      yield* _updateUnreadMessageEvent(event);
    } else if (event is DeleteUnreadMessageEvent) {
      yield* _deleteUnreadMessage(event);
    } else if (event is GetUnreadMessageByConversationGroupIdEvent) {
      yield* _geUnreadMessageByConversationGroupId(event);
    } else if (event is UpdateUnreadMessagesEvent) {
      yield* _updateUnreadMessages(event);
    } else if (event is RemoveAllUnreadMessagesEvent) {
      yield* _removeAllUnreadMessagesEvent(event);
    }
  }

  /// Not loading all UnreadMessage from state
  /// Only gets unreadMessage when necessary
  Stream<UnreadMessageState> _loadUnreadMessages(LoadUnreadMessagesEvent event) async* {
    try {
      List<UnreadMessage> unreadMessageList = await unreadMessageDBService.getUnreadMessages(event.unreadMessageIds);
      yield UnreadMessagesLoaded(unreadMessageList);
      functionCallback(event, true);
    } catch (e) {
      yield UnreadMessagesNotLoaded();
      functionCallback(event, false);
    }
  }

  /// Update single UnreadMessage object in localDB and State.
  Stream<UnreadMessageState> _updateUnreadMessageEvent(UpdateUnreadMessageEvent event) async* {
    try {
      await unreadMessageDBService.addUnreadMessage(event.unreadMessage);

      if (state is UnreadMessagesLoaded) {
        yield* yieldUnreadMessageLoadedState(updatedUnreadMessage: event.unreadMessage);
        functionCallback(event, true);
      }
    } catch (e) {
      functionCallback(event, false);
    }
  }

  Stream<UnreadMessageState> _deleteUnreadMessage(DeleteUnreadMessageEvent event) async* {
    try {
      await unreadMessageDBService.deleteUnreadMessage(event.unreadMessageId);

      if (state is UnreadMessagesLoaded) {
        UnreadMessagesLoaded currentState = state as UnreadMessagesLoaded;
        List<UnreadMessage> existingUnreadMessageList = currentState.unreadMessageList;
        existingUnreadMessageList.removeWhere((UnreadMessage existingUnreadMessage) => existingUnreadMessage.id == event.unreadMessageId);

        yield UnreadMessageLoading();
        yield UnreadMessagesLoaded(existingUnreadMessageList);
        functionCallback(event, true);
      }
    } catch (e) {
      functionCallback(event, false);
    }
  }

  Stream<UnreadMessageState> _geUnreadMessageByConversationGroupId(GetUnreadMessageByConversationGroupIdEvent event) async* {
    try {
      UnreadMessage unreadMessage;

      unreadMessage = await unreadMessageDBService.getUnreadMessageOfAConversationGroup(event.conversationGroupId);

      if (isObjectEmpty(unreadMessage)) {
        unreadMessage = await unreadMessageAPIService.geUnreadMessageByConversationGroupId(event.conversationGroupId);
      }

      if (!isObjectEmpty(unreadMessage)) {
        unreadMessageDBService.addUnreadMessage(unreadMessage);
      }

      yield* yieldUnreadMessageLoadedState(updatedUnreadMessage: unreadMessage);
      functionCallback(event, unreadMessage);
    } catch (e) {
      functionCallback(event, null);
    }
  }

  /// Update a list of UnreadMessage objects into State and Local DB.
  Stream<UnreadMessageState> _updateUnreadMessages(UpdateUnreadMessagesEvent event) async* {
    try {
      unreadMessageDBService.addUnreadMessages(event.unreadMessages);

      yield* yieldUnreadMessageLoadedState(updatedUnreadMessageList: event.unreadMessages);
      functionCallback(event, true);
    } catch (e) {
      functionCallback(event, false);
    }
  }

  Stream<UnreadMessageState> _removeAllUnreadMessagesEvent(RemoveAllUnreadMessagesEvent event) async* {
    unreadMessageDBService.deleteAllUnreadMessage();
    yield UnreadMessagesNotLoaded();
    functionCallback(event, true);
  }

  Stream<UnreadMessageState> yieldUnreadMessageLoadedState({List<UnreadMessage> updatedUnreadMessageList, UnreadMessage updatedUnreadMessage}) async* {
    if (state is UnreadMessagesLoaded) {
      UnreadMessagesLoaded currentState = state as UnreadMessagesLoaded;
      List<UnreadMessage> existingUnreadMessageList = currentState.unreadMessageList;

      if (!isObjectEmpty(updatedUnreadMessageList)) {
        updatedUnreadMessageList.forEach((element) {
          existingUnreadMessageList.removeWhere((existingUnreadMessage) => element.id == existingUnreadMessage.id);
        });

        existingUnreadMessageList.addAll(updatedUnreadMessageList);
      }

      if (!isObjectEmpty(updatedUnreadMessage)) {
        existingUnreadMessageList.removeWhere((element) => element.id == updatedUnreadMessage.id);
        existingUnreadMessageList.add(updatedUnreadMessage);
      }

      yield UnreadMessageLoading();
      yield UnreadMessagesLoaded(existingUnreadMessageList);
    } else {
      List<UnreadMessage> existingUnreadMessageList = [];
      if (!isObjectEmpty(updatedUnreadMessageList)) {
        existingUnreadMessageList.addAll(updatedUnreadMessageList);
      }

      if (!isObjectEmpty(updatedUnreadMessage)) {
        existingUnreadMessageList.removeWhere((element) => element.id == updatedUnreadMessage.id);
        existingUnreadMessageList.add(updatedUnreadMessage);
      }
      yield UnreadMessagesLoaded(existingUnreadMessageList);
    }
  }

  void functionCallback(event, value) {
    if (!isObjectEmpty(event) && !isObjectEmpty(event.callback)) {
      event.callback(value);
    }
  }
}
