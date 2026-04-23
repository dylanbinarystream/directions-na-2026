namespace BinaryStream.ExpenseReportManager;

codeunit 77500 "BSEX Expense Report Mgt"
{
    var
        NoLinesErr: Label 'You cannot submit %1 %2 because it has no lines.', Comment = '%1 = table caption, %2 = No.';
        ZeroAmountErr: Label 'You cannot submit %1 %2 because the total amount is zero.', Comment = '%1 = table caption, %2 = No.';
        WrongStatusErr: Label 'Status must be %1 to perform this action. Current status is %2.', Comment = '%1 = required, %2 = current';
        SubmitConfirmQst: Label 'Submit expense report %1 for approval?', Comment = '%1 = No.';
        ApproveConfirmQst: Label 'Approve expense report %1?', Comment = '%1 = No.';
        ReopenConfirmQst: Label 'Reopen expense report %1?', Comment = '%1 = No.';

    procedure Submit(var Header: Record "BSEX Expense Report Header")
    var
        Line: Record "BSEX Expense Report Line";
    begin
        if Header.Status <> Header.Status::Draft then
            Error(WrongStatusErr, Format(Header.Status::Draft), Format(Header.Status));

        Header.TestField("Employee No.");
        Header.TestField("Posting Date");
        Header.TestField(Description);

        Line.SetRange("Document No.", Header."No.");
        if Line.IsEmpty() then
            Error(NoLinesErr, Header.TableCaption(), Header."No.");

        Header.CalcFields("Total Amount");
        if Header."Total Amount" <= 0 then
            Error(ZeroAmountErr, Header.TableCaption(), Header."No.");

        if not Confirm(StrSubstNo(SubmitConfirmQst, Header."No."), true) then
            exit;

        Header.Status := Header.Status::Submitted;
        Header."Submitted By" := CopyStr(UserId(), 1, MaxStrLen(Header."Submitted By"));
        Header."Submitted On" := CurrentDateTime();
        Header.Modify(true);
    end;

    procedure Approve(var Header: Record "BSEX Expense Report Header")
    begin
        if Header.Status <> Header.Status::Submitted then
            Error(WrongStatusErr, Format(Header.Status::Submitted), Format(Header.Status));

        if not Confirm(StrSubstNo(ApproveConfirmQst, Header."No."), true) then
            exit;

        Header.Status := Header.Status::Approved;
        Header."Approved By" := CopyStr(UserId(), 1, MaxStrLen(Header."Approved By"));
        Header."Approved On" := CurrentDateTime();
        Header.Modify(true);
    end;

    procedure Reopen(var Header: Record "BSEX Expense Report Header")
    begin
        if Header.Status = Header.Status::Draft then
            exit;
        if Header.Status = Header.Status::Posted then
            Error(WrongStatusErr, 'Submitted or Approved', Format(Header.Status));

        if not Confirm(StrSubstNo(ReopenConfirmQst, Header."No."), true) then
            exit;

        Header.Status := Header.Status::Draft;
        Header."Submitted By" := '';
        Header."Submitted On" := 0DT;
        Header."Approved By" := '';
        Header."Approved On" := 0DT;
        Header.Modify(true);
    end;
}
