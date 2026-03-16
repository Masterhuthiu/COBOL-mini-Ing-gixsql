using Microsoft.AspNetCore.Mvc;
using Npgsql;
using MiniIngenium.Services;
using System.Threading.Tasks;

namespace MiniIngenium.Controllers;

[ApiController]
[Route("claim")]
public class ClaimController : ControllerBase
{
    private readonly DbService _db;
    private readonly CobolBridge _cobol;

    public ClaimController(DbService db, CobolBridge cobol)
    {
        _db    = db;
        _cobol = cobol;
    }

    [HttpPost("submit")]
    public async Task<IActionResult> Submit([FromBody] ClaimRequest req)
    {
        // COBOL check trước — ClaimCheck logic
        string check = _cobol.ClaimCheck(req.Amount);

        await using var conn = _db.GetConnection();
        await conn.OpenAsync();

        await using var chk = new NpgsqlCommand(
            "SELECT status FROM policy WHERE policy_id = @id", conn);
        chk.Parameters.AddWithValue("id", req.PolicyId);
        var status = (string?)await chk.ExecuteScalarAsync();

        if (status != "ACTIVE")
            return BadRequest(new { error = "Policy not active" });

        await using var ins = new NpgsqlCommand(
            "INSERT INTO claim (policy_id, amount, status) " +
            "VALUES (@pid, @amt, 'PENDING')", conn);
        ins.Parameters.AddWithValue("pid", req.PolicyId);
        ins.Parameters.AddWithValue("amt", req.Amount);
        await ins.ExecuteNonQueryAsync();

        return Ok(new { result = "CLAIM SUBMITTED OK", cobol_check = check });
    }

    [HttpPost("approve")]
    public async Task<IActionResult> Approve([FromBody] ClaimRequest req)
    {
        await using var conn = _db.GetConnection();
        await conn.OpenAsync();
        await using var cmd = new NpgsqlCommand(
            "UPDATE claim SET status = 'APPROVED' " +
            "WHERE policy_id = @id AND status = 'PENDING'", conn);
        cmd.Parameters.AddWithValue("id", req.PolicyId);
        int rows = await cmd.ExecuteNonQueryAsync();
        return Ok(new { result = rows > 0 ? "CLAIM APPROVED OK" : "NO PENDING CLAIMS" });
    }
}

public record ClaimRequest(int PolicyId, decimal Amount);