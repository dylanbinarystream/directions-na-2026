namespace BinaryStream.ExpenseReportManager;

page 77501 "BSEX Posted Expense Reports"
{
    Caption = 'Posted Expense Reports';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = History;
    SourceTable = "BSEX Expense Report Header";
    SourceTableView = where(Status = const(Posted));
    CardPageId = "BSEX Expense Report";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.") { ApplicationArea = All; }
                field(Description; Rec.Description) { ApplicationArea = All; }
                field("Employee No."; Rec."Employee No.") { ApplicationArea = All; }
                field("Employee Name"; Rec."Employee Name") { ApplicationArea = All; }
                field("Posting Date"; Rec."Posting Date") { ApplicationArea = All; }
                field("Total Amount"; Rec."Total Amount") { ApplicationArea = All; }
                field("Posted By"; Rec."Posted By") { ApplicationArea = All; }
                field("Posted On"; Rec."Posted On") { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(LedgerEntries)
            {
                ApplicationArea = All;
                Caption = 'Ledger Entries';
                Image = Ledger;
                RunObject = page "BSEX Expense Ledger Entries";
                RunPageLink = "Source Report No." = field("No.");
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';
                actionref(LedgerEntries_Promoted; LedgerEntries) { }
            }
        }
    }
}
