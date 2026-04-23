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
