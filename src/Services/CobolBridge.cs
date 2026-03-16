using System.Runtime.InteropServices;

namespace MiniIngenium.Services;

// Bridge gọi COBOL .so compiled bởi GnuCOBOL
// Otterkit transpile sang C# nên COBOL logic nằm
// trực tiếp trong CobolLogic.cs thay vì .so
public class CobolBridge
{
    private readonly CobolLogic _logic = new();

    public (decimal finalPremium, string message) Rating(
        int policyId, decimal basePremium, string product)
    {
        return _logic.CalculateRating(policyId, basePremium, product);
    }

    public string Validate(int policyId, decimal premium, string product)
    {
        return _logic.ValidatePolicy(policyId, premium, product);
    }

    public string ClaimCheck(decimal amount)
    {
        return _logic.CheckClaim(amount);
    }

    public (decimal total, string message) Billing(
        decimal premium, int months)
    {
        return _logic.CalculateBilling(premium, months);
    }
// ============================================================
    // PHẦN MỚI: KẾT NỐI VỚI EMPLOYEE REPO (COBOL OOP)
    // ============================================================

    /// <summary>
    /// Gọi sang COBOL để thực hiện INSERT nhân viên vào database
    /// </summary>
    public void AddEmployee(string name, int age)
    {
        // Sử dụng global:: để gọi đúng class EmployeeRepo từ COBOL
        // Otterkit biên dịch METHOD-ID thành các phương thức C# tương ứng
        global::EmployeeRepo.InsertEmployee(name, age);
    }

    /// <summary>
    /// Gọi sang COBOL để thực hiện SELECT và DISPLAY danh sách nhân viên
    /// </summary>
    public void FetchEmployees()
    {
        global::EmployeeRepo.FetchEmployees();
    }
}