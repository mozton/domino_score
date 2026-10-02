import 'package:dominos_score/core/network/firestore_rest_client.dart';
import 'package:dominos_score/features/groups/data/datasources/group_remote_data_source.dart';
import 'package:dominos_score/features/groups/data/models/group_member_model.dart';
import 'package:dominos_score/features/groups/data/models/group_model.dart';
import 'package:dominos_score/features/groups/domain/entities/group_entity.dart';
import 'package:dominos_score/features/groups/domain/entities/group_member_entity.dart';

class GroupRemoteDataSourceImpl implements GroupRemoteDataSource {
  static const _collection = 'groups';

  final FirestoreRestClient _client;

  GroupRemoteDataSourceImpl(this._client);

  String _membersPath(String groupId) => '$_collection/$groupId/members';

  @override
  Future<Group> createGroup(Group group, GroupMember owner) async {
    await _client.setDocument(
      '$_collection/${group.id}',
      GroupModel.toMap(group),
    );
    await upsertMember(group.id, owner);
    return group;
  }

  @override
  Future<Group?> getGroup(String groupId) async {
    final doc = await _client.getDocument('$_collection/$groupId');
    if (doc == null) return null;
    return GroupModel.fromMap(doc.id, doc.data);
  }

  @override
  Future<Group?> findByJoinCode(String joinCode) async {
    final docs = await _client.runQuery(
      collectionId: _collection,
      where: FirestoreFilter.equal('joinCode', joinCode),
      limit: 1,
    );
    if (docs.isEmpty) return null;
    return GroupModel.fromMap(docs.first.id, docs.first.data);
  }

  @override
  Future<List<Group>> getGroupsByMember(String userId) async {
    final docs = await _client.runQuery(
      collectionId: _collection,
      where: FirestoreFilter.arrayContains('memberIds', userId),
    );
    return docs.map((d) => GroupModel.fromMap(d.id, d.data)).toList();
  }

  @override
  Future<Group> updateGroup(Group group) async {
    await _client.setDocument(
      '$_collection/${group.id}',
      GroupModel.toMap(group),
    );
    return group;
  }

  @override
  Future<void> deleteGroup(String groupId) async {
    final members = await getMembers(groupId);
    for (final member in members) {
      await deleteMember(groupId, member.userId);
    }
    await _client.deleteDocument('$_collection/$groupId');
  }

  @override
  Future<List<GroupMember>> getMembers(String groupId) async {
    final docs = await _client.listDocuments(_membersPath(groupId));
    return docs.map((d) => GroupMemberModel.fromMap(d.id, d.data)).toList();
  }

  @override
  Future<void> upsertMember(String groupId, GroupMember member) async {
    await _client.setDocument(
      '${_membersPath(groupId)}/${member.userId}',
      GroupMemberModel.toMap(member),
    );
  }

  @override
  Future<void> deleteMember(String groupId, String userId) async {
    await _client.deleteDocument('${_membersPath(groupId)}/$userId');
  }
}
