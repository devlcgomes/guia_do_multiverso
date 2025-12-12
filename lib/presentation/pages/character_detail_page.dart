import 'package:flutter/material.dart';
import '../../domain/entities/character_entity.dart';

class CharacterDetailPage extends StatelessWidget {
  final CharacterEntity character;

  const CharacterDetailPage({
    super.key,
    required this.character,
  });

  String _getStatusText() {
    switch (character.status.toLowerCase()) {
      case 'alive':
        return 'VIVO';
      case 'dead':
        return 'MORTO';
      case 'unknown':
      default:
        return 'DESCONHECIDO';
    }
  }

  Color _getStatusColor() {
    switch (character.status.toLowerCase()) {
      case 'alive':
        return const Color(0xFF00FF88);
      case 'dead':
        return Colors.red;
      case 'unknown':
      default:
        return Colors.grey;
    }
  }

  String _getSpeciesText() {
    switch (character.species.toLowerCase()) {
      case 'human':
        return 'Humano';
      case 'alien':
        return 'Alienígena';
      default:
        return character.species;
    }
  }

  String _getGenderText() {
    switch (character.gender.toLowerCase()) {
      case 'male':
        return 'Masculino';
      case 'female':
        return 'Feminino';
      case 'genderless':
        return 'Sem gênero';
      case 'unknown':
      default:
        return 'Desconhecido';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Detalhes do Personagem',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageCard(),
            _buildStatusCard(),
            _buildPersonalInfoCard(),
            _buildOriginLocationCard(),
            _buildAppearancesCard(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      height: 200,
      decoration: BoxDecoration(
        color: const Color(0xFFC8E6C9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          character.image,
          fit: BoxFit.cover,
          width: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: const Color(0xFFC8E6C9),
              child: const Icon(
                Icons.person,
                size: 100,
                color: Color(0xFF1A1A2E),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1B5E20),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          'STATUS: ${_getStatusText()}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _getStatusColor(),
          ),
        ),
      ),
    );
  }

  Widget _buildPersonalInfoCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF00FF88).withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.person,
                color: Color(0xFF00FF88),
                size: 24,
              ),
              const SizedBox(width: 12),
              const Text(
                'Informações Pessoais',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Espécie:', _getSpeciesText()),
          const SizedBox(height: 12),
          _buildInfoRow('Gênero:', _getGenderText()),
        ],
      ),
    );
  }

  Widget _buildOriginLocationCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF00FF88).withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.location_on,
                color: Color(0xFF00FF88),
                size: 24,
              ),
              const SizedBox(width: 12),
              const Text(
                'Origem e Localização',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Origem:', character.origin),
          const SizedBox(height: 12),
          _buildInfoRow('Local Atual:', character.location),
        ],
      ),
    );
  }

  Widget _buildAppearancesCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF00FF88).withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.tv,
                color: Color(0xFF00FF88),
                size: 24,
              ),
              const SizedBox(width: 12),
              const Text(
                'Aparições',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Episódios:', '${character.episodes.length}'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[400],
            ),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          flex: 3,
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            textAlign: TextAlign.end,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
