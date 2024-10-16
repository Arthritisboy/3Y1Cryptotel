import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hotel_flutter/data/model/booking/booking_model.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_bloc.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_event.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_state.dart';
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
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  String? handleId;

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    try {
      handleId = await _secureStorage.read(key: 'handleId');
      if (handleId != null) {
        context.read<BookingBloc>().add(FetchBookings(userId: handleId!));
      }
    } catch (e) {}
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

  List<BookingModel> _filterBookings(BookingState state, String status) {
    if (state is BookingSuccess) {
      return state.bookings
          .where((b) => b.status?.toLowerCase() == status)
          .toList();
    }
    return [];
  }
}
