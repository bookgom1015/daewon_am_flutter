import 'dart:io';
import 'package:daewon_am/components/entries/accounting_data.dart';
import 'package:daewon_am/components/helpers/format_manager.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class ExcelManager {
  static Future<void> importAccountingData({
    required void Function(List<AccountingData> dataList) onFinised,
  }) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [ "xlsx" ],
        lockParentWindow: true
      );
      if (result == null || result.files.isEmpty) return;

      final fileName = result.files.single.path!;
      final bytes = await File(fileName).readAsBytes();    
      final excel = Excel.decodeBytes(bytes);
      if (!excel.sheets.containsKey("세금계산서")) throw Exception("올바르지 않은 파일입니다");

      final sheet = excel.sheets["세금계산서"]!;

      final titleCell = sheet.cell(CellIndex.indexByColumnRow(rowIndex: 4, columnIndex: 0));
      final title = titleCell.value.toString();
      final dataType = title.contains("매입");
      int clientNameColumnIndex = dataType ? 6 : 11;

      List<AccountingData> dataList = [];
      for (int row = 6, end = sheet.maxRows; row < end; ++row) {
        //
        // 날짜는 작성일자를 기준으로
        //
        final dateCell = sheet.cell(CellIndex.indexByColumnRow(rowIndex: row, columnIndex: 0));
        if (dateCell.value == null) continue;
        DateTime date;
        try {
          date = DateTime.parse(dateCell.value.toString());
        }
        catch (e) {
          continue;
        }

        //
        // 거래처
        //
        final clientNameCell = sheet.cell(CellIndex.indexByColumnRow(rowIndex: row, columnIndex: clientNameColumnIndex));
        if (clientNameCell.value == null) continue;
        String clientName = clientNameCell.value.toString();

        //
        // 공급가
        //
        final supplyPriceCell = sheet.cell(CellIndex.indexByColumnRow(rowIndex: row, columnIndex: 15));
        int supplyPrice;
        try {
          supplyPrice = int.parse(supplyPriceCell.value == null ? "0" : supplyPriceCell.value.toString());
        }
        catch (e) {
          supplyPrice = 0;
        }

        //
        // 세엑
        //
        final taxAmountCell = sheet.cell(CellIndex.indexByColumnRow(rowIndex: row, columnIndex: 16));
        int taxAmount;
        try {
          taxAmount = int.parse(taxAmountCell.value == null ? "0" : taxAmountCell.value.toString());
        }
        catch (e) {
          taxAmount = 0;
        }

        //
        // 품목 수량을 중량으로
        //
        final steelWeightCell = sheet.cell(CellIndex.indexByColumnRow(rowIndex: row, columnIndex: 28));
        double steelWeight;
        try {
          steelWeight = double.parse(steelWeightCell.value == null ? "0.0" : steelWeightCell.value.toString());
        }
        catch (e) {
          steelWeight = 0;
        }


        //
        // 단가
        //
        final unitPriceCell = sheet.cell(CellIndex.indexByColumnRow(rowIndex: row, columnIndex: 29));
        int unitPrice;
        try {
          unitPrice = int.parse(unitPriceCell.value == null ? "0" : unitPriceCell.value.toString());
        }
        catch (e) {
          unitPrice = 0;
        }

        final data = AccountingData(
          clientName: clientName, 
          date: date, 
          steelWeight: steelWeight, 
          supplyPrice: supplyPrice, 
          taxAmount: taxAmount, 
          unitPrice: unitPrice,
          dataType: dataType,
        );

        dataList.add(data);
      }      

      onFinised(dataList);
    }
    catch (e) {
      rethrow;
    }    
  }

  static Future<void> exportAccountingData({
    required List<AccountingData> dataList,
    String title = "output",
  }) async {
    final workbook = Workbook();
    final sheet = workbook.worksheets[0];
    sheet.name = "Sheet";

    //
    // 매출입
    //
    final dataTypeCell = sheet.getRangeByIndex(1, 1);
    dataTypeCell.columnWidth = 16;
    dataTypeCell.value = "매입/매출";
    dataTypeCell.cellStyle.hAlign = HAlignType.center;

    //
    // 거래처
    //
    final clientNameCell = sheet.getRangeByIndex(1, 2);
    clientNameCell.columnWidth = 18;
    clientNameCell.value = "거래처";
    clientNameCell.cellStyle.hAlign = HAlignType.center;

    //
    // 날짜
    //
    final dateCell = sheet.getRangeByIndex(1, 3);
    dateCell.columnWidth = 12;
    dateCell.value = "날짜";
    dateCell.cellStyle.hAlign = HAlignType.center;

    //
    // 중량
    //
    final steelWeightCell = sheet.getRangeByIndex(1, 4);
    steelWeightCell.columnWidth = 12;
    steelWeightCell.value = "중량";
    steelWeightCell.cellStyle.hAlign = HAlignType.center;

    //
    // 공급가
    //
    final supplyPriceCell = sheet.getRangeByIndex(1, 5);
    supplyPriceCell.columnWidth = 18;
    supplyPriceCell.value = "공급가";
    supplyPriceCell.cellStyle.hAlign = HAlignType.center;

    //
    // 세액
    //
    final taxAmountCell = sheet.getRangeByIndex(1, 6);
    taxAmountCell.columnWidth = 18;
    taxAmountCell.value = "세액";
    taxAmountCell.cellStyle.hAlign = HAlignType.center;

    //
    // 단가
    //
    final unitPriceCell = sheet.getRangeByIndex(1, 7);
    unitPriceCell.columnWidth = 18;
    unitPriceCell.value = "단가";
    unitPriceCell.cellStyle.hAlign = HAlignType.center;

    //
    // 합계
    //
    final sumCell = sheet.getRangeByIndex(1, 8);
    sumCell.columnWidth = 18;
    sumCell.value = "합계";
    sumCell.cellStyle.hAlign = HAlignType.center;

    //
    // 입금날짜
    //
    final depositDateCell = sheet.getRangeByIndex(1, 9);
    depositDateCell.columnWidth = 12;
    depositDateCell.value = "입금날짜";
    depositDateCell.cellStyle.hAlign = HAlignType.center;

    //
    // 데이터 쓰기
    //
    int row = 2;
    for (final data in dataList) {
      final dataTypeCell = sheet.getRangeByIndex(row, 1);
      dataTypeCell.value = data.dataType ? "매입" : "매출";
      dataTypeCell.cellStyle.hAlign = HAlignType.center;

      final clientNameCell = sheet.getRangeByIndex(row, 2);
      clientNameCell.value = data.clientName;
      clientNameCell.cellStyle.hAlign = HAlignType.left;
      clientNameCell.cellStyle.indent = 1;

      final dateCell = sheet.getRangeByIndex(row, 3);
      dateCell.value = FormatManager.dateTimeToString(data.date);
      dateCell.cellStyle.hAlign = HAlignType.center;

      final steelWeightCell = sheet.getRangeByIndex(row, 4);
      steelWeightCell.value = data.steelWeight;
      steelWeightCell.cellStyle.hAlign = HAlignType.right;
      steelWeightCell.cellStyle.numberFormat = "#,##0.0";
      steelWeightCell.cellStyle.indent = 1;

      final supplyPriceCell = sheet.getRangeByIndex(row, 5);
      supplyPriceCell.value = data.supplyPrice;
      supplyPriceCell.cellStyle.hAlign = HAlignType.right;
      supplyPriceCell.cellStyle.numberFormat = "#,##0";
      supplyPriceCell.cellStyle.indent = 1;

      final taxAmountCell = sheet.getRangeByIndex(row, 6);
      taxAmountCell.value = data.taxAmount;
      taxAmountCell.cellStyle.hAlign = HAlignType.right;
      taxAmountCell.cellStyle.numberFormat = "#,##0";
      taxAmountCell.cellStyle.indent = 1;

      final unitPriceCell = sheet.getRangeByIndex(row, 7);
      unitPriceCell.value = data.unitPrice;
      unitPriceCell.cellStyle.hAlign = HAlignType.right;
      unitPriceCell.cellStyle.numberFormat = "#,##0";
      unitPriceCell.cellStyle.indent = 1;

      final sumCell = sheet.getRangeByIndex(row, 8);
      sumCell.value = data.supplyPrice + data.taxAmount;
      sumCell.cellStyle.hAlign = HAlignType.right;
      sumCell.cellStyle.numberFormat = "#,##0";
      sumCell.cellStyle.indent = 1;

      final depositDateCell = sheet.getRangeByIndex(row, 9);
      depositDateCell.value = (!data.depositConfirmed || data.depositDate == null) ? 
        "" : FormatManager.dateTimeToString(data.depositDate!);
      depositDateCell.cellStyle.hAlign = HAlignType.center;

      ++row;
    }

    sheet.autoFilters.filterRange = sheet.getRangeByIndex(1, 1, row - 1, 2);

    final bytes = workbook.saveAsStream();
    workbook.dispose();
    
    var fileName = await FilePicker.platform.saveFile(
      type: FileType.custom,
      allowedExtensions: ["xlsx"],
      fileName: "$title.xlsx",
      lockParentWindow: true
    );    
    if (fileName == null) return;
    if (!fileName.contains(".xlsx")) fileName = "$fileName.xlsx";
    
    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush: true);
  }
}