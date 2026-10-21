import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/app_drawer.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  MobileScannerController? _scannerController;
  bool _isScannerActive = false;
  bool _isPermissionDenied = false;

  String? _scannedValue;
  String? _scannedType;
  bool _isUrlValue = false;
  bool _isUTTECUrl = false;
  bool _isProcessingCode = false;

  @override
  void dispose() {
    _scannerController?.dispose();
    super.dispose();
  }

  Future<void> _requestCameraPermissionAndStart() async {
    final status = await Permission.camera.request();

    if (status.isGranted) {
      setState(() {
        _isPermissionDenied = false;
        _isScannerActive = true;
        _scannedValue = null;
        _scannedType = null;
        _isProcessingCode = false;
      });
      _initController();
    } else {
      setState(() {
        _isPermissionDenied = true;
        _isScannerActive = false;
      });
    }
  }

  void _initController() {
    _scannerController?.dispose();
    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      torchEnabled: false,
    );
  }

  void _stopScanner() {
    _scannerController?.stop();
    setState(() {
      _isScannerActive = false;
    });
  }

  String _formatBarcodeType(BarcodeFormat format) {
    switch (format) {
      case BarcodeFormat.qrCode:
        return 'Código QR (QR Code)';
      case BarcodeFormat.code128:
        return 'Código de Barras (Code 128)';
      case BarcodeFormat.code39:
        return 'Código de Barras (Code 39)';
      case BarcodeFormat.code93:
        return 'Código de Barras (Code 93)';
      case BarcodeFormat.ean13:
        return 'Código de Barras (EAN-13)';
      case BarcodeFormat.ean8:
        return 'Código de Barras (EAN-8)';
      case BarcodeFormat.upcA:
        return 'Código de Barras (UPC-A)';
      case BarcodeFormat.upcE:
        return 'Código de Barras (UPC-E)';
      case BarcodeFormat.pdf417:
        return 'Código PDF417 (Credencial/Documento)';
      case BarcodeFormat.dataMatrix:
        return 'Código Data Matrix';
      case BarcodeFormat.aztec:
        return 'Código Aztec';
      case BarcodeFormat.codabar:
        return 'Código Codabar';
      case BarcodeFormat.itf:
        return 'Código ITF';
      default:
        return 'Código de Barras (${format.name.toUpperCase()})';
    }
  }

  bool _checkIsUrl(String value) {
    final uri = Uri.tryParse(value.trim());
    return uri != null &&
        uri.hasScheme &&
        (uri.scheme == 'http' || uri.scheme == 'https');
  }

  bool _checkIsUTTECUrl(String value) {
    final lower = value.toLowerCase();
    return lower.contains('uttec.edu.mx') ||
        lower.contains('uttec.edomex.gob.mx') ||
        lower.contains('uttec');
  }

  void _onBarcodeDetected(BarcodeCapture capture) {
    if (_isProcessingCode) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final firstCode = barcodes.first;
    final String rawValue = firstCode.rawValue ?? '';

    if (rawValue.isEmpty) return;

    setState(() {
      _isProcessingCode = true;
      _scannedValue = rawValue;
      _scannedType = _formatBarcodeType(firstCode.format);
      _isUrlValue = _checkIsUrl(rawValue);
      _isUTTECUrl = _checkIsUTTECUrl(rawValue);
    });

    _stopScanner();

    // Si es una URL (por ejemplo del QR de la universidad UTTEC), abrir en navegador
    if (_isUrlValue) {
      _openUrlInBrowser(rawValue);
    }
  }

  Future<void> _openUrlInBrowser(String urlString) async {
    final Uri? uri = Uri.tryParse(urlString.trim());

    if (uri != null) {
      try {
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('No se pudo abrir el enlace: $urlString'),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al abrir la URL: $e'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      }
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white),
            SizedBox(width: 8),
            Text('Valor copiado al portapapeles'),
          ],
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear QR y Código de Barras'),
        backgroundColor: const Color(0xFF1E3C72),
        foregroundColor: Colors.white,
        actions: [
          if (_isScannerActive) ...[
            IconButton(
              icon: const Icon(Icons.flash_on_rounded),
              tooltip: 'Linterna',
              onPressed: () => _scannerController?.toggleTorch(),
            ),
            IconButton(
              icon: const Icon(Icons.cameraswitch_rounded),
              tooltip: 'Cambiar Cámara',
              onPressed: () => _scannerController?.switchCamera(),
            ),
          ],
        ],
      ),
      drawer: const AppDrawer(),
      body: Container(
        color: const Color(0xFFF4F6FB),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header descriptivo
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                decoration: const BoxDecoration(
                  color: Color(0xFF1E3C72),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Lector de Códigos Barcode / QR',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Escanea códigos de productos, credenciales o el código QR con la URL oficial de la Universidad (UTTEC).',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Área del Escáner o Botón de Activación
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: _buildScannerArea(),
              ),

              const SizedBox(height: 20),

              // Resultados del escaneo
              if (_scannedValue != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: _buildResultCard(),
                ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScannerArea() {
    if (_isPermissionDenied) {
      return Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.camera_alt_rounded,
                    size: 48, color: Colors.red.shade600),
              ),
              const SizedBox(height: 16),
              const Text(
                'Permiso de Cámara Denegado',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3C72),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'La aplicación requiere acceso a la cámara para poder escanear códigos de barras y códigos QR.',
                style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _requestCameraPermissionAndStart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3C72),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.security_rounded),
                label: const Text('Conceder Permiso'),
              ),
            ],
          ),
        ),
      );
    }

    if (_isScannerActive && _scannerController != null) {
      return Column(
        children: [
          Container(
            height: 320,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFF1E3C72), width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                MobileScanner(
                  controller: _scannerController!,
                  onDetect: _onBarcodeDetected,
                ),
                // Marco delimitador del visor de escaneo
                Center(
                  child: Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.amber, width: 2.5),
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.transparent,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Apunta al código de barras o QR',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _stopScanner,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.redAccent,
              side: const BorderSide(color: Colors.redAccent),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.stop_rounded),
            label: const Text('Detener Cámara'),
          ),
        ],
      );
    }

    // Estado inicial: Botón para activar el escáner
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E3C72).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.qr_code_scanner_rounded,
                size: 64,
                color: Color(0xFF1E3C72),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Escáner de Cámara',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3C72),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Presiona el botón para solicitar permiso de cámara y activar la lectura de códigos.',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _requestCameraPermissionAndStart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3C72),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                ),
                icon: const Icon(Icons.camera_alt_rounded, size: 24),
                label: const Text(
                  'Activar Lector / Iniciar Cámara',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _isUrlValue
                        ? Colors.green.shade50
                        : const Color(0xFF1E3C72).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _isUrlValue ? Icons.link_rounded : Icons.qr_code_2_rounded,
                    color: _isUrlValue ? Colors.green.shade700 : const Color(0xFF1E3C72),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Resultado del Escaneo',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        _scannedType ?? 'Código detectado',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3C72),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            if (_isUTTECUrl) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E3C72),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.school_rounded, color: Colors.white, size: 16),
                    SizedBox(width: 6),
                    Text(
                      'URL Oficial Universidad UTTEC',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const Divider(height: 24),

            // Contenido/Valor Leído
            const Text(
              'Valor Leído:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: SelectableText(
                _scannedValue!,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                  color: Color(0xFF1E3C72),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Botones de acción según el resultado
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _copyToClipboard(_scannedValue!),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.copy_rounded, size: 18),
                    label: const Text('Copiar'),
                  ),
                ),
                const SizedBox(width: 12),
                if (_isUrlValue)
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _openUrlInBrowser(_scannedValue!),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.open_in_browser_rounded, size: 18),
                      label: const Text('Abrir URL'),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 12),

            // Botón para volver a escanear
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _requestCameraPermissionAndStart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3C72),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.qr_code_scanner_rounded, size: 20),
                label: const Text(
                  'Escanear Otro Código',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
