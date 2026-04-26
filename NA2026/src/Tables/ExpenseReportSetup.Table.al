namespace BinaryStream.ExpenseReportManager;

using Microsoft.Foundation.NoSeries;

table 77503 "BSEX Expense Report Setup"
{
    Caption = 'Expense Report Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Expense Report Nos."; Code[20])
        {
            Caption = 'Expense Report Nos.';
            TableRelation = "No. Series";
        }
        field(3; "Posted Entry Auto-Increment"; Boolean)
        {
            Caption = 'Posted Entry Auto-Increment';
            InitValue = true;
        }
        field(100; "Debug Bug Post Exception"; Boolean)
        {
            Caption = 'Debug: Throw Exception On Post';
        }
        field(101; "Debug Bug Post Btn Disabled"; Boolean)
        {
            Caption = 'Debug: Post Button Stays Disabled';
        }
    }

    keys
    {
        key(PK; "Primary Key") { Clustered = true; }
    }

    procedure GetRecordOnce()
    begin
        if Rec.Get() then
            exit;
        Rec.Init();
        Rec.Insert();
    end;
}
