namespace BinaryStream.ExpenseReportManager;

using Microsoft.HumanResources.Employee;
using System.Security.AccessControl;

table 77502 "BSEX Expense Ledger Entry"
{
    Caption = 'Expense Ledger Entry';
    DataClassification = CustomerContent;
    DrillDownPageId = "BSEX Expense Ledger Entries";
    LookupPageId = "BSEX Expense Ledger Entries";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(3; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(4; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(5; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            TableRelation = Employee."No.";
        }
        field(6; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
        }
        field(7; Category; Enum "BSEX Expense Category")
        {
            Caption = 'Category';
        }
        field(8; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(9; Merchant; Text[100])
        {
            Caption = 'Merchant';
        }
        field(10; Amount; Decimal)
        {
            Caption = 'Amount';
            AutoFormatType = 1;
        }
        field(11; Reimbursable; Boolean)
        {
            Caption = 'Reimbursable';
        }
        field(12; "Source Report No."; Code[20])
        {
            Caption = 'Source Report No.';
            TableRelation = "BSEX Expense Report Header"."No.";
        }
        field(13; "Source Line No."; Integer)
        {
            Caption = 'Source Line No.';
        }
        field(14; "User ID"; Code[50])
        {
            Caption = 'User ID';
            TableRelation = User."User Name";
        }
    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
        key(Document; "Source Report No.", "Source Line No.") { }
        key(Employee; "Employee No.", "Posting Date") { }
        key(Category; Category, "Posting Date") { SumIndexFields = Amount; }
    }

    fieldgroups
    {
        fieldgroup(Brick; "Entry No.", "Employee Name", Category, Amount, "Posting Date") { }
    }
}
