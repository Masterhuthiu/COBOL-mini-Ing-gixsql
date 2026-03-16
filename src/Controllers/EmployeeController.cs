using Microsoft.AspNetCore.Mvc;
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
    // Vẫn inject CobolBridge nếu bạn muốn giữ đúng cấu trúc Dependency Injection
    private readonly CobolBridge _cobol;

    public EmployeeController(DbService db, CobolBridge cobol)
    {
        _db = db;
        _cobol = cobol;
    }

    // POST: api/employee/add
    [HttpPost("add")]
    public IActionResult AddEmployee([FromBody] EmployeeRequest req)
    {
        try
        {
            if (string.IsNullOrEmpty(req.Name))
                return BadRequest(new { error = "Tên không được để trống" });

            // GỌI TRỰC TIẾP FILE COBOL (EmployeeRepo.cbl)
            // Vì method trong COBOL là STATIC, ta gọi qua tên Class
            global::EmployeeRepo.InsertEmployee(req.Name, req.Age);

            return Ok(new 
            { 
                status = "Success", 
                message = $"COBOL đã nhận lệnh thêm: {req.Name}",
                note = "Kiem tra Console Log de xem ket qua DISPLAY tu COBOL"
            });
        }
        catch (Exception ex)
        {
            return StatusCode(500, new { error = ex.Message });
        }
    }

    // GET: api/employee/list
    [HttpGet("list")]
    public IActionResult ListEmployees()
    {
        try
        {
            // GỌI TRỰC TIẾP FILE COBOL (EmployeeRepo.cbl)
            global::EmployeeRepo.FetchEmployees();

            return Ok(new 
            { 
                status = "Executed", 
                message = "COBOL đã thực hiện lệnh LIST",
                note = "Xem danh sach in ra tai terminal/log cua Docker"
            });
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