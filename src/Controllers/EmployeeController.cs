using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;
using System.Collections.Generic;

// namespace của bạn, ví dụ MiniIngenium.Controllers
namespace MiniIngenium.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class EmployeeController : ControllerBase
    {
        [HttpPost("add")]
        public IActionResult Add([FromBody] EmployeeRequest req)
        {
            // Gọi COBOL class đã build
            EmployeeRepo.InsertEmployee(req.Name, req.Age);
            return Ok(new { status = "Success", message = $"Added {req.Name}" });
        }

        [HttpGet("list")]
        public IActionResult GetList()
        {
            // COBOL hiện đang DISPLAY ra console
            EmployeeRepo.FetchEmployees();
            return Ok(new { status = "Executed", message = "Check console log for output" });
        }
    }

    public class EmployeeRequest
    {
        public string Name { get; set; }
        public int Age { get; set; }
    }
}
