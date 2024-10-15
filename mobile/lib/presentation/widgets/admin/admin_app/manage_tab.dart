import 'package:flutter/material.dart';

class ManagerTab extends StatelessWidget {
  const ManagerTab({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> managers = [
      {
        'name': 'John Doe',
        'role': 'Manager',
        'handled': 'The Grand Hotel',
      },
      {
        'name': 'Jane Smith',
        'role': 'Manager',
        'handled': 'Sunshine Restaurant',
      },
      {
        'name': 'Emily Davis',
        'role': 'Manager',
        'handled': 'Oceanview Resort',
      },
      {
        'name': 'Michael Brown',
        'role': 'Manager',
        'handled': 'Cityscape Hotel',
      },
    ];

    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: managers.length,
        itemBuilder: (context, index) {
          final manager = managers[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            child: ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.blueGrey[100],
                child: Text(
                  manager['name']![0],
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              title: Text(
                manager['name']!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    manager['role']!,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Handled: ${manager['handled']}',
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              onTap: () {
                _showManagerDialog(context, manager);
              },
            ),
          );
        },
      ),
    );
  }
  void _showManagerDialog(BuildContext context, Map<String, String> manager) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text('Manager: ${manager['name']}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Role: ${manager['role']}'),
              const SizedBox(height: 10),
              Text('Handled: ${manager['handled']}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Revoked ${manager['name']}')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Revoke'),
            ),
          ],
        );
      },
    );
  }
}
