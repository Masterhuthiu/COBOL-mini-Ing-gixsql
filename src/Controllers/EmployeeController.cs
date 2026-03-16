using Microsoft.AspNetCore.Mvc;
using Npgsql;
using MiniIngenium.Services;
using System;
using System.Threading.Tasks;
using System.Collections.Generic;

namespace MiniIngenium.Controllers;

[ApiController]
[Route("api/[controller]")]
public class EmployeeController : ControllerBase
{
    private readonly DbService _db;
    private readonly CobolBridge _cobol;

    public EmployeeController(DbService db, CobolBridge cobol)
    {
        _db = db;
        _cobol = cobol;
    }

    // POST: api/employee/add
    [HttpPost("add")]
    public async Task<IActionResult> AddEmployee([FromBody] EmployeeRequest req)
    {
        try
        {
            if (string.IsNullOrEmpty(req.Name))
                return BadRequest(new { error = "Tên không được để trống" });

            // GỌI SQL TRỰC TIẾP TRONG COBOL QUA BRIDGE
            // Phương thức này sẽ kích hoạt EmployeeRepo.InsertEmployee trong file .cbl
            _cobol.AddEmployee(req.Name, req.Age);

            return Ok(new 
            { 
                status = "Success", 
                message = $"Đã thêm {req.Name} vào DB bằng SQL thực thi bên trong COBOL." 
            });
        }
        catch (Exception ex)
        {
            return StatusCode(500, new { error = ex.Message });
        }
    }

    // GET: api/employee/list
    [HttpGet("list")]
    public async Task<IActionResult> ListEmployees()
    {
        try
        {
            // Lấy dữ liệu từ DB để trả về JSON (giống cách làm của BillingController)
            await using var conn = _db.GetConnection();
            await conn.OpenAsync();

            await using var cmd = new NpgsqlCommand(
                "SELECT id, name, age FROM emp ORDER BY id DESC", 
                conn);
            await using var reader = await cmd.ExecuteReaderAsync();

            var employees = new List<object>();
            while (await reader.ReadAsync())
            {
                employees.Add(new
                {
                    id = reader.GetInt32(0),
                    name = reader.GetString(1),
                    age = reader.GetInt32(2)
                });
            }

            // Gọi thêm lệnh DISPLAY của COBOL để kiểm tra Log Console
            _cobol.FetchEmployees();

            return Ok(employees);
        }
        catch (Exception ex)
        {
            return StatusCode(500, new { error = ex.Message });
        }
    }
}

public class EmployeeRequest
{
    public string? Name { get; set; }
    public int Age { get; set; }
}