import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PokeForum',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TopicsPage(),
    );
  }
}

class TopicsPage extends StatelessWidget {
  const TopicsPage({super.key});

  final List<Map<String, dynamic>> _topics = const [
    {
      'title': 'Pikachu - Le symbole de la série',
      'description':
          'Pikachu est connu pour être l\'ambassadeur de la franchise Pokémon, apprécié par des millions de fans.',
      'comments': [
        {
          'pseudo': 'Ash',
          'comment': 'Super mignon!',
          'date': '2024-11-14 10:00'
        },
        {
          'pseudo': 'Misty',
          'comment': 'Le meilleur Pokémon!',
          'date': '2024-11-14 11:00'
        }
      ]
    },
    {
      'title': 'Charizard - Puissance et majesté',
      'description':
          'Charizard est célèbre pour sa puissance et son apparence redoutable, un favori de nombreux dresseurs.',
      'comments': [
        {
          'pseudo': 'Brock',
          'comment': 'Trop stylé !',
          'date': '2024-11-13 14:30'
        },
        {
          'pseudo': 'Red',
          'comment': 'Mon favori depuis toujours.',
          'date': '2024-11-13 15:00'
        }
      ]
    },
    {
      'title': 'Bulbasaur - Le choix sous-estimé',
      'description':
          'Bulbasaur est souvent négligé mais reste un excellent choix pour commencer l\'aventure.',
      'comments': [
        {
          'pseudo': 'Leaf',
          'comment': 'Les types Plante méritent plus d\'amour.',
          'date': '2024-11-12 09:45'
        },
        {
          'pseudo': 'Gary',
          'comment': 'Un classique.',
          'date': '2024-11-12 10:15'
        }
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PokeForum'),
      ),
      body: ListView.builder(
        itemCount: _topics.length,
        itemBuilder: (context, index) {
          final topic = _topics[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text(
                topic['title'],
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                topic['description'],
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TopicDetailPage(topic: topic),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class TopicDetailPage extends StatefulWidget {
  final Map<String, dynamic> topic;

  const TopicDetailPage({super.key, required this.topic});

  @override
  State<TopicDetailPage> createState() => _TopicDetailPageState();
}

class _TopicDetailPageState extends State<TopicDetailPage> {
  final TextEditingController _pseudoController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  // Liste locale des commentaires pour gérer l'état
  late List<Map<String, String>> _comments;

  @override
  void initState() {
    super.initState();
    // Initialisation avec une copie des commentaires
    _comments = List<Map<String, String>>.from(widget.topic['comments']);
  }

  // Ajout d'un commentaire
  void _addComment(String pseudo, String comment) {
    final String currentDate =
        DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
    setState(() {
      _comments.add({
        'pseudo': pseudo,
        'comment': comment,
        'date': currentDate,
      });
    });
    _pseudoController.clear();
    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topic['title']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.topic['description'],
              style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _comments.length,
                itemBuilder: (context, index) {
                  final comment = _comments[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ListTile(
                      title: Text(comment['comment']!),
                      subtitle: Text(
                          'Posté par ${comment['pseudo']} le ${comment['date']}'),
                    ),
                  );
                },
              ),
            ),
            const Divider(),
            TextField(
              controller: _pseudoController,
              decoration: const InputDecoration(hintText: 'Votre pseudo'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _commentController,
              decoration: const InputDecoration(hintText: 'Votre commentaire'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                if (_pseudoController.text.isNotEmpty &&
                    _commentController.text.isNotEmpty) {
                  _addComment(_pseudoController.text, _commentController.text);
                }
              },
              child: const Text('Ajouter un commentaire'),
            ),
          ],
        ),
      ),
    );
  }
}
// class TopicDetailPage extends StatefulWidget {
//   final Map<String, dynamic> topic;

//   const TopicDetailPage({super.key, required this.topic});

//   @override
//   State<TopicDetailPage> createState() => _TopicDetailPageState();
// }

// class _TopicDetailPageState extends State<TopicDetailPage> {
//   final TextEditingController _pseudoController = TextEditingController();
//   final TextEditingController _commentController = TextEditingController();

//   late List<Map<String, String>> _comments;

//   @override
//   void initState() {
//     super.initState();
//     _loadComments();
//   }

//   // Charger les commentaires depuis shared_preferences
//   void _loadComments() async {
//     final prefs = await SharedPreferences.getInstance();
//     final savedComments = prefs.getString('comments_${widget.topic['title']}');

//     if (savedComments != null) {
//       setState(() {
//         _comments = List<Map<String, String>>.from(json.decode(savedComments));
//       });
//     } else {
//       setState(() {
//         _comments = List<Map<String, String>>.from(widget.topic['comments']);
//       });
//     }
//   }

//   // Sauvegarder les commentaires dans shared_preferences
//   void _saveComments() async {
//     final prefs = await SharedPreferences.getInstance();
//     prefs.setString(
//         'comments_${widget.topic['title']}', json.encode(_comments));
//   }

//   void _addComment(String pseudo, String comment) {
//     final String currentDate =
//         DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
//     setState(() {
//       _comments.add({
//         'pseudo': pseudo,
//         'comment': comment,
//         'date': currentDate,
//       });
//     });
//     _saveComments();
//     _pseudoController.clear();
//     _commentController.clear();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.topic['title']),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               widget.topic['description'],
//               style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
//             ),
//             const SizedBox(height: 10),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: _comments.length,
//                 itemBuilder: (context, index) {
//                   final comment = _comments[index];
//                   return Card(
//                     margin: const EdgeInsets.symmetric(vertical: 4.0),
//                     child: ListTile(
//                       title: Text(comment['comment']!),
//                       subtitle: Text(
//                           'Posté par ${comment['pseudo']} le ${comment['date']}'),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             const Divider(),
//             TextField(
//               controller: _pseudoController,
//               decoration: const InputDecoration(hintText: 'Votre pseudo'),
//             ),
//             const SizedBox(height: 8),
//             TextField(
//               controller: _commentController,
//               decoration: const InputDecoration(hintText: 'Votre commentaire'),
//             ),
//             const SizedBox(height: 8),
//             ElevatedButton(
//               onPressed: () {
//                 if (_pseudoController.text.isNotEmpty &&
//                     _commentController.text.isNotEmpty) {
//                   _addComment(_pseudoController.text, _commentController.text);
//                 }
//               },
//               child: const Text('Ajouter un commentaire'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
