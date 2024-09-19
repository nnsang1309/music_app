import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_app/ui/now_playing/audio_player_manager.dart';

import '../../data/model/song.dart';

class NowPlaying extends StatelessWidget {
  const NowPlaying({
    super.key,
    required this.songs,
    required this.playingSong,
  });

  final List<Song> songs;
  final Song playingSong;

  @override
  Widget build(BuildContext context) {
    return NowPlayingPage(
      songs: songs,
      playingSong: playingSong,
    );
  }
}

class NowPlayingPage extends StatefulWidget {
  const NowPlayingPage({
    super.key,
    required this.songs,
    required this.playingSong,
  });

  final List<Song> songs;
  final Song playingSong;

  @override
  State<NowPlayingPage> createState() => _NowPlayingPageState();
}

class _NowPlayingPageState extends State<NowPlayingPage> with SingleTickerProviderStateMixin {
  late AnimationController _imageAnimController;
  late AudioPlayerManager _audioPlayerManager;

  @override
  void initState() {
    super.initState();
    _imageAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120000),
    );
    _audioPlayerManager = AudioPlayerManager(songUrl: widget.playingSong.source);
    _audioPlayerManager.init();
  }

  @override
  Widget build(BuildContext context) {
    // get width of screen
    final screenWidth = MediaQuery.of(context).size.width;
    const delta = 64;
    // radius of circle image
    final radius = (screenWidth - delta) / 2;

    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: const Text(
            'Now Playing',
          ),
          trailing: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_horiz),
          ),
        ),
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.playingSong.album),
                const SizedBox(
                  height: 16,
                ),
                const Text('_ ___ _'),
                const SizedBox(
                  height: 48,
                ),

                // ---- Anh bai hat xoay vong
                RotationTransition(
                  turns: Tween(begin: 0.0, end: 1.0).animate(_imageAnimController),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(radius),
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/itunes.png',
                      image: widget.playingSong.image,
                      width: screenWidth - delta,
                      height: screenWidth - delta,
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/itunes.png',
                          width: screenWidth - delta,
                          height: screenWidth - delta,
                        );
                      },
                    ),
                  ),
                ),

                // ---- Ten bai hat, ten ca si
                Padding(
                  padding: const EdgeInsets.only(top: 64, bottom: 16),
                  child: SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Share icon
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.share_outlined),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        // name, artist playing song
                        Column(
                          children: [
                            Text(
                              widget.playingSong.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Theme.of(context).textTheme.bodyMedium!.color),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.playingSong.artist,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Theme.of(context).textTheme.bodyMedium!.color),
                            ),
                          ],
                        ),
                        // love icon
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.favorite_outline),
                          color: Theme.of(context).colorScheme.primary,
                        )
                      ],
                    ),
                  ),
                ),

                // ---- Progress bar audio
                Padding(
                  padding: const EdgeInsets.only(
                    top: 32,
                    left: 24,
                    right: 24,
                    bottom: 16,
                  ),
                  child: _progressBar(),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 24,
                    right: 24,
                  ),
                  child: _mediaButtons(),
                )
              ],
            ),
          ),
        ));
  }

  Widget _mediaButtons() {
    return const SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          MediaButtonControl(function: null, icon: Icons.shuffle, color: Colors.purple, size: 24),
          MediaButtonControl(function: null, icon: Icons.skip_previous, color: Colors.purple, size: 36),
          MediaButtonControl(function: null, icon: Icons.play_arrow_sharp, color: Colors.purple, size: 48),
          MediaButtonControl(function: null, icon: Icons.skip_next, color: Colors.purple, size: 36),
          MediaButtonControl(function: null, icon: Icons.repeat, color: Colors.purple, size: 24),
        ],
      ),
    );
  }

  StreamBuilder<DurationState> _progressBar() {
    return StreamBuilder<DurationState>(
        stream: _audioPlayerManager.durationState,
        builder: (context, snapshot) {
          final durationState = snapshot.data;
          final progress = durationState?.progress ?? Duration.zero;
          final buffered = durationState?.buffered ?? Duration.zero;
          final total = durationState?.total ?? Duration.zero;
          return ProgressBar(
            progress: progress,
            total: total,
          );
        });
  }
}

class MediaButtonControl extends StatefulWidget {
  const MediaButtonControl({
    super.key,
    required this.function,
    required this.icon,
    required this.color,
    required this.size,
  });

  final void Function()? function;
  final IconData icon;
  final double? size;
  final Color? color;

  @override
  State<StatefulWidget> createState() => _MediaButtonControlState();
}

class _MediaButtonControlState extends State<MediaButtonControl> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: widget.function,
      icon: Icon(widget.icon),
      iconSize: widget.size,
      color: widget.color ?? Theme.of(context).colorScheme.primary,
    );
  }
}
