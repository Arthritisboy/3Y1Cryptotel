import 'package:flutter/material.dart';
import 'package:hotel_flutter/presentation/widgets/admin/admin_app/creation_content.dart';
import 'package:hotel_flutter/presentation/widgets/admin/admin_app/manage_tab.dart';

class AdminAppnav extends StatefulWidget {
  const AdminAppnav({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AdminAppnavState();
  }
}

class _AdminAppnavState extends State<AdminAppnav> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(
          children: const [
            TabBar(
              tabs: [
                Tab(text: 'Create', icon: Icon(Icons.edit)),
                Tab(text: 'Managers', icon: Icon(Icons.person)),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  CreationContent(),
                  ManagerTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
