// using System.Runtime.InteropServices;

// namespace MiniIngenium.Services;

// // Bridge gọi COBOL .so compiled bởi GnuCOBOL
// // Otterkit transpile sang C# nên COBOL logic nằm
// // trực tiếp trong CobolLogic.cs thay vì .so
// public class CobolBridge
// {
//     private readonly CobolLogic _logic = new();

//     public (decimal finalPremium, string message) Rating(
//         int policyId, decimal basePremium, string product)
//     {
//         return _logic.CalculateRating(policyId, basePremium, product);
//     }

//     public string Validate(int policyId, decimal premium, string product)
//     {
//         return _logic.ValidatePolicy(policyId, premium, product);
//     }

//     public string ClaimCheck(decimal amount)
//     {
//         return _logic.CheckClaim(amount);
//     }

//     public (decimal total, string message) Billing(
//         decimal premium, int months)
//     {
//         return _logic.CalculateBilling(premium, months);
//     }
// }


using System;

namespace MiniIngenium.Services;

public class CobolBridge
{
    // Giữ nguyên các logic cũ của bạn
    private readonly CobolLogic _logic = new();

    public (decimal finalPremium, string message) Rating(int policyId, decimal basePremium, string product)
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

    public (decimal total, string message) Billing(decimal premium, int months)
    {
        return _logic.CalculateBilling(premium, months);
    }

    // ==========================================
    // BỔ SUNG LOGIC CHO EMPLOYEE REPO (COBOL)
    // ==========================================

    public void AddEmployee(string name, int age)
    {
        // Gọi trực tiếp phương thức static trong EmployeeRepo.cbl
        // Otterkit biên dịch class COBOL vào Global Namespace
        global::EmployeeRepo.InsertEmployee(name, age);
    }

    public void FetchEmployees()
    {
        // Gọi phương thức hiển thị danh sách của COBOL
        global::EmployeeRepo.FetchEmployees();
    }
}