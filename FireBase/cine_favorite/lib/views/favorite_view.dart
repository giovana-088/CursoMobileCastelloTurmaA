import 'dart:io';

import 'package:cine_favorite/controllers/movie_firestore_controller.dart';
import 'package:cine_favorite/models/movie.dart';
import 'package:cine_favorite/views/search_movie_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavoriteView extends StatefulWidget {
  const FavoriteView({super.key});

  @override
  State<FavoriteView> createState() => _FavoriteViewState();
}

class _FavoriteViewState extends State<FavoriteView> {
  final _movieController = MovieFirestoreController();

  // Função para desfavoritar o filme
  void _unfavoriteMovie(Movie movie) async {
    try {
      await _movieController.removeMovie(movie.id);
      // O StreamBuilder vai atualizar automaticamente e remover o card
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${movie.title} removido dos favoritos")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao remover ${movie.title}")),
      );
    }
  }

  // Função para avaliar o filme
  void _showRatingDialog(Movie movie) {
    double currentRating = movie.rating ?? 0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Avaliar ${movie.title}"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Slider(
                value: currentRating,
                min: 0,
                max: 10,
                divisions: 10,
                label: currentRating.toStringAsFixed(1),
                onChanged: (value) {
                  setState(() {
                    currentRating = value;
                  });
                },
              ),
              Text("Nota: ${currentRating.toStringAsFixed(1)}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () async {
               _movieController.updateMovieRating(movie.id, currentRating);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Nota de ${movie.title} atualizada!")),
                );
              },
              child: const Text("Salvar"),
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
        title: const Text("Meus Filmes Favoritos"),
        actions: [
          IconButton(
            onPressed: FirebaseAuth.instance.signOut,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder<List<Movie>>(
        stream: _movieController.getFavoriteMovies(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Erro ao carregar a lista de favoritos"),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: Text("Buscando..."));
          }
          if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text("Nenhum filme adicionado aos favoritos"),
            );
          }

          final favoriteMovies = snapshot.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.7,
            ),
            itemCount: favoriteMovies.length,
            itemBuilder: (context, index) {
              final movie = favoriteMovies[index];
              return Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: movie.posterPath.isNotEmpty
                          ? Image.file(
                              File(movie.posterPath),
                              fit: BoxFit.cover,
                            )
                          : const Icon(Icons.movie, size: 80),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(
                        movie.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Center(
                      child: Text(
                        "Nota: ${movie.rating?.toStringAsFixed(1) ?? "N/A"}",
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Botão estrela desfavoritar
                        IconButton(
                          icon: const Icon(Icons.star, color: Colors.amber),
                          tooltip: "Remover dos Favoritos",
                          onPressed: () => _unfavoriteMovie(movie),
                        ),
                        // Botão editar para avaliar
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          tooltip: "Avaliar Filme",
                          onPressed: () => _showRatingDialog(movie),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SearchMovieView()),
        ),
        child: const Icon(Icons.search),
      ),
    );
  }
}
