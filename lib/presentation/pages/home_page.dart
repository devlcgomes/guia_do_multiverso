import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/character/character_bloc.dart';
import '../bloc/character/character_event.dart';
import '../bloc/character/character_state.dart';
import '../widgets/character_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<CharacterBloc>().add(const LoadCharacters());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.8) {
      final state = context.read<CharacterBloc>().state;
      if (state is CharacterLoaded && state.hasMore) {
        if (state.nextUrl != null) {
          context.read<CharacterBloc>().add(
                LoadMoreCharacters(state.nextUrl!),
              );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personagens'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocBuilder<CharacterBloc, CharacterState>(
        builder: (context, state) {
          if (state is CharacterLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CharacterError) {
            final previousState = context.read<CharacterBloc>().state;
            String? lastStatus;
            if (previousState is CharacterLoaded) {
              lastStatus = previousState.currentStatus;
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CharacterBloc>().add(LoadCharacters(status: lastStatus));
                    },
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }

          if (state is CharacterLoaded || state is CharacterLoadingMore) {
            final characters = state is CharacterLoaded
                ? state.characters
                : (state as CharacterLoadingMore).characters;
            final hasMore = state is CharacterLoaded ? state.hasMore : true;
            final currentStatus = state is CharacterLoaded
                ? state.currentStatus
                : (state as CharacterLoadingMore).currentStatus;

            return RefreshIndicator(
              onRefresh: () async {
                final status = currentStatus;
                context.read<CharacterBloc>().add(RefreshCharacters(status: status));
              },
              child: Column(
                children: [
                  _buildFilterChips(context, currentStatus),
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: characters.length + (hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == characters.length) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final character = characters[index];
                        return CharacterCard(character: character);
                      },
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context, String? currentStatus) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildChip(
              context,
              label: 'Todos',
              isSelected: currentStatus == null,
              onTap: () {
                context.read<CharacterBloc>().add(const FilterByStatus(null));
              },
            ),
            const SizedBox(width: 8),
            _buildChip(
              context,
              label: 'Vivo',
              isSelected: currentStatus == 'alive',
              onTap: () {
                context.read<CharacterBloc>().add(const FilterByStatus('alive'));
              },
            ),
            const SizedBox(width: 8),
            _buildChip(
              context,
              label: 'Morto',
              isSelected: currentStatus == 'dead',
              onTap: () {
                context.read<CharacterBloc>().add(const FilterByStatus('dead'));
              },
            ),
            const SizedBox(width: 8),
            _buildChip(
              context,
              label: 'Desconhecido',
              isSelected: currentStatus == 'unknown',
              onTap: () {
                context.read<CharacterBloc>().add(const FilterByStatus('unknown'));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: Theme.of(context).colorScheme.primaryContainer,
      checkmarkColor: Theme.of(context).colorScheme.onPrimaryContainer,
      labelStyle: TextStyle(
        color: isSelected
            ? Theme.of(context).colorScheme.onPrimaryContainer
            : Theme.of(context).colorScheme.onSurface,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }
}

