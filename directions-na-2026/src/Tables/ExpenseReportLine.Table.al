namespace BinaryStream.ExpenseReportManager;

table 77501 "BSEX Expense Report Line"
{
    Caption = 'Expense Report Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "BSEX Expense Report Header"."No.";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Expense Date"; Date)
        {
            Caption = 'Expense Date';
            trigger OnValidate()
            begin
                TestStatusDraft();
            end;
        }
        field(4; Category; Enum "BSEX Expense Category")
        {
            Caption = 'Category';
            trigger OnValidate()
            begin
                TestStatusDraft();
            end;
        }
        field(5; Description; Text[100])
        {
            Caption = 'Description';
            trigger OnValidate()
            begin
                TestStatusDraft();
            end;
        }
        field(6; Merchant; Text[100])
        {
            Caption = 'Merchant';
            trigger OnValidate()
            begin
                TestStatusDraft();
            end;
        }
        field(7; Amount; Decimal)
        {
            Caption = 'Amount';
            AutoFormatType = 1;
            MinValue = 0;
            trigger OnValidate()
            begin
                TestStatusDraft();
            end;
        }
        field(8; Reimbursable; Boolean)
        {
            Caption = 'Reimbursable';
            InitValue = true;
            trigger OnValidate()
            begin
                TestStatusDraft();
            end;
        }
    }

    keys
    {
        key(PK; "Document No.", "Line No.") { Clustered = true; }
    }

    var
        StatusErr: Label 'You cannot modify lines unless the report is in status %1.', Comment = '%1 = Draft';

    trigger OnInsert()
    begin
        TestStatusDraft();
        if "Expense Date" = 0D then
            "Expense Date" := WorkDate();
    end;

    trigger OnModify()
    begin
        TestStatusDraft();
    end;

    trigger OnDelete()
    begin
        TestStatusDraft();
    end;

    local procedure TestStatusDraft()
    var
        Header: Record "BSEX Expense Report Header";
    begin
        if not Header.Get("Document No.") then
            exit;
        if Header.Status <> Header.Status::Draft then
            Error(StatusErr, Format(Header.Status::Draft));
    end;
}
