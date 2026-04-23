namespace BinaryStream.ExpenseReportManager.Test;

using BinaryStream.ExpenseReportManager;

permissionset 77640 "BSEX-EXP-TEST"
{
    Assignable = true;
    Caption = 'Expense Reports - Test';

    IncludedPermissionSets = "BSEX-EXP-EDIT";

    Permissions =
        codeunit "BSEX Expense Report Tests" = X;
}
