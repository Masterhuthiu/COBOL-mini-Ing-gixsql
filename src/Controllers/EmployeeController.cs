using Microsoft.AspNetCore.Mvc;
using System;

namespace MiniIngenium.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class EmployeeController : ControllerBase
    {
        [HttpPost("add")]
        public IActionResult AddEmployee([FromBody] EmployeeRequest req)
        {
            try
            {
                // Gọi class từ COBOL (Otterkit biên dịch class-id thành class .NET)
                // Nếu file COBOL không có Repository/Namespace, nó sẽ nằm ở Global Namespace
                global::EmployeeRepo.InsertEmployee(req.Name, req.Age);

                return Ok(new { status = "Success", message = "Added via COBOL" });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { error = ex.Message });
            }
        }

        [HttpGet("list")]
        public IActionResult ListEmployees()
        {
            try
            {
                global::EmployeeRepo.FetchEmployees();
                return Ok(new { status = "Executed", message = "Check server console for output" });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { error = ex.Message });
            }
        }
    }

    public class EmployeeRequest
    {
        // Thêm ? để xử lý cảnh báo CS8618 (Nullable)
        public string? Name { get; set; }
        public int Age { get; set; }
    }
}