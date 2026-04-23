namespace BinaryStream.ExpenseReportManager;

page 77502 "BSEX Expense Report"
{
    Caption = 'Expense Report';
    PageType = Document;
    ApplicationArea = All;
    SourceTable = "BSEX Expense Report Header";
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit() then
                            CurrPage.Update();
                    end;
                }
                field(Description; Rec.Description) { ApplicationArea = All; Importance = Promoted; }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
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
                UpdatePropagation = Both;
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
                    CurrPage.SaveRecord();
                    Mgt.Submit(Rec);
                    CurrPage.Update(false);
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
                    CurrPage.Update(false);
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
                    CurrPage.Update(false);
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
                    CurrPage.Update(false);
                end;
            }
        }
        area(Navigation)
        {
            action(LedgerEntries)
            {
                ApplicationArea = All;
                Caption = 'Ledger Entries';
                Image = Ledger;
                Enabled = Rec.Status = Rec.Status::Posted;
                RunObject = page "BSEX Expense Ledger Entries";
                RunPageLink = "Source Report No." = field("No.");
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
            group(Category_Navigate)
            {
                Caption = 'Navigate';
                actionref(LedgerEntries_Promoted; LedgerEntries) { }
            }
        }
    }

    var
        ReopenEnabled: Boolean;

    trigger OnAfterGetCurrRecord()
    begin
        ReopenEnabled := Rec.Status in [Rec.Status::Submitted, Rec.Status::Approved];
    end;
}
