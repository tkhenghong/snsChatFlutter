// No enum in Dart native yet

class ConversationGroup {
  // Single conversation, group conversation & broadcast channel
  String id;
  String creatorUserId;
  String createdDate;
  String name;
  String type;
  String description;
  List<String> memberIds;
  bool block;
  int notificationExpireDate; // 0 = unblocked, > 0 = blocked until specific time
  String timestamp;

  ConversationGroup(
      {this.id,
      this.creatorUserId,
      this.createdDate,
      this.name,
      this.type,
      this.block,
      this.description,
      this.memberIds,
      this.notificationExpireDate,
      this.timestamp});

  // fromMap in SembastDB tutorial
  ConversationGroup.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        creatorUserId = json['creatorUserId'],
        createdDate = json['createdDate'],
        name = json['name'],
        type = json['type'],
        block = json['block'],
        description = json['description'],
        memberIds = json['memberIds'],
        notificationExpireDate = json['notificationExpireDate'],
        timestamp = json['timestamp'];

  // toMap in SembastDB Tutorial
  Map<String, dynamic> toJson() => {
        'id': id,
        'creatorUserId': creatorUserId,
        'createdDate': createdDate,
        'name': name,
        'type': type,
        'block': block,
        'description': description,
        'memberIds': memberIds,
        'notificationExpireDate': notificationExpireDate,
        'timestamp': timestamp,
      };
}

// Save the message using files as backup, normally just save the conversations' messages in Message table
// Update lastseen if single conversation, Update members and how many people online if group conversation, update subscribers if broadcast
