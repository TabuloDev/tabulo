# Cahier des charges minimal – Application Tabulo

## 🎯 Objectif principal
Aider les enfants de 6 à 10 ans à réviser efficacement les tables de multiplication de manière ludique et interactive, avec un suivi des progrès pour les parents et enseignants.

## 👥 Utilisateurs ciblés
- **Enfant** : s'entraîne, joue, progresse.
- **Parent** : consulte les résultats, motive l’enfant.
- **Enseignant** : suit les performances d’élèves en classe, ajoute des retours personnalisés.

## ✅ Fonctionnalités essentielles (MVP)
- 🔐 Authentification (enfant, parent, enseignant)
- 🧮 Mode entraînement sur une ou plusieurs tables
- 📊 Sauvegarde automatique des scores
- 🕓 Historique des entraînements (pour chaque enfant)
- 👨‍👩‍👧 Accès des parents/enseignants aux résultats
- ✏️ Ajout de **commentaires** et **notes** par l’enseignant (visibles par l’enfant et ses parents)

## 📱 Plateformes visées
- Web
- Mobile (Android dans un premier temps)

## ⚙️ Contraintes techniques
- Flutter pour le frontend
- Node.js (Express) pour le backend
- MongoDB
- JWT pour l’authentification
- Architecture : Clean Architecture + TDD
