import 'dart:convert';
import 'dart:io';
import 'package:args/args.dart';

import 'gitstats.dart';

class GitStatsTool {
  final ArgParser argParser;

  GitStatsTool() : argParser = _buildParser();

  static ArgParser _buildParser() {
    return ArgParser()
      ..addFlag(
        'help',
        abbr: 'h',
        negatable: false,
        help: 'Print this usage information.',
      )
      ..addFlag(
        'verbose',
        abbr: 'v',
        negatable: false,
        help: 'Show additional command output.',
      )
      ..addFlag(
        'version',
        negatable: false,
        help: 'Print the tool version.',
      );
  }

  void printUsage() {
    print('Usage: dart gitstats.dart <flags> [arguments]');
    print(argParser.usage);
  }

  Future<void> run(List<String> arguments) async {
    try {
      final ArgResults results = argParser.parse(arguments);
      bool verbose = false;

      // Process the parsed arguments.
      if (results.wasParsed('help')) {
        printUsage();
        return;
      }
      if (results.wasParsed('version')) {
        final String version = '1.0.0';
        print('gitstats version: $version');
        return;
      }
      if (results.wasParsed('verbose')) {
        verbose = true;
      }

      // Act on the arguments provided.
      print('Positional arguments: ${results.rest}');
      if (verbose) {
        print('[VERBOSE] All arguments: ${results.arguments}');
      }

      // Execute Git statistics based on the provided repository path.
      final String repositoryPath = results.rest.isNotEmpty ? results.rest.first : '.';
      final Map<String, dynamic> statistics = await _getGitStatistics(repositoryPath);

      // Print Git statistics.
      print('\nGit Statistics:');
      print(jsonEncode(statistics));

    } on FormatException catch (e) {
      // Print usage information if an invalid argument was provided.
      print(e.message);
      print('');
      printUsage();
    }
  }

  Future<Map<String, dynamic>> _getGitStatistics(String repositoryPath) async {
    final ProcessResult result =
        await Process.run('git', ['log', '--pretty=format:%an', '--numstat'], workingDirectory: repositoryPath);

    if (result.exitCode == 0) {
      final List<String> lines = LineSplitter.split(result.stdout as String).toList();

      final Map<String, dynamic> statistics = {
        'totalCommits': 0,
        'contributors': <String>{},
        'filesChanged': <String, int>{},
      };

      for (final String line in lines) {
        if (line.isNotEmpty) {
          final List<String> parts = line.split('\t');

          if (parts.length == 3) {
            final String author = parts[0];
            final int addedLines = int.tryParse(parts[1]) ?? 0;
            final int deletedLines = int.tryParse(parts[2]) ?? 0;

            statistics['totalCommits']++;
            statistics['contributors'].add(author);
            statistics['filesChanged'][author] ??= 0;
            statistics['filesChanged'][author] += addedLines + deletedLines;
          }
        }
      }

      return statistics;
    } else {
      throw Exception('Error retrieving Git statistics. Make sure the repository path is correct.');
    }
  }
}
