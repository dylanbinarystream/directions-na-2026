namespace BinaryStream.ExpenseReportManager;

page 77503 "BSEX Expense Report Subform"
{
    Caption = 'Lines';
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "BSEX Expense Report Line";
    AutoSplitKey = true;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Expense Date"; Rec."Expense Date") { ApplicationArea = All; }
                field(Category; Rec.Category) { ApplicationArea = All; }
                field(Description; Rec.Description) { ApplicationArea = All; }
                field(Merchant; Rec.Merchant) { ApplicationArea = All; }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field(Reimbursable; Rec.Reimbursable) { ApplicationArea = All; }
            }
        }
    }

    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.Update(true);
        exit(true);
    end;
}
