import 'package:flutter/material.dart';
import 'package:simply_net/services/input_history.dart';

/// A text field that offers previously entered values as a dropdown and
/// remembers new values once editing finishes. Drop-in replacement for a
/// [TextField]: pass the same [controller] and [decoration].
class HistoryField extends StatefulWidget {
  const HistoryField({
    super.key,
    required this.controller,
    required this.historyKey,
    this.focusNode,
    this.decoration = const InputDecoration(),
    this.keyboardType = TextInputType.text,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.enabled = true,
    this.minLines,
    this.maxLines = 1,
  });

  final TextEditingController controller;

  /// Key under which this field's history is persisted.
  final String historyKey;

  /// Optional external focus node; an internal one is used when null.
  final FocusNode? focusNode;

  final InputDecoration decoration;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onEditingComplete;
  final bool enabled;
  final int? minLines;
  final int? maxLines;

  @override
  State<HistoryField> createState() => _HistoryFieldState();
}

class _HistoryFieldState extends State<HistoryField> {
  FocusNode? _internalNode;
  FocusNode get _focusNode => widget.focusNode ?? _internalNode!;
  List<String> _history = [];
  double _fieldWidth = 0;

  @override
  void initState() {
    super.initState();
    if (widget.focusNode == null) _internalNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
    _reload();
  }

  Future<void> _reload() async {
    final h = await InputHistory.load(widget.historyKey);
    if (mounted) setState(() => _history = h);
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) _remember(widget.controller.text);
  }

  Future<void> _remember(String value) async {
    if (value.trim().isEmpty) return;
    final h = await InputHistory.add(widget.historyKey, value);
    if (mounted) setState(() => _history = h);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _internalNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RawAutocomplete<String>(
      textEditingController: widget.controller,
      focusNode: _focusNode,
      optionsBuilder: (value) {
        final text = value.text.trim().toLowerCase();
        if (text.isEmpty) return _history;
        return _history.where(
          (h) => h.toLowerCase().contains(text) && h.toLowerCase() != text,
        );
      },
      onSelected: (selection) {
        widget.onChanged?.call(selection);
        _remember(selection);
      },
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return LayoutBuilder(
          builder: (context, constraints) {
            _fieldWidth = constraints.maxWidth;
            return TextField(
              controller: controller,
              focusNode: focusNode,
              enabled: widget.enabled,
              keyboardType: widget.keyboardType,
              textInputAction: widget.textInputAction,
              minLines: widget.minLines,
              maxLines: widget.maxLines,
              decoration: widget.decoration,
              onChanged: widget.onChanged,
              onEditingComplete: widget.onEditingComplete,
              onSubmitted: (value) {
                onFieldSubmitted();
                _remember(value);
                widget.onSubmitted?.call(value);
              },
            );
          },
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(10),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 240,
                maxWidth: _fieldWidth > 0 ? _fieldWidth : double.infinity,
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, i) {
                  final opt = options.elementAt(i);
                  return ListTile(
                    dense: true,
                    title: Text(opt, overflow: TextOverflow.ellipsis),
                    trailing: IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      tooltip: 'Remove from history',
                      onPressed: () => _removeEntry(opt),
                    ),
                    onTap: () => onSelected(opt),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _removeEntry(String value) async {
    final remaining = _history.where((e) => e != value).toList();
    await InputHistory.replace(widget.historyKey, remaining);
    if (mounted) setState(() => _history = remaining);
  }
}
