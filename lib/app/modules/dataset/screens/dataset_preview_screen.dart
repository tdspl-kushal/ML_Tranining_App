import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pluto_grid/pluto_grid.dart';

// ---------------------------------------------------------------------------
// Model
// ---------------------------------------------------------------------------

class _DatasetPreview {
  final String datasetId;
  final String originalFilename;
  final int rowCount;
  final int colCount;
  final List<String> columns;
  final List<Map<String, dynamic>> rows;

  const _DatasetPreview({
    required this.datasetId,
    required this.originalFilename,
    required this.rowCount,
    required this.colCount,
    required this.columns,
    required this.rows,
  });

  factory _DatasetPreview.fromJson(Map<String, dynamic> json) {
    return _DatasetPreview(
      datasetId: json['dataset_id'] as String? ?? '',
      originalFilename: json['original_filename'] as String? ?? '',
      rowCount: json['row_count'] as int? ?? 0,
      colCount: json['col_count'] as int? ?? 0,
      columns: List<String>.from(json['columns'] as List? ?? []),
      rows: List<Map<String, dynamic>>.from(
        (json['rows'] as List? ?? []).map((e) => Map<String, dynamic>.from(e as Map)),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Widget
// ---------------------------------------------------------------------------

/// A self-contained [StatefulWidget] that fetches a dataset preview from the
/// local ML Platform API and renders it in an interactive [PlutoGrid].
///
/// Required parameter:
/// - [datasetId] – The UUID of the dataset to preview.
///
/// Dependencies (add to pubspec.yaml if not already present):
/// ```yaml
/// dependencies:
///   http: ^1.2.0
///   pluto_grid: ^8.0.0
/// ```
class DatasetPreviewScreen extends StatefulWidget {
  const DatasetPreviewScreen({super.key, required this.datasetId});

  /// The UUID of the dataset to preview.
  final String datasetId;

  @override
  State<DatasetPreviewScreen> createState() => _DatasetPreviewScreenState();
}

class _DatasetPreviewScreenState extends State<DatasetPreviewScreen> {
  // ── State ────────────────────────────────────────────────────────────────

  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  _DatasetPreview? _preview;

  // PlutoGrid requires keeping hold of the controller once the grid is built.
  PlutoGridStateManager? _gridStateManager;

  // ── Lifecycle ────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _fetchPreview();
  }

  // ── Data Fetching ────────────────────────────────────────────────────────

  Future<void> _fetchPreview() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
    });

    try {
      final uri = Uri.parse(
        'http://localhost:8000/v1/dataset/${widget.datasetId}/preview?limit=10',
      );

      final response = await http.get(
        uri,
        headers: {'Accept': 'application/json'},
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw Exception('Request timed out after 15 seconds.'),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        setState(() {
          _preview = _DatasetPreview.fromJson(json);
          _isLoading = false;
        });
      } else {
        final body = response.body;
        String detail = 'Unknown error';
        try {
          final decoded = jsonDecode(body) as Map<String, dynamic>;
          detail = decoded['detail']?.toString() ?? body;
        } catch (_) {
          detail = body;
        }
        setState(() {
          _hasError = true;
          _errorMessage = 'Server returned ${response.statusCode}: $detail';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  // ── PlutoGrid Builders ───────────────────────────────────────────────────

  /// Dynamically builds [PlutoColumn] list from the API column names.
  List<PlutoColumn> _buildColumns(List<String> columnNames) {
    return columnNames.map((name) {
      return PlutoColumn(
        title: name,
        field: name,
        type: PlutoColumnType.text(),
        width: 160,
        minWidth: 80,
        enableEditingMode: false,
        enableSorting: false,
        enableFilterMenuItem: false,
        enableContextMenu: false,
        enableColumnDrag: false,
        enableDropToResize: false,
        enableHideColumnMenuItem: false,
        enableSetColumnsMenuItem: false,
      );
    }).toList();
  }

  /// Dynamically builds [PlutoRow] list from the API rows payload.
  List<PlutoRow> _buildRows(
    List<Map<String, dynamic>> rows,
    List<String> columnNames,
  ) {
    return rows.map((rowMap) {
      final cells = <String, PlutoCell>{};
      for (final col in columnNames) {
        final value = rowMap[col];
        // Stringify every value so PlutoColumnType.text() never chokes.
        cells[col] = PlutoCell(value: value?.toString() ?? '');
      }
      return PlutoRow(cells: cells);
    }).toList();
  }

  // ── UI Helpers ───────────────────────────────────────────────────────────

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Fetching dataset preview…'),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 56, color: Colors.redAccent),
            const SizedBox(height: 16),
            const Text(
              'Failed to load preview',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _fetchPreview,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid(_DatasetPreview preview) {
    final columns = _buildColumns(preview.columns);
    final rows = _buildRows(preview.rows, preview.columns);

    return Expanded(
      child: PlutoGrid(
        columns: columns,
        rows: rows,
        onLoaded: (PlutoGridOnLoadedEvent event) {
          _gridStateManager = event.stateManager;
          _gridStateManager!.setShowColumnFilter(false);
          _gridStateManager!.setSelectingMode(PlutoGridSelectingMode.none);
        },
        mode: PlutoGridMode.normal,
        configuration: PlutoGridConfiguration(
          style: PlutoGridStyleConfig(
            enableGridBorderShadow: true,
            gridBorderColor: Colors.grey.shade300,
            borderColor: Colors.grey.shade300,
            activatedBorderColor: Colors.indigo.shade400,
            activatedColor: Colors.indigo.shade50,
            gridBackgroundColor: Colors.white,
            rowColor: Colors.white,
            oddRowColor: Colors.grey.shade50,
            columnTextStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: Colors.black87,
            ),
            cellTextStyle: const TextStyle(
              fontSize: 13,
              color: Colors.black87,
            ),
          ),
          columnSize: const PlutoGridColumnSizeConfig(
            autoSizeMode: PlutoAutoSizeMode.scale,
          ),
        ),
        noRowsWidget: const Center(
          child: Text(
            'No rows returned by the API.',
            style: TextStyle(color: Colors.black45),
          ),
        ),
      ),
    );
  }

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final appBarTitle = _preview != null
        ? _preview!.originalFilename
        : 'Dataset Preview';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          appBarTitle,
          style: const TextStyle(fontSize: 15),
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          if (!_isLoading)
            IconButton(
              tooltip: 'Refresh',
              icon: const Icon(Icons.refresh),
              onPressed: _fetchPreview,
            ),
          if (_preview != null) ...[
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Chip(
                avatar: const Icon(Icons.table_rows_outlined, size: 16),
                label: Text(
                  '${_preview!.rowCount} rows · ${_preview!.colCount} cols',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          ],
        ],
      ),
      body: Column(
        children: [
          if (_isLoading) Expanded(child: _buildLoadingState()),
          if (_hasError) Expanded(child: _buildErrorState()),
          if (!_isLoading && !_hasError && _preview != null)
            _buildGrid(_preview!),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// DatasetPreviewGrid — embeddable, Scaffold-free version
// ---------------------------------------------------------------------------

/// A compact, embeddable version of the dataset preview that renders a
/// [PlutoGrid] without any [Scaffold] or [AppBar].
///
/// Designed to be placed inside a fixed-height [SizedBox] within a dialog or
/// any other constrained parent.
///
/// ```dart
/// SizedBox(
///   height: 320,
///   child: DatasetPreviewGrid(datasetId: myId),
/// )
/// ```
class DatasetPreviewGrid extends StatefulWidget {
  const DatasetPreviewGrid({super.key, required this.datasetId});

  final String datasetId;

  @override
  State<DatasetPreviewGrid> createState() => _DatasetPreviewGridState();
}

class _DatasetPreviewGridState extends State<DatasetPreviewGrid> {
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  _DatasetPreview? _preview;
  PlutoGridStateManager? _gridStateManager;

  @override
  void initState() {
    super.initState();
    _fetchPreview();
  }

  Future<void> _fetchPreview() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
    });

    try {
      final uri = Uri.parse(
        'http://localhost:8000/v1/dataset/${widget.datasetId}/preview?limit=10',
      );

      final response = await http.get(
        uri,
        headers: {'Accept': 'application/json'},
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw Exception('Request timed out after 15 seconds.'),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        setState(() {
          _preview = _DatasetPreview.fromJson(json);
          _isLoading = false;
        });
      } else {
        final body = response.body;
        String detail = 'Unknown error';
        try {
          final decoded = jsonDecode(body) as Map<String, dynamic>;
          detail = decoded['detail']?.toString() ?? body;
        } catch (_) {
          detail = body;
        }
        setState(() {
          _hasError = true;
          _errorMessage = 'Server returned ${response.statusCode}: $detail';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  List<PlutoColumn> _buildColumns(List<String> columnNames) {
    return columnNames.map((name) {
      return PlutoColumn(
        title: name,
        field: name,
        type: PlutoColumnType.text(),
        width: 150,
        minWidth: 80,
        enableEditingMode: false,
        enableSorting: false,
        enableFilterMenuItem: false,
        enableContextMenu: false,
        enableColumnDrag: false,
        enableDropToResize: false,
        enableHideColumnMenuItem: false,
        enableSetColumnsMenuItem: false,
      );
    }).toList();
  }

  List<PlutoRow> _buildRows(
    List<Map<String, dynamic>> rows,
    List<String> columnNames,
  ) {
    return rows.map((rowMap) {
      final cells = <String, PlutoCell>{};
      for (final col in columnNames) {
        cells[col] = PlutoCell(value: rowMap[col]?.toString() ?? '');
      }
      return PlutoRow(cells: cells);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
            SizedBox(height: 12),
            Text(
              'Loading preview…',
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),
      );
    }

    if (_hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.redAccent, size: 36),
              const SizedBox(height: 8),
              Text(
                _errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _fetchPreview,
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Retry', style: TextStyle(fontSize: 13)),
              ),
            ],
          ),
        ),
      );
    }

    if (_preview == null) return const SizedBox.shrink();

    final columns = _buildColumns(_preview!.columns);
    final rows = _buildRows(_preview!.rows, _preview!.columns);

    return PlutoGrid(
      columns: columns,
      rows: rows,
      onLoaded: (event) {
        _gridStateManager = event.stateManager;
        _gridStateManager!.setShowColumnFilter(false);
        _gridStateManager!.setSelectingMode(PlutoGridSelectingMode.none);
      },
      mode: PlutoGridMode.normal,
      configuration: PlutoGridConfiguration(
        style: PlutoGridStyleConfig(
          enableGridBorderShadow: true,
          gridBorderColor: Colors.grey.shade300,
          borderColor: Colors.grey.shade300,
          activatedBorderColor: Colors.teal.shade400,
          activatedColor: Colors.teal.shade50,
          gridBackgroundColor: Colors.white,
          rowColor: Colors.white,
          oddRowColor: const Color(0xFFF9FAFB),
          columnTextStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: Colors.black87,
          ),
          cellTextStyle: const TextStyle(
            fontSize: 12,
            color: Colors.black87,
          ),
        ),
        columnSize: const PlutoGridColumnSizeConfig(
          autoSizeMode: PlutoAutoSizeMode.scale,
        ),
      ),
      noRowsWidget: const Center(
        child: Text(
          'No rows returned.',
          style: TextStyle(color: Colors.black45, fontSize: 12),
        ),
      ),
    );
  }
}
