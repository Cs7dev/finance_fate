import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class ReorderableCompanyListView extends StatefulWidget {
  const ReorderableCompanyListView({
    super.key,
  });

  @override
  State<ReorderableCompanyListView> createState() =>
      _ReorderableCompanyListViewState();
}

class _ReorderableCompanyListViewState extends State<ReorderableCompanyListView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      upperBound: 1.025,
      lowerBound: 1,
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserListModel>(
      builder: (context, userListModel, child) => ReorderableListView(
        proxyDecorator: (child, index, animation) => ScaleTransition(
          scale: Tween<double>(begin: 1, end: 1.025).animate(
            CurvedAnimation(
              parent: _controller,
              curve: Curves.linear,
            ),
          ),
          child: UserCard(
            userData: userListModel.userAtIndex(index),
          ),
        ),
        onReorder: (oldIndex, newIndex) async {
          // setState(() {
          // These two lines are workarounds for ReorderableListView problems
          // Source: https://stackoverflow.com/questions/54162721/onreorder-arguments-in-flutter-reorderablelistview?newreg=398dc3a491ee40fbad1b76ab1e303977
          if (newIndex > userListModel.length()) {
            newIndex = userListModel.length();
          }
          if (oldIndex < newIndex) newIndex--;
          UserData user = userListModel.userAtIndex(oldIndex);
          // Remove from the application list
          userListModel.deleteUser(user);
          userListModel.insertUser(newIndex, user);
          // });
          userListModel.refreshListOrder();
          await userListModel.syncDatabase();
        },
        children: [
          for (int index = 0; index < userListModel.length(); ++index)
            OpenContainer(
              key: UniqueKey(),
              openBuilder: (context, action) => UserView(
                userData: userListModel.userAtIndex(index),
              ),
              closedBuilder: (context, action) => DismissibleListTile(
                userData: userListModel.userAtIndex(index),
              ),
            ),
        ],
      ),
    );
  }
}

class DismissibleListTile extends StatelessWidget {
  const DismissibleListTile({
    super.key,
    required this.userData,
  });

  final UserData userData;

  @override
  Widget build(BuildContext context) {
    bool removed = false;

    return Consumer<UserListModel>(
      builder: (context, userListModel, child) => Dismissible(
        background: const DismissableBackground(
          alignment: AlignmentDirectional.centerStart,
        ),
        secondaryBackground: const DismissableBackground(
          alignment: AlignmentDirectional.centerEnd,
        ),
        onUpdate: (details) {
          if (!details.previousReached && details.reached) {
            HapticFeedback.lightImpact();
          }
        },
        dismissThresholds: const {DismissDirection.horizontal: 0.45},
        onDismissed: (DismissDirection direction) async {
          userListModel.deleteUser(userData);
          removed = true;
          int index = userData.listOrder!;
          if (context.mounted) {
            // Cannot add both, flexibility to insert back at same index
            // and option to stack undo users due to indexing conflict
            // e.g. Delete user at index 5 in a list of size 6 and then delete 2 more users
            // Since list size is now smaller than initial index, exception is thrown

            SnackBar undoDeleteSnack = SnackBar(
              duration: const Duration(seconds: 6),
              content: Text.rich(
                TextSpan(
                  text: 'User ',
                  children: [
                    TextSpan(
                      text: userData.nickname ?? userData.username,
                    ),
                    const TextSpan(text: ' removed from list'),
                  ],
                ),
              ),
              action: SnackBarAction(
                label: 'Undo?',
                onPressed: () {
                  userListModel.insertUser(index, userData);
                  removed = false;
                },
              ),
            );

            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldFeatureController<SnackBar, SnackBarClosedReason> sfc =
                ScaffoldMessenger.of(context).showSnackBar(undoDeleteSnack);

            await sfc.closed;
          }

          if (removed) {
            UserDatabase.delete(userData);
            userListModel.refreshListOrder();
            await userListModel.syncDatabase();
          }
        },
        key: UniqueKey(),
        child: UserCard(userData: userData),
      ),
    );
  }
}

class DismissableBackground extends StatelessWidget {
  const DismissableBackground({
    super.key,
    this.alignment,
  });

  final AlignmentGeometry? alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.black
          : Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 24),
      alignment: alignment,
      child: const Icon(Icons.delete),
    );
  }
}
