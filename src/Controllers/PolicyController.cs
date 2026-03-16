using Microsoft.AspNetCore.Mvc;
using Npgsql;
using MiniIngenium.Services;
using System.Threading.Tasks;

namespace MiniIngenium.Controllers;

[ApiController]
[Route("policy")]
public class PolicyController : ControllerBase
{
    private readonly DbService _db;
    private readonly CobolBridge _cobol;

    public PolicyController(DbService db, CobolBridge cobol)
    {
        _db    = db;
        _cobol = cobol;
    }

    [HttpGet("query")]
    public async Task<IActionResult> Query([FromQuery] int id)
    {
        await using var conn = _db.GetConnection();
        await conn.OpenAsync();
        await using var cmd = new NpgsqlCommand(
            "SELECT customer, product, base_premium, status " +
            "FROM policy WHERE policy_id = @id", conn);
        cmd.Parameters.AddWithValue("id", id);
        await using var reader = await cmd.ExecuteReaderAsync();
        if (!await reader.ReadAsync())
            return NotFound(new { error = "Policy not found" });

        return Ok(new {
            policy_id   = id,
            customer    = reader.GetString(0),
            product     = reader.GetString(1),
            base_premium= reader.GetDecimal(2),
            status      = reader.GetString(3)
        });
    }

    [HttpPost("rating")]
    public async Task<IActionResult> Rating([FromBody] PolicyRequest req)
    {
        await using var conn = _db.GetConnection();
        await conn.OpenAsync();
        await using var cmd = new NpgsqlCommand(
            "SELECT base_premium, product FROM policy " +
            "WHERE policy_id = @id AND status = 'ACTIVE'", conn);
        cmd.Parameters.AddWithValue("id", req.PolicyId);
        await using var reader = await cmd.ExecuteReaderAsync();
        if (!await reader.ReadAsync())
            return BadRequest(new { error = "Policy not found or inactive" });

        decimal premium = reader.GetDecimal(0);
        string product  = reader.GetString(1);
        reader.Close();

        // COBOL business logic
        var (final, msg) = _cobol.Rating(req.PolicyId, premium, product);

        // Update DB
        await using var upd = new NpgsqlCommand(
            "UPDATE policy SET base_premium = @p WHERE policy_id = @id", conn);
        upd.Parameters.AddWithValue("p",   final);
        upd.Parameters.AddWithValue("id",  req.PolicyId);
        await upd.ExecuteNonQueryAsync();

        return Ok(new { result = msg, new_premium = final });
    }

    [HttpPost("activate")]
    public async Task<IActionResult> Activate([FromBody] PolicyRequest req)
    {
        await using var conn = _db.GetConnection();
        await conn.OpenAsync();
        await using var cmd = new NpgsqlCommand(
            "UPDATE policy SET status = 'ACTIVE' WHERE policy_id = @id", conn);
        cmd.Parameters.AddWithValue("id", req.PolicyId);
        int rows = await cmd.ExecuteNonQueryAsync();
        return Ok(new { result = rows > 0 ? "POLICY ACTIVATED OK" : "NOT FOUND" });
    }

    [HttpPost("suspend")]
    public async Task<IActionResult> Suspend([FromBody] PolicyRequest req)
    {
        await using var conn = _db.GetConnection();
        await conn.OpenAsync();
        await using var cmd = new NpgsqlCommand(
            "UPDATE policy SET status = 'INACTIVE' WHERE policy_id = @id", conn);
        cmd.Parameters.AddWithValue("id", req.PolicyId);
        int rows = await cmd.ExecuteNonQueryAsync();
        return Ok(new { result = rows > 0 ? "POLICY SUSPENDED OK" : "NOT FOUND" });
    }
}

public record PolicyRequest(int PolicyId, decimal Amount = 0);