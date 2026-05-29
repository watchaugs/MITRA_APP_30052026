// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FeatureFlagsAdapter extends TypeAdapter<FeatureFlags> {
  @override
  final int typeId = 0;

  @override
  FeatureFlags read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FeatureFlags(
      isArEnabled: fields[0] as bool,
      isQuizEnabled: fields[1] as bool,
      isLeaderboardEnabled: fields[2] as bool,
      isAdsEnabled: fields[3] as bool,
      isOfflineEnabled: fields[4] as bool,
      isTeacherModeEnabled: fields[5] as bool,
      isParentalConsentRequired: fields[6] as bool,
      isBilingualEnabled: fields[7] as bool,
      isRentalBookingActive: fields[8] as bool,
      isExpeditionVideoActive: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, FeatureFlags obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.isArEnabled)
      ..writeByte(1)
      ..write(obj.isQuizEnabled)
      ..writeByte(2)
      ..write(obj.isLeaderboardEnabled)
      ..writeByte(3)
      ..write(obj.isAdsEnabled)
      ..writeByte(4)
      ..write(obj.isOfflineEnabled)
      ..writeByte(5)
      ..write(obj.isTeacherModeEnabled)
      ..writeByte(6)
      ..write(obj.isParentalConsentRequired)
      ..writeByte(7)
      ..write(obj.isBilingualEnabled)
      ..writeByte(8)
      ..write(obj.isRentalBookingActive)
      ..writeByte(9)
      ..write(obj.isExpeditionVideoActive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FeatureFlagsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BrandingConfigAdapter extends TypeAdapter<BrandingConfig> {
  @override
  final int typeId = 1;

  @override
  BrandingConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BrandingConfig(
      primaryColor: fields[0] as String,
      secondaryColor: fields[1] as String,
      logoUrl: fields[2] as String,
      appName: fields[3] as String,
      tagline: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BrandingConfig obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.primaryColor)
      ..writeByte(1)
      ..write(obj.secondaryColor)
      ..writeByte(2)
      ..write(obj.logoUrl)
      ..writeByte(3)
      ..write(obj.appName)
      ..writeByte(4)
      ..write(obj.tagline);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrandingConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NavItemAdapter extends TypeAdapter<NavItem> {
  @override
  final int typeId = 2;

  @override
  NavItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NavItem(
      id: fields[0] as String,
      labelKey: fields[1] as String,
      icon: fields[2] as String,
      order: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, NavItem obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.labelKey)
      ..writeByte(2)
      ..write(obj.icon)
      ..writeByte(3)
      ..write(obj.order);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NavItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AppConfigAdapter extends TypeAdapter<AppConfig> {
  @override
  final int typeId = 3;

  @override
  AppConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppConfig(
      stateCode: fields[0] as String,
      stateName: fields[1] as String,
      features: fields[2] as FeatureFlags,
      branding: fields[3] as BrandingConfig,
      navItems: (fields[4] as List).cast<NavItem>(),
      supportedLanguages: (fields[5] as List).cast<String>(),
      defaultLanguage: fields[6] as String,
      curriculumBoard: fields[7] as String,
      minClassGrade: fields[8] as int,
      maxClassGrade: fields[9] as int,
      syncedAt: fields[10] as String,
      emergencyAlert: fields[11] as String,
      deviceTier: fields[12] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AppConfig obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.stateCode)
      ..writeByte(1)
      ..write(obj.stateName)
      ..writeByte(2)
      ..write(obj.features)
      ..writeByte(3)
      ..write(obj.branding)
      ..writeByte(4)
      ..write(obj.navItems)
      ..writeByte(5)
      ..write(obj.supportedLanguages)
      ..writeByte(6)
      ..write(obj.defaultLanguage)
      ..writeByte(7)
      ..write(obj.curriculumBoard)
      ..writeByte(8)
      ..write(obj.minClassGrade)
      ..writeByte(9)
      ..write(obj.maxClassGrade)
      ..writeByte(10)
      ..write(obj.syncedAt)
      ..writeByte(11)
      ..write(obj.emergencyAlert)
      ..writeByte(12)
      ..write(obj.deviceTier);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
