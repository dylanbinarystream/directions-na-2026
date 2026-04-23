namespace BinaryStream.ExpenseReportManager;

enum 77500 "BSEX Expense Status"
{
    Extensible = false;
    Caption = 'Expense Status';

    value(0; Draft) { Caption = 'Draft'; }
    value(1; Submitted) { Caption = 'Submitted'; }
    value(2; Approved) { Caption = 'Approved'; }
    value(3; Posted) { Caption = 'Posted'; }
}
