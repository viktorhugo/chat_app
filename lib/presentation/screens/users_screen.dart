import 'package:animate_do/animate_do.dart';
import 'package:chat_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {

  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  final users = [
    User(uuid: '1', name: 'Maria rendon', email: 'mariarendon@outlook.com',online: true),
    User(uuid: '2', name: 'Cesar Salcedo', email: 'cesarsalcedo@outlook.com',online: true),
    User(uuid: '3', name: 'Camilo Puerta', email: 'camilopiuerta@outlook.com',online: true),
    User(uuid: '4', name: 'Elking Mosquera', email: 'elking23@outlook.com',online: false),
    User(uuid: '5', name: 'Anguie Mosquera', email: 'anguieM34@outlook.com',online: false),
  ];

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Name', style: TextStyle(color: Colors.white)),
        elevation: 2,
        backgroundColor: colors.primary,
        leading: IconButton(
          icon: const Icon(Icons.exit_to_app_rounded, color: Colors.white, size: 26,),
          onPressed: () {
            
          },
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            // child: const Icon(Icons.check_circle, color: Colors.blue, size: 26,),
            child: const Icon(Icons.offline_bolt, color: Colors.red, size: 26,),
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        header: WaterDropHeader(
          complete: ElasticIn(
            child: const Icon(Icons.check, color: Colors.green, size: 30,)
          ),
          waterDropColor: colors.primary,
        ),
        onRefresh: () => _loadUsers(),
        child: ListViewUsers(),
      )
  );
  }

  ListView ListViewUsers() {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: users.length,
      itemBuilder: (context, index) => _userListTile(users[index]),
      separatorBuilder: (context, index) => const Divider(
        height: 1,
        // color: Colors.transparent,
      ),
    );
  }

  ListTile _userListTile(User user) {

    final colors = Theme.of(context).colorScheme;

    return ListTile(
      title: Text(user.name),
      subtitle:  Text(user.email),
      leading: CircleAvatar(
        backgroundColor: colors.secondary.withOpacity(0.6),
        child: Text(user.name.substring(0,2), style: const TextStyle(color: Colors.white),),
      ),
      trailing: Icon(
        Icons.online_prediction_outlined,
        color: user.online ? Colors.green : Colors.redAccent,
        size: 25,
      ),
    );
  }

  _loadUsers() async {
     // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));

    _refreshController.refreshCompleted();
  }
}