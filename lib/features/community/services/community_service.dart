// Community service
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/community.dart';

class CommunityService {
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    // Mock initialization
    await Future.delayed(const Duration(milliseconds: 100));
    _initialized = true;
  }

  Future<void> createPost({
    required String content,
    required PostCategory category,
    bool anonymous = false,
    bool isAnonymous = false,
    String? authorName,
    String? title,
  }) async {
    // Mock implementation
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> joinChallenge(String challengeId) async {
    // Mock implementation
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<List<CommunityPost>> getPosts({PostCategory? category}) async {
    // Mock implementation
    return [];
  }

  List<CommunityPost> filterPosts(List<CommunityPost> posts, PostCategory? category) {
    if (category == null) return posts;
    return posts.where((post) => post.category == category).toList();
  }

  Future<List<Challenge>> getChallenges() async {
    // Mock implementation
    return [];
  }

  Future<List<FinancialBenchmark>> getBenchmarks() async {
    // Mock implementation
    return [];
  }
}

final communityServiceProvider = Provider((ref) => CommunityService());

// Stream providers for community data
final postsStreamProvider = StreamProvider<List<CommunityPost>>((ref) async* {
  final service = ref.read(communityServiceProvider);
  await service.initialize();
  yield await service.getPosts();
});

final benchmarksStreamProvider = StreamProvider<List<FinancialBenchmark>>((ref) async* {
  final service = ref.read(communityServiceProvider);
  await service.initialize();
  yield await service.getBenchmarks();
});

final challengesStreamProvider = StreamProvider<List<Challenge>>((ref) async* {
  final service = ref.read(communityServiceProvider);
  await service.initialize();
  yield await service.getChallenges();
});

