import 'package:bluu/pages/callscreens/pickup/pickup_layout.dart';
import 'package:bluu/pages/pageviews/chat_lists/widgets/new_chat_button.dart';
import 'package:bluu/pages/pageviews/group_lists/widgets/group_list_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bluu/models/group.dart';
import 'package:bluu/provider/user_provider.dart';
import 'package:bluu/resources/group_methods.dart';
import 'package:bluu/widgets/quiet_box.dart';
import 'package:bluu/utils/universal_variables.dart';

class GroupListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        body: GroupListContainer(),
        floatingActionButton: NewGroupButton(),
      ),
    );
  }
}

class GroupListContainer extends StatelessWidget {
  final GroupMethods _groupMethods = GroupMethods();

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: _groupMethods.fetchGroups(
            userId: userProvider.getUser.uid,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var docList = snapshot.data.documents;
             
              if (docList.isEmpty) {
                return GroupQuietBox();
              }
              return ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: docList.length,
                itemBuilder: (context, index) {
                  Group group = Group.fromMap(docList[index].data, docList[index].documentID);

                  return GroupListView(group);
                },
              );
            }

            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
