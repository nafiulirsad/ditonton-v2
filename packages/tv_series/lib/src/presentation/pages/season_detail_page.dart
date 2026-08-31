import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/episode.dart';
import '../bloc/season_detail_bloc.dart';

/// Argumen navigasi menuju halaman detail season.
class SeasonDetailArgs {
  final int tvSeriesId;
  final int seasonNumber;
  final String seasonName;

  const SeasonDetailArgs({
    required this.tvSeriesId,
    required this.seasonNumber,
    required this.seasonName,
  });
}

class SeasonDetailPage extends StatefulWidget {
  static const routeName = AppRoutes.seasonDetail;

  final SeasonDetailArgs args;

  const SeasonDetailPage({super.key, required this.args});

  @override
  State<SeasonDetailPage> createState() => _SeasonDetailPageState();
}

class _SeasonDetailPageState extends State<SeasonDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<SeasonDetailBloc>().add(
        FetchSeasonDetail(
          id: widget.args.tvSeriesId,
          seasonNumber: widget.args.seasonNumber,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.args.seasonName)),
      body: BlocBuilder<SeasonDetailBloc, SeasonDetailState>(
        builder: (context, state) {
          return switch (state) {
            SeasonDetailLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            SeasonDetailHasData(:final result) when result.episodes.isEmpty =>
              const Center(
                key: Key('empty_message'),
                child: Text('Belum ada episode pada season ini.'),
              ),
            SeasonDetailHasData(:final result) => ListView.builder(
              key: const Key('episode_list'),
              padding: const EdgeInsets.all(8),
              itemCount: result.episodes.length,
              itemBuilder: (context, index) =>
                  EpisodeCard(result.episodes[index]),
            ),
            SeasonDetailError(:final message) => Center(
              key: const Key('error_message'),
              child: Text(message),
            ),
            SeasonDetailEmpty() => const SizedBox.shrink(),
          };
        },
      ),
    );
  }
}

class EpisodeCard extends StatelessWidget {
  final Episode episode;

  const EpisodeCard(this.episode, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              child: CachedNetworkImage(
                imageUrl: '$baseImageUrl${episode.stillPath}',
                width: 120,
                height: 70,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'E${episode.episodeNumber} - ${episode.name}',
                    style: kSubtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: kMikadoYellow, size: 16),
                      const SizedBox(width: 4),
                      Text('${episode.voteAverage}', style: kBodyText),
                      const SizedBox(width: 8),
                      Text(episode.airDate ?? '-', style: kBodyText),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    episode.overview.isEmpty
                        ? 'Tidak ada sinopsis untuk episode ini.'
                        : episode.overview,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: kBodyText,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
