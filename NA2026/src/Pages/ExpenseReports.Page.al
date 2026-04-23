namespace BinaryStream.ExpenseReportManager;

page 77500 "BSEX Expense Reports"
{
    Caption = 'Expense Reports';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "BSEX Expense Report Header";
    SourceTableView = where(Status = filter(Draft | Submitted | Approved));
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
                field("Line Count"; Rec."Line Count") { ApplicationArea = All; }
                field(Status; Rec.Status) { ApplicationArea = All; StyleExpr = StatusStyle; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Submit)
            {
                ApplicationArea = All;
                Caption = 'Submit';
                Image = SendApprovalRequest;
                Enabled = Rec.Status = Rec.Status::Draft;
                trigger OnAction()
                var
                    Mgt: Codeunit "BSEX Expense Report Mgt";
                begin
                    Mgt.Submit(Rec);
                end;
            }
            action(Approve)
            {
                ApplicationArea = All;
                Caption = 'Approve';
                Image = Approve;
                Enabled = Rec.Status = Rec.Status::Submitted;
                trigger OnAction()
                var
                    Mgt: Codeunit "BSEX Expense Report Mgt";
                begin
                    Mgt.Approve(Rec);
                end;
            }
            action(Reopen)
            {
                ApplicationArea = All;
                Caption = 'Reopen';
                Image = ReOpen;
                Enabled = ReopenEnabled;
                trigger OnAction()
                var
                    Mgt: Codeunit "BSEX Expense Report Mgt";
                begin
                    Mgt.Reopen(Rec);
                end;
            }
            action(Post)
            {
                ApplicationArea = All;
                Caption = 'Post';
                Image = PostDocument;
                Enabled = Rec.Status = Rec.Status::Approved;
                trigger OnAction()
                var
                    Post: Codeunit "BSEX Expense Post";
                begin
                    Post.PostReport(Rec);
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';
                actionref(Submit_Promoted; Submit) { }
                actionref(Approve_Promoted; Approve) { }
                actionref(Reopen_Promoted; Reopen) { }
                actionref(Post_Promoted; Post) { }
            }
        }
    }

    var
        StatusStyle: Text;
        ReopenEnabled: Boolean;

    trigger OnAfterGetRecord()
    begin
        ReopenEnabled := Rec.Status in [Rec.Status::Submitted, Rec.Status::Approved];
        case Rec.Status of
            Rec.Status::Draft:
                StatusStyle := 'Subordinate';
            Rec.Status::Submitted:
                StatusStyle := 'Ambiguous';
            Rec.Status::Approved:
                StatusStyle := 'Favorable';
            else
                StatusStyle := 'Standard';
        end;
    end;
}
