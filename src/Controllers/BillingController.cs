using Microsoft.AspNetCore.Mvc;
using Npgsql;
using MiniIngenium.Services;
using System.Threading.Tasks;
using System.Collections.Generic;

namespace MiniIngenium.Controllers;

[ApiController]
[Route("billing")]
public class BillingController : ControllerBase
{
    private readonly DbService _db;
    private readonly CobolBridge _cobol;

    public BillingController(DbService db, CobolBridge cobol)
    {
        _db    = db;
        _cobol = cobol;
    }

    [HttpPost("run-batch")]
    public async Task<IActionResult> RunBatch()
    {
        await using var conn = _db.GetConnection();
        await conn.OpenAsync();

        await using var sel = new NpgsqlCommand(
            "SELECT policy_id, base_premium FROM policy WHERE status = 'ACTIVE'",
            conn);
        await using var reader = await sel.ExecuteReaderAsync();

        var policies = new List<(int id, decimal premium)>();
        while (await reader.ReadAsync())
            policies.Add((reader.GetInt32(0), reader.GetDecimal(1)));
        reader.Close();

        int count = 0;
        foreach (var (pid, premium) in policies)
        {
            // COBOL BillingEngine: tính tổng + tax
            var (total, _) = _cobol.Billing(premium, 1);

            await using var ins = new NpgsqlCommand(
                "INSERT INTO invoice (policy_id, amount, status, due_date) " +
                "VALUES (@pid, @amt, 'UNPAID', '2026-04-01')", conn);
            ins.Parameters.AddWithValue("pid", pid);
            ins.Parameters.AddWithValue("amt", total);
            await ins.ExecuteNonQueryAsync();
            count++;
        }

        return Ok(new { result = "BATCH DONE", invoices_created = count });
    }

    [HttpGet("invoices")]
    public async Task<IActionResult> Invoices()
    {
        await using var conn = _db.GetConnection();
        await conn.OpenAsync();
        await using var cmd = new NpgsqlCommand(
            "SELECT invoice_id, policy_id, amount, status, due_date FROM invoice",
            conn);
        await using var reader = await cmd.ExecuteReaderAsync();

        var list = new List<object>();
        while (await reader.ReadAsync())
            list.Add(new {
                invoice_id = reader.GetInt32(0),
                policy_id  = reader.GetInt32(1),
                amount     = reader.GetDecimal(2),
                status     = reader.GetString(3),
                due_date   = reader.GetString(4)
            });

        return Ok(list);
    }
}