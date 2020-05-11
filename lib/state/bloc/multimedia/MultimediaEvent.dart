import 'package:equatable/equatable.dart';
import 'package:snschat_flutter/objects/models/index.dart';

abstract class MultimediaEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];

  const MultimediaEvent();
}

class InitializeMultimediaEvent extends MultimediaEvent {
  final Function callback;

  const InitializeMultimediaEvent({this.callback});

  @override
  String toString() => 'InitializeMultimediaEvent';
}

class AddMultimediaEvent extends MultimediaEvent {
  final Multimedia multimedia;
  final Function callback;

  AddMultimediaEvent({this.multimedia, this.callback});

  @override
  List<Object> get props => [multimedia];

  @override
  String toString() => 'AddMultimediaEvent {multimedia: $multimedia}';
}

class EditMultimediaEvent extends MultimediaEvent {
  final Multimedia multimedia;
  final Function callback;

  EditMultimediaEvent({this.multimedia, this.callback});

  @override
  List<Object> get props => [multimedia];

  @override
  String toString() => 'EditMultimediaEvent {multimedia: $multimedia}';
}

class DeleteMultimediaEvent extends MultimediaEvent {
  final Multimedia multimedia;
  final Function callback;

  DeleteMultimediaEvent({this.multimedia, this.callback});

  @override
  List<Object> get props => [multimedia];

  @override
  String toString() => 'DeleteMultimediaEvent {multimedia: $multimedia}';
}

class SendMultimediaEvent extends MultimediaEvent {
  final Multimedia multimedia;
  final Function callback;

  SendMultimediaEvent({this.multimedia, this.callback});

  @override
  List<Object> get props => [multimedia];

  @override
  String toString() => 'SendMultimediaEvent {multimedia: $multimedia}';
}

class GetUserProfilePictureMultimediaEvent extends MultimediaEvent {
  final User user;
  final Function callback;

  GetUserProfilePictureMultimediaEvent({this.user, this.callback});

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'GetUserProfilePictureMultimediaEvent {user: $user}';
}

class GetConversationGroupsMultimediaEvent extends MultimediaEvent {
  final List<ConversationGroup> conversationGroupList;
  final Function callback;

  GetConversationGroupsMultimediaEvent({this.conversationGroupList, this.callback});

  @override
  List<Object> get props => [conversationGroupList];

  @override
  String toString() => 'GetConversationGroupsMultimediaEvent {conversationGroupList: $conversationGroupList}';
}

class GetUserContactsMultimediaEvent extends MultimediaEvent {
  final List<UserContact> userContactList;
  final Function callback;

  GetUserContactsMultimediaEvent({this.userContactList, this.callback});

  @override
  List<Object> get props => [userContactList];

  @override
  String toString() => 'GetUserContactsMultimediaEvent {userContactList: $userContactList}';
}

class GetMessageMultimediaEvent extends MultimediaEvent {
  final String conversationGroupId;
  final String messageId;
  final Function callback;

  GetMessageMultimediaEvent({this.conversationGroupId, this.messageId, this.callback});

  @override
  List<Object> get props => [messageId, conversationGroupId];

  @override
  String toString() => 'GetMessageMultimediaEvent {messageId: $messageId, conversationGroupId: $conversationGroupId}';
}