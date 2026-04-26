namespace BinaryStream.ExpenseReportManager;

codeunit 77501 "BSEX Expense Post"
{
    TableNo = "BSEX Expense Report Header";

    var
        WrongStatusErr: Label 'Only approved expense reports can be posted. Current status is %1.', Comment = '%1 = status';
        PostConfirmQst: Label 'Post expense report %1?', Comment = '%1 = No.';
        PostedMsg: Label 'Expense report %1 was posted. %2 ledger entries were created.', Comment = '%1 = No., %2 = count';

    trigger OnRun()
    begin
        PostReport(Rec);
    end;

    procedure PostReport(var Header: Record "BSEX Expense Report Header")
    var
        Line: Record "BSEX Expense Report Line";
        Ledger: Record "BSEX Expense Ledger Entry";
        EntryCount: Integer;
    begin
        if Header.Status <> Header.Status::Approved then
            Error(WrongStatusErr, Format(Header.Status));

        if not Confirm(StrSubstNo(PostConfirmQst, Header."No."), true) then
            exit;

        ThrowExceptionIfDebugBugEnabled();

        Line.SetRange("Document No.", Header."No.");
        Line.LockTable();
        if Line.FindSet() then
            repeat
                Ledger.Init();
                Ledger."Entry No." := 0;
                Ledger."Document No." := Header."No.";
                Ledger."Posting Date" := Header."Posting Date";
                Ledger."Document Date" := Header."Document Date";
                Ledger."Employee No." := Header."Employee No.";
                Ledger."Employee Name" := Header."Employee Name";
                Ledger.Category := Line.Category;
                Ledger.Description := Line.Description;
                Ledger.Merchant := Line.Merchant;
                Ledger.Amount := Line.Amount;
                Ledger.Reimbursable := Line.Reimbursable;
                Ledger."Source Report No." := Header."No.";
                Ledger."Source Line No." := Line."Line No.";
                Ledger."User ID" := CopyStr(UserId(), 1, MaxStrLen(Ledger."User ID"));
                Ledger.Insert();
                EntryCount += 1;
            until Line.Next() = 0;

        Header.Status := Header.Status::Posted;
        Header."Posted By" := CopyStr(UserId(), 1, MaxStrLen(Header."Posted By"));
        Header."Posted On" := CurrentDateTime();
        Header.Modify(true);

        Message(PostedMsg, Header."No.", EntryCount);
    end;

    local procedure ThrowExceptionIfDebugBugEnabled()
    var
        Setup: Record "BSEX Expense Report Setup";
        Zero: Integer;
        Dummy: Integer;
    begin
        if not (Setup.Get() and Setup."Debug Bug Post Exception") then
            exit;
        Zero := 0;
        Dummy := 1 div Zero;
    end;
}
