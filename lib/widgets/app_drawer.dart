import 'package:flutter/material.dart';
import '../screens/classifications_screen.dart';
import '../screens/clients_screen.dart';
import '../screens/contacts_screen.dart';
import '../screens/home_screen.dart';
import '../screens/pokemon_list_screen.dart';
import '../screens/scanner_screen.dart';
import '../services/auth_service.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService().currentUser;

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.25),
              child: const Icon(
                Icons.person_rounded,
                size: 44,
                color: Colors.white,
              ),
            ),
            accountName: Text(
              user?.displayName ?? 'Usuario',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            accountEmail: Text(
              user?.email ?? '',
              style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                fontSize: 14,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_rounded, color: Color(0xFF1E3C72)),
            title: const Text('Inicio'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.people_alt_rounded, color: Color(0xFF1E3C72)),
            title: const Text('Clientes'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const ClientsScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.category_rounded, color: Color(0xFF1E3C72)),
            title: const Text('Clasificaciones'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const ClassificationsScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.catching_pokemon, color: Color(0xFF1E3C72)),
            title: const Text('APIs REST Pokémon'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const PokemonListScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.contacts_rounded, color: Color(0xFF1E3C72)),
            title: const Text('Contactos WhatsApp'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const ContactsScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.qr_code_scanner_rounded, color: Color(0xFF1E3C72)),
            title: const Text('Escáner Barcode & QR'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const ScannerScreen()),
              );
            },
          ),
          const Divider(),
          const Spacer(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
            title: const Text(
              'Cerrar sesión',
              style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600),
            ),
            onTap: () async {
              Navigator.pop(context);
              await AuthService().signOut();
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
