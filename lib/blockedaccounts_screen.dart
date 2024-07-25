import 'package:flutter/material.dart';

class BlockedAccountsScreen extends StatefulWidget {
  @override
  _BlockedAccountsScreenState createState() => _BlockedAccountsScreenState();
}

class _BlockedAccountsScreenState extends State<BlockedAccountsScreen> {
  final List<Map<String, dynamic>> blockedAccounts = [
    // Mock data for blocked accounts
    {
      'name': 'Batangas State University Library - Alangilan',
      'profilePic': 'assets/bsulib.jpg',
    },
    {
      'name': 'CABEIHM Student Council',
      'profilePic': 'assets/cabeihm.jpg',
    },
    {
      'name': 'Batangas PIO',
      'profilePic': 'assets/batspio.jpg',
    },
  ];

  void _unblockAccount(int index) {
    setState(() {
      blockedAccounts.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Account unblocked'),
      ),
    );
  }

  void _showUnblockDialog(BuildContext context, int index) {
    final account = blockedAccounts[index];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text('Unblock Account'),
          content:
              Text('Are you sure you want to unblock "${account['name']}"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _unblockAccount(index);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Text('Unblock'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Blocked Accounts',
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: blockedAccounts.length,
        itemBuilder: (context, index) {
          final account = blockedAccounts[index];
          return BlockedAccountCard(
            account: account,
            onUnblock: () => _showUnblockDialog(context, index),
          );
        },
      ),
    );
  }
}

class BlockedAccountCard extends StatelessWidget {
  final Map<String, dynamic> account;
  final VoidCallback onUnblock;

  BlockedAccountCard({
    required this.account,
    required this.onUnblock,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double fontSize = constraints.maxWidth * 0.04;
        double buttonFontSize = constraints.maxWidth * 0.035;
        double avatarRadius = constraints.maxWidth * 0.09;

        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 5,
          margin: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          child: Container(
            height: constraints.maxWidth * 0.3,
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: avatarRadius,
                  backgroundImage: NetworkImage(account['profilePic']),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    account['name'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 10),
                TextButton(
                  onPressed: onUnblock,
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: Text(
                    'Blocked',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: buttonFontSize,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
