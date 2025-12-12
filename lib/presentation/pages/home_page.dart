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
      backgroundColor: const Color(0xFF0F0F1E),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildSearchBar(context),
            BlocBuilder<CharacterBloc, CharacterState>(
        builder: (context, state) {
          if (state is CharacterLoading) {
            return const Expanded(
              child: Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF00FF88),
                ),
              ),
            );
          }

          if (state is CharacterError) {
            final previousState = context.read<CharacterBloc>().state;
            String? lastStatus;
            if (previousState is CharacterLoaded) {
              lastStatus = previousState.currentStatus;
            }

            return Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.message,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<CharacterBloc>().add(LoadCharacters(status: lastStatus));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00FF88),
                        foregroundColor: Colors.black,
                      ),
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
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

            return Expanded(
              child: RefreshIndicator(
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
                        padding: const EdgeInsets.only(bottom: 80),
                        itemCount: characters.length + (hasMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == characters.length) {
                            return const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFF00FF88),
                                ),
                              ),
                            );
                          }

                          final character = characters[index];
                          return CharacterCard(character: character);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(context),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: const Text(
        'Guia do Multiverso',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Color(0xFF00FF88),
          shadows: [
            Shadow(
              color: Color(0xFF00FF88),
              blurRadius: 10,
            ),
            Shadow(
              color: Color(0xFF00FF88),
              blurRadius: 20,
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.grey[700]!,
          width: 1,
        ),
      ),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Buscar Personagem...',
          hintStyle: TextStyle(color: Colors.grey[500]),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey[400],
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A2B34),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(0),
          topRight: Radius.circular(0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.list,
                  color: Color(0xFF4ECDC4),
                  size: 28,
                ),
                onPressed: () {},
              ),
              const SizedBox(width: 60),
              IconButton(
                icon: Icon(
                  Icons.settings,
                  color: Colors.grey[400],
                  size: 28,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
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
      selectedColor: const Color(0xFF4ECDC4),
      checkmarkColor: Colors.white,
      backgroundColor: const Color(0xFF1A1A2E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected
              ? const Color(0xFF4ECDC4)
              : Colors.grey[700]!,
          width: 1,
        ),
      ),
      labelStyle: TextStyle(
        color: isSelected
            ? Colors.white
            : Colors.grey[400],
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }
}

