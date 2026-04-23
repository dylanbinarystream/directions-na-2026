namespace BinaryStream.ExpenseReportManager;

permissionset 77500 ExpenseReportMgr
{
    Assignable = true;
    Permissions = tabledata "BSEX Expense Ledger Entry" = RIMD,
        tabledata "BSEX Expense Report Header" = RIMD,
        tabledata "BSEX Expense Report Line" = RIMD,
        tabledata "BSEX Expense Report Setup" = RIMD,
        table "BSEX Expense Ledger Entry" = X,
        table "BSEX Expense Report Header" = X,
        table "BSEX Expense Report Line" = X,
        table "BSEX Expense Report Setup" = X,
        report "BSEX Expense Summary" = X,
        codeunit "BSEX Expense Post" = X,
        codeunit "BSEX Expense Report Mgt" = X,
        page "BSEX Expense Ledger Entries" = X,
        page "BSEX Expense Report" = X,
        page "BSEX Expense Report Setup" = X,
        page "BSEX Expense Report Subform" = X,
        page "BSEX Expense Reports" = X,
        page "BSEX Posted Expense Reports" = X;
}