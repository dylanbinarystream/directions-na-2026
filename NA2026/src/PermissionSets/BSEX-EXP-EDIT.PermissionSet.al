namespace BinaryStream.ExpenseReportManager;

permissionset 77550 "BSEX-EXP-EDIT"
{
    Assignable = true;
    Caption = 'Expense Reports - Edit';

    Permissions =
        tabledata "BSEX Expense Report Header" = RIMD,
        tabledata "BSEX Expense Report Line" = RIMD,
        tabledata "BSEX Expense Ledger Entry" = RIMD,
        tabledata "BSEX Expense Report Setup" = RM,
        table "BSEX Expense Report Header" = X,
        table "BSEX Expense Report Line" = X,
        table "BSEX Expense Ledger Entry" = X,
        table "BSEX Expense Report Setup" = X,
        page "BSEX Expense Reports" = X,
        page "BSEX Posted Expense Reports" = X,
        page "BSEX Expense Report" = X,
        page "BSEX Expense Report Subform" = X,
        page "BSEX Expense Ledger Entries" = X,
        page "BSEX Expense Report Setup" = X,
        codeunit "BSEX Expense Report Mgt" = X,
        codeunit "BSEX Expense Post" = X,
        report "BSEX Expense Summary" = X;
}
