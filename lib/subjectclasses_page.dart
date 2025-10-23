import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

void main() {
  runApp(const SubjectClassesPage());
}

class SubjectClassesPage extends StatelessWidget {
  const SubjectClassesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const CourseListPage(),
    );
  }
}

class CourseListPage extends StatefulWidget {
  const CourseListPage({Key? key}) : super(key: key);

  @override
  State<CourseListPage> createState() => _CourseListPageState();
}

class _CourseListPageState extends State<CourseListPage> {
  final ScrollController _scrollController = ScrollController();
  String? selectedTopicTitle;
  YoutubePlayerController? _controller;
  VideoPlayerController? _assetVideoController;
  ChewieController? _chewieController;
  bool isPlaying = false;
  bool isFullScreen = false;
  bool isLoading = false;
  String? errorMessage;

  final List<Map<String, dynamic>> mathTopics = [
    {
      'title': 'Algebra Basics',
      'image': 'assets/images/algebra.png',
      'youtubeId': '5Q0FlxcEEIw', 
      'assetVideo': 'assets/videos/bagheera.mp4',
    },
    {
      'title': 'Geometry Fundamentals',
      'image': 'assets/images/geometrics.png',
      'youtubeId': '302eJ3TzJQU', 
      'assetVideo': 'assets/videos/bagheera.mp4',
    },
    {
      'title': 'Trigonometry Essentials',
      'image': 'assets/images/trigonometry.png',
      'youtubeId': 'k_MzQjLA9fA', 
      'assetVideo': 'assets/videos/bagheera.mp4',
    },
    {
      'title': 'Calculus - Differentiation',
      'image': 'assets/images/calculas.jpg',
      'youtubeId': 'BcOPKQAZcn0', 
      'assetVideo': 'assets/videos/bagheera.mp4',
    },
    {
      'title': 'Calculus - Integration',
      'image': 'assets/images/integration.webp',
      'youtubeId': 'rfG8ce4jNh0', 
      'assetVideo': 'assets/videos/bagheera.mp4',
    },
  ];

  @override
  void initState() {
    super.initState();
    // Set initial orientation to portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    if (_controller != null) {
      _controller!.addListener(_youtubeFullscreenListener);
    }
  }

  void _youtubeFullscreenListener() {
    if (_controller != null) {
      if (_controller!.value.isFullScreen) {
        // Entering fullscreen, force only landscape
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      } else {
        // Exiting fullscreen, force only portrait
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      }
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_youtubeFullscreenListener);
    _controller?.dispose();
    _assetVideoController?.dispose();
    _chewieController?.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _playYoutubeVideo(String videoId) {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      if (_controller != null) {
        _controller!.load(videoId);
      } else {
        _controller = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: true,
            mute: false,
            forceHD: true,
          ),
        )
        ..addListener(_youtubeFullscreenListener);
      }
      setState(() {
        isPlaying = true;
        selectedTopicTitle = mathTopics.firstWhere(
          (topic) => topic['youtubeId'] == videoId,
          orElse: () => {'title': ''},
        )['title'];
      });
    } catch (error) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error loading YouTube video: $error';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _playAssetVideo(String assetPath) {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      _assetVideoController?.dispose();
      _assetVideoController = VideoPlayerController.asset(assetPath);
      _assetVideoController!.initialize().then((_) {
        _chewieController = ChewieController(
          videoPlayerController: _assetVideoController!,
          autoPlay: true,
          looping: false,
          aspectRatio: _assetVideoController!.value.aspectRatio,
          materialProgressColors: ChewieProgressColors(
            playedColor: const Color.fromARGB(255, 54, 231, 244),
            handleColor: const Color.fromARGB(255, 237, 44, 44),
            backgroundColor: const Color.fromARGB(255, 15, 10, 10),
            bufferedColor: Colors.white,
          ),
          placeholder: Container(
            color: const Color.fromARGB(255, 8, 5, 5),
          ),
          autoInitialize: true,
          deviceOrientationsAfterFullScreen: [
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ],
          deviceOrientationsOnEnterFullScreen: [
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ],
        )..addListener(() {
            if (_chewieController?.videoPlayerController.value.hasError ?? false) {
              setState(() {
                isLoading = false;
                errorMessage = 'Error loading asset video';
              });
            }
            // Always reset to portrait when not fullscreen
            if (!(_chewieController?.isFullScreen ?? false)) {
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitUp,
                DeviceOrientation.portraitDown,
              ]);
            }
          });
        setState(() {
          isPlaying = true;
          selectedTopicTitle = mathTopics.firstWhere(
            (topic) => topic['assetVideo'] == assetPath,
            orElse: () => {'title': ''},
          )['title'];
        });
      }).catchError((error) {
        setState(() {
          isLoading = false;
          errorMessage = 'Error initializing video player: $error';
        });
      });
    } catch (error) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error playing asset video: $error';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _stopCurrentVideo() {
    // Force portrait orientation when stopping video
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    
    _controller?.pause();
    _controller?.dispose();
    _controller = null;
    _assetVideoController?.pause();
    _chewieController?.dispose();
    _chewieController = null;
    setState(() {
      isPlaying = false;
      selectedTopicTitle = null;
      isLoading = false;
      errorMessage = null;
    });
  }

  void _toggleFullScreen() {
    setState(() {
      isFullScreen = !isFullScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    // If a YouTube video is selected, use YoutubePlayerBuilder for fullscreen detection
    if (_controller != null) {
      return YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: _controller!,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.amber,
          progressColors: const ProgressBarColors(
            playedColor: Colors.amber,
            handleColor: Colors.amberAccent,
          ),
        ),
        builder: (context, player) {
          final youtubeIsFullScreen = YoutubePlayerController.of(context)?.value.isFullScreen ?? false;
          final chewieIsFullScreen = _chewieController?.isFullScreen ?? false;
          final anyFullScreen = youtubeIsFullScreen || chewieIsFullScreen;
          return Scaffold(
            appBar: anyFullScreen
                ? null
                : AppBar(
                    title: const Text('Math Topics'),
                    backgroundColor: const Color.fromARGB(255, 107, 117, 117).withOpacity(0.5),
                    actions: [
                      if (isPlaying)
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            _stopCurrentVideo();
                          },
                        ),
                    ],
                  ),
            body: Container(
              color: const Color.fromARGB(255, 107, 117, 117),
              child: Column(
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return selectedTopicTitle == null
                          ? SizedBox(
                              height: 200,
                              width: double.infinity,
                              child: Image.asset('assets/images/placeholder.png', fit: BoxFit.cover),
                            )
                          : AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: double.infinity,
                              height: anyFullScreen ? constraints.maxHeight : 220,
                              child: isLoading
                                  ? const Center(child: CircularProgressIndicator())
                                  : errorMessage != null
                                      ? Center(child: Text(errorMessage!))
                                      : player,
                            );
                    },
                  ),
                  if (!anyFullScreen)
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16.0),
                        itemCount: mathTopics.length,
                        itemBuilder: (context, index) {
                          final topic = mathTopics[index];
                          return _buildTopicCard(
                            topic['title'],
                            topic['image'],
                            topic['youtubeId'],
                            topic['assetVideo'],
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      );
    }
    // If not YouTube, fallback to Chewie/local video
    final chewieIsFullScreen = _chewieController?.isFullScreen ?? false;
    return Scaffold(
      appBar: chewieIsFullScreen
          ? null
          : AppBar(
              title: const Text('Math Topics'),
              backgroundColor: const Color.fromARGB(255, 107, 117, 117).withOpacity(0.5),
              actions: [
                if (isPlaying)
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      _stopCurrentVideo();
                    },
                  ),
              ],
            ),
      body: Container(
        color: const Color.fromARGB(255, 107, 117, 117),
        child: Column(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                return selectedTopicTitle == null
                    ? SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: Image.asset('assets/images/placeholder.png', fit: BoxFit.cover),
                      )
                    : AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: double.infinity,
                        height: chewieIsFullScreen ? constraints.maxHeight : 220,
                        child: isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : errorMessage != null
                                ? Center(child: Text(errorMessage!))
                                : _chewieController != null
                                    ? Chewie(controller: _chewieController!)
                                    : const Center(child: CircularProgressIndicator()),
                      );
              },
            ),
            if (!chewieIsFullScreen)
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16.0),
                  itemCount: mathTopics.length,
                  itemBuilder: (context, index) {
                    final topic = mathTopics[index];
                    return _buildTopicCard(
                      topic['title'],
                      topic['image'],
                      topic['youtubeId'],
                      topic['assetVideo'],
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicCard(String title, String image, String youtubeId, String? assetVideo) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(image, width: 80, height: 80, fit: BoxFit.cover),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.play_circle_outline, color: Color.fromARGB(255, 249, 58, 20)),
              onPressed: () {
                _stopCurrentVideo();
                _playYoutubeVideo(youtubeId);
              },
            ),
            if (assetVideo != null)
              IconButton(
                icon: const Icon(Icons.save_outlined, color: Color.fromARGB(255, 5, 225, 144)),
                onPressed: () {
                  _stopCurrentVideo();
                  _playAssetVideo(assetVideo);
                },
              ),
          ],
        ),
      ),
    );
  }
}