namespace MiniIngenium.Services;

// Đây là COBOL business logic từ PolicyEngine.cbl và BillingEngine.cbl
// được transpile sang C# theo cách Otterkit sẽ làm
// Khi Otterkit stable, file này sẽ được auto-generate từ .cbl

public class CobolLogic
{
    // PolicyEngine.cbl — RATING logic
    public (decimal finalPremium, string message) CalculateRating(
        int policyId, decimal basePremium, string product)
    {
        // EVALUATE TRUE — COBOL pattern
        decimal factor = product.Trim() switch
        {
            var p when p.StartsWith("LIFE-BASIC")   => 1.10m,
            var p when p.StartsWith("LIFE-PLUS")    => 1.25m,
            var p when p.StartsWith("HEALTH-BASIC") => 1.15m,
            _                                        => 1.20m
        };

        // COMPUTE WS-FINAL = LK-PREMIUM * WS-FACTOR
        decimal final = basePremium * factor;

        return (final,
            $"RATING OK FACTOR={factor:F2} FINAL={final:F2}");
    }

    // PolicyEngine.cbl — VALIDATE logic
    public string ValidatePolicy(int policyId, decimal premium, string product)
    {
        // IF LK-PREMIUM > 0 AND LK-PRODUCT NOT = SPACES
        if (premium > 0 && !string.IsNullOrWhiteSpace(product))
            return "POLICY VALID";
        return "ERROR: INVALID POLICY DATA";
    }

    // PolicyEngine.cbl — CLAIMCHK logic
    public string CheckClaim(decimal amount)
    {
        // IF LK-PREMIUM > 1000000
        if (amount > 1_000_000)
            return "WARNING: HIGH VALUE CLAIM - REVIEW REQUIRED";
        return "CLAIM AMOUNT OK";
    }

    // BillingEngine.cbl — billing calculation
    public (decimal total, string message) CalculateBilling(
        decimal premium, int months)
    {
        if (months == 0) months = 12;

        // COMPUTE WS-MONTHLY = WS-PREMIUM / 12
        decimal monthly = premium / 12;
        decimal annual  = monthly * months;
        decimal tax     = annual * 0.10m;  // WS-TAX-RATE VALUE 0.10
        decimal total   = annual + tax;

        return (total,
            $"MONTHLY={monthly:F2} MONTHS={months} TAX={tax:F2} TOTAL={total:F2}");
    }
}