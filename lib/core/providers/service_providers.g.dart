// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DrinkService 인스턴스 제공

@ProviderFor(drinkService)
const drinkServiceProvider = DrinkServiceProvider._();

/// DrinkService 인스턴스 제공

final class DrinkServiceProvider
    extends $FunctionalProvider<DrinkService, DrinkService, DrinkService>
    with $Provider<DrinkService> {
  /// DrinkService 인스턴스 제공
  const DrinkServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'drinkServiceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$drinkServiceHash();

  @$internal
  @override
  $ProviderElement<DrinkService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DrinkService create(Ref ref) {
    return drinkService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DrinkService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DrinkService>(value),
    );
  }
}

String _$drinkServiceHash() => r'1283d558ce7b4e111654ae11efed3f3ce376b531';

/// BaseService 인스턴스 제공

@ProviderFor(baseService)
const baseServiceProvider = BaseServiceProvider._();

/// BaseService 인스턴스 제공

final class BaseServiceProvider
    extends $FunctionalProvider<BaseService, BaseService, BaseService>
    with $Provider<BaseService> {
  /// BaseService 인스턴스 제공
  const BaseServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'baseServiceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$baseServiceHash();

  @$internal
  @override
  $ProviderElement<BaseService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BaseService create(Ref ref) {
    return baseService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BaseService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BaseService>(value),
    );
  }
}

String _$baseServiceHash() => r'5bb7f3a3f4f517ec99199768842f085f513bdf06';

/// CommentService 인스턴스 제공

@ProviderFor(commentService)
const commentServiceProvider = CommentServiceProvider._();

/// CommentService 인스턴스 제공

final class CommentServiceProvider
    extends $FunctionalProvider<CommentService, CommentService, CommentService>
    with $Provider<CommentService> {
  /// CommentService 인스턴스 제공
  const CommentServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'commentServiceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$commentServiceHash();

  @$internal
  @override
  $ProviderElement<CommentService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CommentService create(Ref ref) {
    return commentService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CommentService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CommentService>(value),
    );
  }
}

String _$commentServiceHash() => r'2f5f8be9e24be6299b273772e9a6508d452fe50d';

/// RecipeService 인스턴스 제공

@ProviderFor(recipeService)
const recipeServiceProvider = RecipeServiceProvider._();

/// RecipeService 인스턴스 제공

final class RecipeServiceProvider
    extends $FunctionalProvider<RecipeService, RecipeService, RecipeService>
    with $Provider<RecipeService> {
  /// RecipeService 인스턴스 제공
  const RecipeServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'recipeServiceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$recipeServiceHash();

  @$internal
  @override
  $ProviderElement<RecipeService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RecipeService create(Ref ref) {
    return recipeService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecipeService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecipeService>(value),
    );
  }
}

String _$recipeServiceHash() => r'd0d3c637f99bea2c32b17d11e68d092043da905a';
