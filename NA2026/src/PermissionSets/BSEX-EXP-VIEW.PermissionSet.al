namespace BinaryStream.ExpenseReportManager;

permissionset 77551 "BSEX-EXP-VIEW"
{
    Assignable = true;
    Caption = 'Expense Reports - View';

    Permissions =
        tabledata "BSEX Expense Report Header" = R,
        tabledata "BSEX Expense Report Line" = R,
        tabledata "BSEX Expense Ledger Entry" = R,
        tabledata "BSEX Expense Report Setup" = R,
        table "BSEX Expense Report Header" = X,
        table "BSEX Expense Report Line" = X,
        table "BSEX Expense Ledger Entry" = X,
        table "BSEX Expense Report Setup" = X,
        page "BSEX Expense Reports" = X,
        page "BSEX Posted Expense Reports" = X,
        page "BSEX Expense Report" = X,
        page "BSEX Posted Expense Report" = X,
        page "BSEX Expense Report Subform" = X,
        page "BSEX Expense Ledger Entries" = X,
        page "BSEX Expense Report Setup" = X,
        report "BSEX Expense Summary" = X;
}
