namespace BinaryStream.ExpenseReportManager;

page 77507 "BSEX Posted Expense Report"
{
    Caption = 'Posted Expense Report';
    PageType = Document;
    ApplicationArea = All;
    SourceTable = "BSEX Expense Report Header";
    SourceTableView = where(Status = const(Posted));
    Editable = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.") { ApplicationArea = All; Importance = Promoted; }
                field(Description; Rec.Description) { ApplicationArea = All; Importance = Promoted; }
                field("Employee No."; Rec."Employee No.") { ApplicationArea = All; Importance = Promoted; }
                field("Employee Name"; Rec."Employee Name") { ApplicationArea = All; }
                field("Posting Date"; Rec."Posting Date") { ApplicationArea = All; }
                field("Document Date"; Rec."Document Date") { ApplicationArea = All; }
                field(Purpose; Rec.Purpose) { ApplicationArea = All; MultiLine = true; }
                field(Status; Rec.Status) { ApplicationArea = All; Importance = Promoted; }
            }
            part(Lines; "BSEX Expense Report Subform")
            {
                ApplicationArea = All;
                Caption = 'Lines';
                SubPageLink = "Document No." = field("No.");
            }
            group(Totals)
            {
                Caption = 'Totals';
                field("Total Amount"; Rec."Total Amount") { ApplicationArea = All; Importance = Promoted; Style = Strong; }
                field("Line Count"; Rec."Line Count") { ApplicationArea = All; }
            }
            group(Workflow)
            {
                Caption = 'Workflow';
                field("Submitted By"; Rec."Submitted By") { ApplicationArea = All; }
                field("Submitted On"; Rec."Submitted On") { ApplicationArea = All; }
                field("Approved By"; Rec."Approved By") { ApplicationArea = All; }
                field("Approved On"; Rec."Approved On") { ApplicationArea = All; }
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
            group(Category_Navigate)
            {
                Caption = 'Navigate';
                actionref(LedgerEntries_Promoted; LedgerEntries) { }
            }
        }
    }
}
