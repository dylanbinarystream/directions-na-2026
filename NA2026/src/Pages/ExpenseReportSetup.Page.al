namespace BinaryStream.ExpenseReportManager;

page 77505 "BSEX Expense Report Setup"
{
    Caption = 'Expense Report Setup';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "BSEX Expense Report Setup";
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(Numbering)
            {
                Caption = 'Numbering';
                field("Expense Report Nos."; Rec."Expense Report Nos.") { ApplicationArea = All; }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.GetRecordOnce();
    end;
}
