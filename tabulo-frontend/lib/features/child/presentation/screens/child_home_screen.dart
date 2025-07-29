import 'package:flutter/material.dart';
import '../../../training/presentation/screens/table_selection_screen.dart';
import '../../../training/presentation/screens/training_history_screen.dart';

class ChildHomeScreen extends StatelessWidget {
  const ChildHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenue !'),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Historique des entraînements'),
              onTap: () {
                Navigator.pop(context); // Ferme le Drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TrainingHistoryScreen(),
                  ),
                );
              },
            ),
            // 🔒 Plus tard : ajouter d'autres options ici (profil, déconnexion, etc.)
          ],
        ),
      ),
      body: const TableSelectionScreen(),
    );
  }
}
