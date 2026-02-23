import 'dart:ui';

abstract final class AppConstants {
  // API
  static const String baseUrl = 'https://rickandmortyapi.com/api';
  static const String charactersEndpoint = '$baseUrl/character';
  static const String episodesEndpoint = '$baseUrl/episode';

  // Pagination
  static const int pageSize = 20;

  // UI
  static const double cardBorderRadius = 16.0;
  static const double cardElevation = 4.0;
  static const double cardShadowBlurRadius = 8.0;
  static const double avatarSize = 80.0;
  static const double detailAvatarSize = 120.0;
  static const double cardPadding = 12.0;
  static const double screenPadding = 16.0;
  static const double itemSpacing = 12.0;
  static const Color appcolor = Color(0xFF00B4D8);

  // Strings
  static const String appName = 'Rick & Morty';
  static const String noInternetMessage =
      'No internet connection. Please check your network.';
  static const String genericErrorMessage =
      'Something went wrong. Please try again.';
  static const String noCharactersFound = 'No characters found.';
  static const String noEpisodesFound = 'No episodes found.';
  static const String retryButtonText = 'Retry';
  static const String searchHint = 'Search characters...';
  static const String statusAlive = 'Alive';
  static const String statusDead = 'Dead';
  static const String statusUnknown = 'Unknown';
}
