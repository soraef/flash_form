import 'package:flash_form/flash_form.dart';
import 'package:flutter/material.dart';

import 'field_schema.dart';

abstract class FieldLayout {
  const FieldLayout();

  Widget build();
}
