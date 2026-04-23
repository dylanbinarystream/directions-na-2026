namespace BinaryStream.ExpenseReportManager;

using Microsoft.Foundation.NoSeries;
using Microsoft.HumanResources.Employee;
using System.Security.AccessControl;

table 77500 "BSEX Expense Report Header"
{
    Caption = 'Expense Report Header';
    DataClassification = CustomerContent;
    LookupPageId = "BSEX Expense Reports";
    DrillDownPageId = "BSEX Expense Reports";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            trigger OnValidate()
            var
                NoSeries: Codeunit "No. Series";
            begin
                if "No." <> xRec."No." then begin
                    Setup.GetRecordOnce();
                    NoSeries.TestManual(Setup."Expense Report Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            TableRelation = Employee."No.";
            trigger OnValidate()
            var
                Employee: Record Employee;
            begin
                TestStatusDraft();
                if "Employee No." = '' then begin
                    "Employee Name" := '';
                    exit;
                end;
                Employee.Get("Employee No.");
                "Employee Name" := CopyStr(Employee.FullName(), 1, MaxStrLen("Employee Name"));
            end;
        }
        field(3; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
            Editable = false;
        }
        field(4; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            trigger OnValidate()
            begin
                TestStatusDraft();
            end;
        }
        field(5; "Document Date"; Date)
        {
            Caption = 'Document Date';
            trigger OnValidate()
            begin
                TestStatusDraft();
            end;
        }
        field(6; Description; Text[100])
        {
            Caption = 'Description';
            trigger OnValidate()
            begin
                TestStatusDraft();
            end;
        }
        field(7; Purpose; Text[250])
        {
            Caption = 'Business Purpose';
        }
        field(10; Status; Enum "BSEX Expense Status")
        {
            Caption = 'Status';
            Editable = false;
        }
        field(11; "Submitted By"; Code[50])
        {
            Caption = 'Submitted By';
            Editable = false;
            TableRelation = User."User Name";
        }
        field(12; "Submitted On"; DateTime)
        {
            Caption = 'Submitted On';
            Editable = false;
        }
        field(13; "Approved By"; Code[50])
        {
            Caption = 'Approved By';
            Editable = false;
            TableRelation = User."User Name";
        }
        field(14; "Approved On"; DateTime)
        {
            Caption = 'Approved On';
            Editable = false;
        }
        field(15; "Posted By"; Code[50])
        {
            Caption = 'Posted By';
            Editable = false;
        }
        field(16; "Posted On"; DateTime)
        {
            Caption = 'Posted On';
            Editable = false;
        }
        field(20; "Total Amount"; Decimal)
        {
            Caption = 'Total Amount';
            FieldClass = FlowField;
            CalcFormula = sum("BSEX Expense Report Line".Amount where("Document No." = field("No.")));
            Editable = false;
            AutoFormatType = 1;
        }
        field(21; "Line Count"; Integer)
        {
            Caption = 'Line Count';
            FieldClass = FlowField;
            CalcFormula = count("BSEX Expense Report Line" where("Document No." = field("No.")));
            Editable = false;
        }
        field(30; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(PK; "No.") { Clustered = true; }
        key(Status; Status, "Posting Date") { }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", Description, "Employee Name", Status) { }
        fieldgroup(Brick; "No.", Description, "Employee Name", Status, "Total Amount") { }
    }

    var
        Setup: Record "BSEX Expense Report Setup";
        StatusErr: Label 'Status must be %1.', Comment = '%1 = status value';
        DeletePostedErr: Label 'You cannot delete a posted expense report.';

    trigger OnInsert()
    var
        NoSeries: Codeunit "No. Series";
    begin
        if "No." = '' then begin
            Setup.GetRecordOnce();
            Setup.TestField("Expense Report Nos.");
            "No. Series" := Setup."Expense Report Nos.";
            "No." := NoSeries.GetNextNo("No. Series", WorkDate());
        end;
        if "Posting Date" = 0D then
            "Posting Date" := WorkDate();
        if "Document Date" = 0D then
            "Document Date" := WorkDate();
    end;

    trigger OnDelete()
    var
        Line: Record "BSEX Expense Report Line";
    begin
        if Status = Status::Posted then
            Error(DeletePostedErr);
        Line.SetRange("Document No.", "No.");
        Line.DeleteAll(true);
    end;

    procedure AssistEdit(): Boolean
    var
        NoSeries: Codeunit "No. Series";
    begin
        Setup.GetRecordOnce();
        Setup.TestField("Expense Report Nos.");
        if NoSeries.LookupRelatedNoSeries(Setup."Expense Report Nos.", xRec."No. Series", "No. Series") then begin
            "No." := NoSeries.GetNextNo("No. Series", WorkDate());
            exit(true);
        end;
    end;

    procedure TestStatusDraft()
    begin
        if Status <> Status::Draft then
            Error(StatusErr, Format(Status::Draft));
    end;
}
