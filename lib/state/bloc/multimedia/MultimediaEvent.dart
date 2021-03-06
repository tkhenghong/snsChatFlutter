import 'package:equatable/equatable.dart';
import 'package:snschat_flutter/objects/models/index.dart';

abstract class MultimediaEvent extends Equatable {
  @override
  List<Object> get props => [];

  const MultimediaEvent();
}

class InitializeMultimediaEvent extends MultimediaEvent {
  final Function callback;

  const InitializeMultimediaEvent({this.callback});

  @override
  String toString() => 'InitializeMultimediaEvent';
}

class UpdateMultimediaEvent extends MultimediaEvent {
  final Multimedia multimedia;
  final Function callback;

  UpdateMultimediaEvent({this.multimedia, this.callback});

  @override
  List<Object> get props => [];

  @override
  String toString() => 'UpdateMultimediaEvent {multimedia: $multimedia}';
}


class UpdateMultimediaListEvent extends MultimediaEvent {
  final List<Multimedia> multimediaList;
  final Function callback;

  UpdateMultimediaListEvent({this.multimediaList, this.callback});

  @override
  List<Object> get props => [];

  @override
  String toString() => 'UpdateMultimediaListEvent {multimediaList: $multimediaList}';
}

class GetUserOwnProfilePictureMultimediaEvent extends MultimediaEvent {
  final String ownUserContactMultimediaId;
  final Function callback;

  GetUserOwnProfilePictureMultimediaEvent({this.ownUserContactMultimediaId, this.callback});

  @override
  List<Object> get props => [];

  @override
  String toString() => 'GetUserProfilePictureMultimediaEvent {ownUserContactMultimediaId: $ownUserContactMultimediaId}';
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

class GetMessagesMultimediaEvent extends MultimediaEvent {
  final List<ChatMessage> chatMessageList;
  final Function callback;

  GetMessagesMultimediaEvent({this.chatMessageList, this.callback});

  @override
  List<Object> get props => [chatMessageList];

  @override
  String toString() => 'GetMessageMultimediaEvent {chatMessageList: $chatMessageList}';
}

class RemoveAllMultimediaEvent extends MultimediaEvent {
  final Function callback;

  RemoveAllMultimediaEvent({this.callback});

  @override
  List<Object> get props => [];

  @override
  String toString() => 'RemoveAllMultimediaEvent {}';
}
