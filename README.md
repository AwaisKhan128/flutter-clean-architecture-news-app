# Flutter Clean Architecture News App

A Flutter news application built with **Clean Architecture** principles, demonstrating the use of **BLoC** for state management, **Retrofit** for REST API integration, **GetIt** for dependency injection, and proper separation of concerns.

## Features

- Fetch and display top news headlines from [NewsAPI.org](https://newsapi.org/)
- Clean Architecture with Data, Domain, and Presentation layers
- BLoC pattern for predictable state management
- Retrofit-generated API client with Dio
- Dependency injection using GetIt (Service Locator)
- Cached network images for optimized performance
- Error handling with custom DataState wrapper

## Architecture Overview

This project follows **Clean Architecture** with a feature-based folder structure:

```
lib/
├── main.dart
├── injection_container.dart          # GetIt DI setup
├── config/
│   └── theme/
│       └── app_themes.dart           # App theming
├── core/
│   ├── constants/
│   │   └── constants.dart            # API configuration
│   ├── resources/
│   │   └── data_state.dart           # DataSuccess/DataFailed wrapper
│   └── usecases/
│       └── usecase.dart              # Abstract UseCase interface
└── features/
    └── daily_news/
        ├── data/
        │   ├── data_sources/
        │   │   └── remote/
        │   │       └── news_api_service.dart    # Retrofit API
        │   ├── models/
        │   │   └── article.dart                 # Data model
        │   └── repository/
        │       └── article_repository_impl.dart # Repository impl
        ├── domain/
        │   ├── entities/
        │   │   └── article.dart                 # Business entity
        │   ├── repository/
        │   │   └── article_repository.dart      # Repository contract
        │   └── usecases/
        │       └── get_article.dart             # UseCase
        └── presentation/
            ├── bloc/
            │   └── article/
            │       └── remote/
            │           ├── remote_article_bloc.dart
            │           ├── remote_article_event.dart
            │           └── remote_article_state.dart
            ├── pages/
            │   └── home/
            │       └── daily_news.dart          # Main page
            └── widgets/
                └── article/
                    └── article_widget.dart      # Article card
```

## Tech Stack

| Technology | Purpose |
|------------|---------|
| **flutter_bloc** | State management using BLoC pattern |
| **equatable** | Value equality for states and events |
| **get_it** | Service locator for dependency injection |
| **retrofit** | Type-safe REST API client generator |
| **dio** | HTTP networking library |
| **cached_network_image** | Image caching and optimization |
| **intl** | Date formatting and internationalization |

## Data Flow

```
User Action (GetArticles Event)
        ↓
  RemoteArticlesBloc
        ↓
  GetArticleUseCase
        ↓
ArticleRepositoryImpl
        ↓
  NewsApiService (Retrofit)
        ↓
   Dio HTTP Request → NewsAPI.org
        ↓
  DataSuccess / DataFailed
        ↓
BLoC emits new state
        ↓
  UI rebuilds via BlocBuilder
```

## Getting Started

### Prerequisites

- Flutter SDK (3.0+)
- Dart SDK
- News API Key from [newsapi.org](https://newsapi.org/)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd clean_architecture_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure API Key**

   Update the API key in `lib/core/constants/constants.dart`:
   ```dart
   const String newsAPIKey = 'YOUR_API_KEY_HERE';
   ```

4. **Generate Retrofit code** (if needed)
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

## Key Implementation Details

### Dependency Injection (GetIt)

```dart
final sl = GetIt.instance;

Future<void> initializedDependencies() async {
  sl.registerSingleton<Dio>(Dio());
  sl.registerSingleton<NewsApiService>(NewsApiService(sl()));
  sl.registerSingleton<ArticleRepository>(ArticleRepositoryImpl(sl()));
  sl.registerSingleton<GetArticleUseCase>(GetArticleUseCase(sl()));
  sl.registerFactory<RemoteArticlesBloc>(() => RemoteArticlesBloc(sl()));
}
```

### Retrofit API Service

```dart
@RestApi(baseUrl: newsAPIBaseURL)
abstract class NewsApiService {
  factory NewsApiService(Dio dio) = _NewsApiService;

  @GET('/top-headlines')
  Future<HttpResponse<List<ArticleModel>>> getNewsArticles({
    @Query('country') String? country,
    @Query('apiKey') String? apiKey,
    @Query('category') String? category,
  });
}
```

### BLoC State Management

```dart
class RemoteArticlesBloc extends Bloc<RemoteArticlesEvent, RemoteArticlesState> {
  final GetArticleUseCase _getArticleUseCase;

  RemoteArticlesBloc(this._getArticleUseCase) : super(RemoteArticlesLoading()) {
    on<GetArticles>(onGetArticles);
  }

  void onGetArticles(GetArticles event, Emitter<RemoteArticlesState> emit) async {
    final dataState = await _getArticleUseCase();
    if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
      emit(RemoteArticlesDone(dataState.data!));
    }
    if (dataState is DataFailed) {
      emit(RemoteArticlesError(dataState.error!));
    }
  }
}
```

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [BLoC Library](https://bloclibrary.dev/)
- [Retrofit Dart](https://pub.dev/packages/retrofit)
- [GetIt Package](https://pub.dev/packages/get_it)
- [News API Documentation](https://newsapi.org/docs)
