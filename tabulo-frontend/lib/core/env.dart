// lib/core/env.dart

/// ⚙️ URL de base du backend Tabulo (accessible depuis les appareils sur le même réseau Wi-Fi)
const String baseUrl = 'http://192.168.188.209:5000';

/// 📦 Vérification explicite de baseUrl au moment de l’importation (si appelée depuis main.dart)
void testBaseUrlAtImportTime() {
  if (baseUrl.trim().isEmpty) {
    assert(false, '💥 baseUrl est vide dans env.dart !');
  }
}
