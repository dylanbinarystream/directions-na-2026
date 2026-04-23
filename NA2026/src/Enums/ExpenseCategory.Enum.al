namespace BinaryStream.ExpenseReportManager;

enum 77501 "BSEX Expense Category"
{
    Extensible = true;
    Caption = 'Expense Category';

    value(0; " ") { Caption = ' '; }
    value(1; Travel) { Caption = 'Travel'; }
    value(2; Meals) { Caption = 'Meals'; }
    value(3; Lodging) { Caption = 'Lodging'; }
    value(4; Supplies) { Caption = 'Supplies'; }
    value(5; Other) { Caption = 'Other'; }
}
