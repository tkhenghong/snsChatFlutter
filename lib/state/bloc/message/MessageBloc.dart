import 'package:bloc/bloc.dart';
import 'package:snschat_flutter/backend/rest/index.dart';
import 'package:snschat_flutter/database/sembast/index.dart';
import 'package:snschat_flutter/general/functions/validation_functions.dart';
import 'package:snschat_flutter/objects/index.dart';
import 'package:snschat_flutter/state/bloc/message/bloc.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  MessageAPIService messageAPIService = MessageAPIService();
  MessageDBService messageDBService = MessageDBService();

  @override
  MessageState get initialState => MessageLoading();

  @override
  Stream<MessageState> mapEventToState(MessageEvent event) async* {
    if (event is InitializeMessagesEvent) {
      yield* _initializeMessagesToState(event);
    } else if (event is AddMessageToStateEvent) {
      yield* _addMessageToState(event);
    } else if (event is EditMessageToStateEvent) {
      yield* _editMessageToState(event);
    } else if (event is DeleteMessageToStateEvent) {
      yield* _deleteMessageToState(event);
    } else if (event is SendMessageEvent) {
      yield* _sendMessage(event);
    }
  }

  Stream<MessageState> _initializeMessagesToState(InitializeMessagesEvent event) async* {
    try {
      List<Message> messageListFromDB = await messageDBService.getAllMessages();

      print("messageListFromDB.length: " + messageListFromDB.length.toString());

      yield MessagesLoaded(messageListFromDB);

      functionCallback(event, true);
    } catch (e) {
      functionCallback(event, false);
    }
  }

  Stream<MessageState> _addMessageToState(AddMessageToStateEvent event) async* {
    if (state is MessagesLoaded) {
      List<Message> existingMessageList = (state as MessagesLoaded).messageList;

      existingMessageList.removeWhere((Message existingMessage) => existingMessage.id == event.message.id);

      existingMessageList.add(event.message);

      functionCallback(event, event.message);
      yield MessagesLoaded(existingMessageList);
    }
  }

  Stream<MessageState> _editMessageToState(EditMessageToStateEvent event) async* {
    if (state is MessagesLoaded) {
      List<Message> existingMessageList = (state as MessagesLoaded).messageList;

      existingMessageList.removeWhere((Message existingMessage) => existingMessage.id == event.message.id);

      existingMessageList.add(event.message);

      functionCallback(event, event.message);
      yield MessagesLoaded(existingMessageList);
    }
  }

  Stream<MessageState> _deleteMessageToState(DeleteMessageToStateEvent event) async* {
    if (state is MessagesLoaded) {
      List<Message> existingMessageList = (state as MessagesLoaded).messageList;

      existingMessageList.removeWhere((Message existingMessage) => existingMessage.id == event.message.id);

      functionCallback(event, true);
      yield MessagesLoaded(existingMessageList);
    }
  }

  Stream<MessageState> _sendMessage(SendMessageEvent event) async* {
    // TODO: dispatch EditUnreadMessageToEvent to change the current message of the conversationGroup from outside

    Message newMessage = await messageAPIService.addMessage(event.message);

    if (isObjectEmpty(newMessage)) {
      functionCallback(event, false);
    }

    bool messageSaved = await messageDBService.addMessage(newMessage);

    if (!messageSaved) {
      functionCallback(event, false);
    }

    // TODO: Dispatch UploadMultimediaEvent to separate the logic (dispatch it in callback of sendMessageEvent)

    add(AddMessageToStateEvent(message: newMessage, callback: (Message message) {}));
  }

  // To send response to those dispatched Actions
  void functionCallback(event, value) {
    if (!isObjectEmpty(event)) {
      event.callback(value);
    }
  }
}
