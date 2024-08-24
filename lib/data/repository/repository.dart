import 'package:music_app/data/model/song.dart';
import 'package:music_app/data/source/source.dart';

abstract interface class Repository {
  Future<List<Song>?> loadData();
}

class DefaultRepository implements Repository {
  final _localDataSource = LocalDataSource();
  final _remoteDataSource = RemoteDataSource();


  @override
  Future<List<Song>?> loadData() async {
    try {
      List<Song> songs = [];
      print('Attempting to load remote data...');
      var remoteSongs = await _remoteDataSource.loadData();
      if (remoteSongs == null) {
        print('Remote data not available. Attempting to load local data...');
        var localSongs = await _localDataSource.loadData();
        if (localSongs != null) {
          print('Local data loaded successfully.');
          songs.addAll(localSongs);
        } else {
          print('Local data not available.');
        }
      } else {
        print('Remote data loaded successfully.');
        songs.addAll(remoteSongs);
      }
      print('Total songs loaded: ${songs.length}');
      return songs;
    } catch (e, stackTrace) {
      print('Error loading data: $e');
      print(stackTrace);
      return null;
    }
  }
}