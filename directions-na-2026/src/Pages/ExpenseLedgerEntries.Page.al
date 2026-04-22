namespace BinaryStream.ExpenseReportManager;

page 77504 "BSEX Expense Ledger Entries"
{
    Caption = 'Expense Ledger Entries';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = History;
    SourceTable = "BSEX Expense Ledger Entry";
    Editable = false;
    SourceTableView = sorting("Entry No.") order(descending);

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.") { ApplicationArea = All; }
                field("Posting Date"; Rec."Posting Date") { ApplicationArea = All; }
                field("Document No."; Rec."Document No.") { ApplicationArea = All; }
                field("Employee No."; Rec."Employee No.") { ApplicationArea = All; }
                field("Employee Name"; Rec."Employee Name") { ApplicationArea = All; }
                field(Category; Rec.Category) { ApplicationArea = All; }
                field(Description; Rec.Description) { ApplicationArea = All; }
                field(Merchant; Rec.Merchant) { ApplicationArea = All; }
                field(Amount; Rec.Amount) { ApplicationArea = All; }
                field(Reimbursable; Rec.Reimbursable) { ApplicationArea = All; }
                field("Source Report No."; Rec."Source Report No.") { ApplicationArea = All; }
                field("User ID"; Rec."User ID") { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(RunSummary)
            {
                ApplicationArea = All;
                Caption = 'Expense Summary';
                Image = "Report";
                trigger OnAction()
                var
                    Ledger: Record "BSEX Expense Ledger Entry";
                begin
                    Ledger.Copy(Rec);
                    Report.Run(Report::"BSEX Expense Summary", true, false, Ledger);
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';
                actionref(RunSummary_Promoted; RunSummary) { }
            }
        }
    }
}
