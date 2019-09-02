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
  List<String> adminMemberIds;
  bool block;
  int notificationExpireDate; // 0 = unblocked, > 0 = blocked until specific time

  // Add groupAdmin List<String>

  ConversationGroup(
      {this.id,
      this.creatorUserId,
      this.createdDate,
      this.name,
      this.type,
      this.block,
      this.description,
      this.memberIds,
      this.adminMemberIds,
      this.notificationExpireDate});

  // fromMap in SembastDB tutorial
  factory ConversationGroup.fromJson(Map<String, dynamic> json) {
    ConversationGroup conversationGroup = new ConversationGroup(
        id: json['id'],
        creatorUserId: json['creatorUserId'],
        createdDate: json['createdDate'],
        name: json['name'],
        type: json['type'],
        block: json['block'],
        description: json['description'],
//        memberIds: json['memberIds'],
//        adminMemberIds: json['adminMemberIds'],
        notificationExpireDate: json['notificationExpireDate']);

    // ****Special case: For Lists, you need to convert memberIds and adminMemberIds from List<dynamic> to List<String>****
    var memberIdsFromJson = json['memberIds'];
    var adminMemberIdsFromJson = json['adminMemberIds'];

    List<String> memberIds = new List<String>.from(memberIdsFromJson);
    List<String> adminMemberIds = new List<String>.from(adminMemberIdsFromJson);
    conversationGroup.memberIds = memberIds;
    conversationGroup.adminMemberIds = adminMemberIds;

    return conversationGroup;
  }

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
        'adminMemberIds': adminMemberIds,
        'notificationExpireDate': notificationExpireDate,
      };
}

// Save the message using files as backup, normally just save the conversations' messages in Message table
// Update lastseen if single conversation, Update members and how many people online if group conversation, update subscribers if broadcast
