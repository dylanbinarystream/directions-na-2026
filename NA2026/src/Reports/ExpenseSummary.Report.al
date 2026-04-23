namespace BinaryStream.ExpenseReportManager;

report 77500 "BSEX Expense Summary"
{
    Caption = 'Expense Summary';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    DefaultRenderingLayout = Layout;

    dataset
    {
        dataitem(Ledger; "BSEX Expense Ledger Entry")
        {
            RequestFilterFields = "Posting Date", "Employee No.", Category;
            column(EntryNo; "Entry No.") { }
            column(PostingDate; Format("Posting Date")) { }
            column(DocumentNo; "Document No.") { }
            column(EmployeeNo; "Employee No.") { }
            column(EmployeeName; "Employee Name") { }
            column(Category; Format(Category)) { }
            column(Description; Description) { }
            column(Merchant; Merchant) { }
            column(Amount; Amount) { }
            column(Reimbursable; Reimbursable) { }
            column(CompanyName; CompanyName()) { }
            column(UserName; UserId()) { }
            column(PrintedOn; Format(CurrentDateTime())) { }
        }
    }

    rendering
    {
        layout(Layout)
        {
            Type = RDLC;
            LayoutFile = './src/Reports/ExpenseSummary.rdl';
        }
    }
}
