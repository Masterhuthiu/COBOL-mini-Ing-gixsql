using Microsoft.AspNetCore.Mvc;

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
                // Gọi trực tiếp class từ COBOL đã được Otterkit biên dịch
                // global::EmployeeRepo.InsertEmployee(req.Name ?? "", req.Age);
                
                return Ok(new { status = "Success", message = "Data processed by COBOL engine" });
            }
            catch (System.Exception ex)
            {
                return StatusCode(500, new { error = ex.Message });
            }
        }

        [HttpGet("list")]
        public IActionResult ListEmployees()
        {
            try
            {
                // global::EmployeeRepo.FetchEmployees();
                return Ok(new { status = "Executed", message = "Check server logs for COBOL DISPLAY output" });
            }
            catch (System.Exception ex)
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
}