class pendingInvoice {
  final InvoiceInfo info;
  final List<pendingEntry> pendingInvoiceItems;

  const pendingInvoice({
    required this.info,
    required this.pendingInvoiceItems,
  });
}

class pendingEntry {
  final String name;
  final String mobile;
  final String amount;

  const pendingEntry({
    required this.name,
    required this.mobile,
    required this.amount,
  });
}

class InvoiceInfo {
  final String formula;
  final String year;
  final String sortingType;

  const InvoiceInfo({
    required this.formula,
    required this.year,
    required this.sortingType,
  });
}
