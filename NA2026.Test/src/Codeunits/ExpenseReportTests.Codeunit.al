namespace BinaryStream.ExpenseReportManager.Test;

using BinaryStream.ExpenseReportManager;
using Microsoft.Foundation.NoSeries;
using Microsoft.HumanResources.Employee;

codeunit 77600 "BSEX Expense Report Tests"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        IsInitialized: Boolean;
        NoSeriesCodeTok: Label 'EXP-TEST', Locked = true;

    // ---------------------------------------------------------------
    // State transition rules
    // ---------------------------------------------------------------

    [Test]
    procedure SubmitWithNoLines_Errors()
    var
        Header: Record "BSEX Expense Report Header";
        Mgt: Codeunit "BSEX Expense Report Mgt";
    begin
        // [SCENARIO] Submitting an expense report that has no lines must error.
        Initialize();

        // [GIVEN] A draft expense report with no lines
        CreateDraftHeader(Header);

        // [WHEN] The user submits it
        asserterror Mgt.Submit(Header);

        // [THEN] An error mentioning "no lines" is raised
        AssertExpectedError('no lines');
    end;

    [Test]
    procedure SubmitWithZeroAmount_Errors()
    var
        Header: Record "BSEX Expense Report Header";
        Mgt: Codeunit "BSEX Expense Report Mgt";
    begin
        // [SCENARIO] A report whose lines total to zero cannot be submitted.
        Initialize();

        // [GIVEN] A draft report with one line, amount = 0
        CreateDraftHeader(Header);
        AddLine(Header, "BSEX Expense Category"::Meals, 'Coffee meeting', 0);

        // [WHEN] The user submits it
        asserterror Mgt.Submit(Header);

        // [THEN] An error mentioning "amount" is raised
        AssertExpectedError('amount');
    end;

    [Test]
    procedure Submit_StampsSubmittedByAndOn()
    var
        Header: Record "BSEX Expense Report Header";
        Mgt: Codeunit "BSEX Expense Report Mgt";
        BeforeSubmit: DateTime;
    begin
        // [SCENARIO] Submitting a valid report stamps Submitted By/On and moves to Submitted.
        Initialize();

        // [GIVEN] A draft report with one valid line
        CreateDraftHeader(Header);
        AddLine(Header, "BSEX Expense Category"::Travel, 'Taxi to airport', 42.50);
        BeforeSubmit := CurrentDateTime();

        // [WHEN] Submit is called
        Mgt.Submit(Header);

        // [THEN] Status is Submitted and audit fields are populated
        Header.Get(Header."No.");
        if Header.Status <> Header.Status::Submitted then
            Error('Expected status Submitted, got %1.', Format(Header.Status));
        if Header."Submitted By" <> CopyStr(UserId(), 1, MaxStrLen(Header."Submitted By")) then
            Error('Expected Submitted By to equal UserId().');
        if Header."Submitted On" < BeforeSubmit then
            Error('Submitted On (%1) should be >= time before submit (%2).', Header."Submitted On", BeforeSubmit);
    end;

    [Test]
    procedure ApproveWhileDraft_Errors()
    var
        Header: Record "BSEX Expense Report Header";
        Mgt: Codeunit "BSEX Expense Report Mgt";
    begin
        // [SCENARIO] Approve cannot skip the Submitted state.
        Initialize();

        // [GIVEN] A report still in Draft (with a valid line)
        CreateDraftHeader(Header);
        AddLine(Header, "BSEX Expense Category"::Lodging, 'Hotel night 1', 199.00);

        // [WHEN] The user attempts to approve directly
        asserterror Mgt.Approve(Header);

        // [THEN] An error referring to the required status is raised
        AssertExpectedError('Submitted');
    end;

    // ---------------------------------------------------------------
    // Calculation correctness
    // ---------------------------------------------------------------

    [Test]
    procedure Posting_CreatesOneLedgerEntryPerLine_AmountsMatch()
    var
        Header: Record "BSEX Expense Report Header";
        Ledger: Record "BSEX Expense Ledger Entry";
        Mgt: Codeunit "BSEX Expense Report Mgt";
        Post: Codeunit "BSEX Expense Post";
        ExpectedTotal: Decimal;
    begin
        // [SCENARIO] Posting projects each line to a ledger entry; totals match.
        Initialize();

        // [GIVEN] An approved report with three lines across two categories
        CreateDraftHeader(Header);
        AddLine(Header, "BSEX Expense Category"::Travel, 'Flight', 450.00);
        AddLine(Header, "BSEX Expense Category"::Meals, 'Dinner', 65.25);
        AddLine(Header, "BSEX Expense Category"::Meals, 'Lunch', 18.75);
        ExpectedTotal := 450.00 + 65.25 + 18.75;

        Mgt.Submit(Header);
        Header.Get(Header."No.");
        Mgt.Approve(Header);
        Header.Get(Header."No.");

        // [WHEN] The report is posted
        Post.PostReport(Header);

        // [THEN] Three ledger entries exist for the document
        Ledger.SetRange("Source Report No.", Header."No.");
        if Ledger.Count() <> 3 then
            Error('Expected 3 ledger entries, found %1.', Ledger.Count());

        // [THEN] Sum of ledger amounts equals the posted total
        Ledger.CalcSums(Amount);
        if Ledger.Amount <> ExpectedTotal then
            Error('Expected ledger total %1, got %2.', ExpectedTotal, Ledger.Amount);

        // [THEN] Header is now Posted and Total Amount FlowField equals the same total
        Header.Get(Header."No.");
        Header.CalcFields("Total Amount");
        if Header.Status <> Header.Status::Posted then
            Error('Expected Posted, got %1.', Format(Header.Status));
        if Header."Total Amount" <> ExpectedTotal then
            Error('Header Total Amount %1 <> %2.', Header."Total Amount", ExpectedTotal);
    end;

    // ---------------------------------------------------------------
    // Edge case: line lock after status change
    // ---------------------------------------------------------------

    [Test]
    procedure LinesAreLockedAfterSubmit()
    var
        Header: Record "BSEX Expense Report Header";
        Line: Record "BSEX Expense Report Line";
        Mgt: Codeunit "BSEX Expense Report Mgt";
    begin
        // [SCENARIO] After a report is submitted, its lines cannot be modified.
        Initialize();

        // [GIVEN] A submitted report with one line
        CreateDraftHeader(Header);
        AddLine(Header, "BSEX Expense Category"::Supplies, 'Notebooks', 25.00);
        Mgt.Submit(Header);

        // [WHEN] An attempt is made to change the line amount
        Line.SetRange("Document No.", Header."No.");
        Line.FindFirst();
        Line.Amount := 99.00;
        asserterror Line.Modify(true);

        // [THEN] The line modification is rejected
        AssertExpectedError('Draft');
    end;

    // ---------------------------------------------------------------
    // Setup helpers
    // ---------------------------------------------------------------

    local procedure Initialize()
    begin
        if IsInitialized then
            exit;
        EnsureNoSeries();
        EnsureSetup();
        Commit();
        IsInitialized := true;
    end;

    local procedure EnsureNoSeries()
    var
        NoSeries: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
    begin
        if NoSeries.Get(NoSeriesCodeTok) then
            exit;
        NoSeries.Init();
        NoSeries.Code := NoSeriesCodeTok;
        NoSeries.Description := 'Expense Test Series';
        NoSeries."Default Nos." := true;
        NoSeries."Manual Nos." := false;
        NoSeries.Insert();

        NoSeriesLine.Init();
        NoSeriesLine."Series Code" := NoSeriesCodeTok;
        NoSeriesLine."Line No." := 10000;
        NoSeriesLine."Starting No." := 'EXPT00001';
        NoSeriesLine."Increment-by No." := 1;
        NoSeriesLine.Insert();
    end;

    local procedure EnsureSetup()
    var
        Setup: Record "BSEX Expense Report Setup";
    begin
        Setup.GetRecordOnce();
        Setup."Expense Report Nos." := NoSeriesCodeTok;
        Setup.Modify();
    end;

    local procedure CreateEmployee(): Code[20]
    var
        Employee: Record Employee;
    begin
        Employee.Init();
        Employee."No." := '';
        Employee.Insert(true);
        Employee."First Name" := 'Test';
        Employee."Last Name" := 'Employee';
        Employee.Modify(true);
        exit(Employee."No.");
    end;

    local procedure CreateDraftHeader(var Header: Record "BSEX Expense Report Header")
    begin
        Header.Init();
        Header."No." := '';
        Header.Insert(true);
        Header.Validate("Employee No.", CreateEmployee());
        Header.Validate(Description, 'Test Expense Report');
        Header.Modify(true);
    end;

    local procedure AddLine(Header: Record "BSEX Expense Report Header"; Category: Enum "BSEX Expense Category"; Description: Text[100]; Amount: Decimal)
    var
        Line: Record "BSEX Expense Report Line";
        NextLineNo: Integer;
    begin
        Line.SetRange("Document No.", Header."No.");
        if Line.FindLast() then
            NextLineNo := Line."Line No." + 10000
        else
            NextLineNo := 10000;

        Line.Init();
        Line."Document No." := Header."No.";
        Line."Line No." := NextLineNo;
        Line.Insert(true);
        Line.Validate(Category, Category);
        Line.Validate(Description, Description);
        Line.Validate(Amount, Amount);
        Line.Modify(true);
    end;

    local procedure AssertExpectedError(Expected: Text)
    begin
        if StrPos(LowerCase(GetLastErrorText()), LowerCase(Expected)) = 0 then
            Error('Expected error containing "%1", got: %2', Expected, GetLastErrorText());
    end;

    // ---------------------------------------------------------------
    // Handlers
    // ---------------------------------------------------------------

    [ConfirmHandler]
    procedure ConfirmYesHandler(Question: Text[1024]; var Reply: Boolean)
    begin
        Reply := true;
    end;

    [MessageHandler]
    procedure PostMessageHandler(Message: Text[1024])
    begin
        // Swallow the "Posted" confirmation message.
    end;
}
