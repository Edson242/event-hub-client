// lib/services/location_service.dart
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  // Singleton Pattern
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  /// Verifica e solicita permissões de GPS
  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verifica se o serviço de localização (GPS) está ativado no aparelho
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  /// Retorna a posição atual formatada em "lat, lng"
  Future<String?> getCurrentLocationString() async {
    final hasPermission = await _handlePermission();
    if (!hasPermission) return null;

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10), // Evita travar o app
      );
      return '${position.latitude.toStringAsFixed(5)}, ${position.longitude.toStringAsFixed(5)}';
    } catch (e) {
      print("Erro ao obter GPS: $e");
      return null;
    }
  }

  /// (NOVO) Traduz coordenadas arbitrárias (vindas do Banco de Dados) para endereço
  Future<String?> getAddressFromCoordinates(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        lat,
        lng,
        localeIdentifier: "pt_BR", // Força retorno em Português
      );

      if (placemarks.isNotEmpty) {
        return _formatPlacemark(placemarks.first);
      }
    } catch (e) {
      print("Erro ao fazer geocoding reverso: $e");
    }
    return null;
  }

  /// Pega a localização atual do GPS e já traduz para cidade/endereço
  Future<String?> getCurrentCity() async {
    final hasPermission = await _handlePermission();
    if (!hasPermission) return null; // Deixe a UI tratar a falta de permissão

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      return await getAddressFromCoordinates(
        position.latitude,
        position.longitude,
      );
    } catch (e) {
      return null;
    }
  }

  /// Método auxiliar para formatar o texto de forma limpa
  String _formatPlacemark(Placemark place) {
    // Lista para montar o endereço na ordem correta
    final components = <String>[];

    // 1. Rua (thoroughfare)
    if (place.thoroughfare != null && place.thoroughfare!.isNotEmpty) {
      String street = place.thoroughfare!;

      // Tenta adicionar o número (subThoroughfare) se existir
      if (place.subThoroughfare != null && place.subThoroughfare!.isNotEmpty) {
        street += ", ${place.subThoroughfare}";
      }
      components.add(street); // Ex: "Av. Paulista, 1000"
    }

    // 2. Bairro (subLocality)
    if (place.subLocality != null && place.subLocality!.isNotEmpty) {
      components.add(place.subLocality!);
    }

    // 3. Cidade e Estado
    if (place.locality != null && place.locality!.isNotEmpty) {
      String city = place.locality!;
      if (place.administrativeArea != null &&
          place.administrativeArea!.isNotEmpty) {
        city += " - ${place.administrativeArea}"; // Ex: "Chapecó - SC"
      }
      components.add(city);
    }
    // Fallback: se não tiver cidade, mas tiver estado
    else if (place.administrativeArea != null &&
        place.administrativeArea!.isNotEmpty) {
      components.add(place.administrativeArea!);
    }

    // Resultado final: Junta tudo com " • " ou ", " (você escolhe o separador)
    // Ex: "Av. Brasil, 500 • Centro • São Miguel do Oeste - SC"
    if (components.isEmpty) return "Endereço não identificado";

    return components.join(" • ");
  }

  /// (NOVO) Converte um endereço em texto para coordenadas "lat, lng"
  Future<String?> getCoordinatesFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(
        address,
        localeIdentifier: "pt_BR",
      );

      if (locations.isNotEmpty) {
        final loc = locations.first;
        return '${loc.latitude}, ${loc.longitude}';
      }
    } catch (e) {
      print("Erro ao fazer geocoding (endereço -> coords): $e");
    }
    return null;
  }
}
