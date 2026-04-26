namespace BinaryStream.ExpenseReportManager;

page 77506 "BSEX Expense Report Debug"
{
    Caption = 'Expense Report Debug';
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
            group(DemoBugs)
            {
                Caption = 'Demo Bugs';
                InstructionalText = 'Toggles to enable demo bugs. Both default to off.';

                field(BugPostException; Rec."Debug Bug Post Exception")
                {
                    ApplicationArea = All;
                    Caption = 'Bug 1: Throw exception when posting';
                    ToolTip = 'When enabled, clicking Post raises a runtime exception in the posting codeunit.';
                }
                field(BugPostBtnDisabled; Rec."Debug Bug Post Btn Disabled")
                {
                    ApplicationArea = All;
                    Caption = 'Bug 2: Post button never enables';
                    ToolTip = 'When enabled, the Post action on the Expense Report page stays disabled even after the document is approved.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.GetRecordOnce();
    end;
}
