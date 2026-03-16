using Microsoft.AspNetCore.Mvc;
using System;

namespace MiniIngenium.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class EmployeeController : ControllerBase
    {
        // POST: api/employee/add
        [HttpPost("add")]
        public IActionResult AddEmployee([FromBody] EmployeeRequest req)
        {
            try
            {
                if (string.IsNullOrEmpty(req.Name))
                {
                    return BadRequest(new { error = "Tên không được để trống" });
                }

                [cite_start]// Gọi phương thức static InsertEmployee từ EmployeeRepo.cob [cite: 3, 4]
                EmployeeRepo.InsertEmployee(req.Name, req.Age);

                return Ok(new 
                { 
                    status = "Success", 
                    message = $"Đã thêm nhân viên {req.Name} vào database qua COBOL." 
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
                [cite_start]// Gọi phương thức FetchEmployees từ EmployeeRepo.cob [cite: 7, 8]
                // Lưu ý: Kết quả sẽ DISPLAY ra console của server (GitHub Actions log)
                EmployeeRepo.FetchEmployees();

                return Ok(new 
                { 
                    status = "Executed", 
                    message = "Danh sách nhân viên đã được in ra Console Log của Server." 
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
        public string Name { get; set; }
        public int Age { get; set; }
    }
}