using Microsoft.AspNetCore.Mvc;
using Npgsql;
using MiniIngenium.Services;
using System.Threading.Tasks;
using System.Collections.Generic;


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
                if (req == null || string.IsNullOrEmpty(req.Name))
                {
                    return BadRequest(new { error = "Dữ liệu không hợp lệ. Tên không được để trống." });
                }

                // Gọi class-id EmployeeRepo từ file COBOL
                // Chúng ta dùng global:: để đảm bảo trình biên dịch C# tìm đúng class do Otterkit tạo ra
                global::EmployeeRepo.InsertEmployee(req.Name, req.Age);

                return Ok(new 
                { 
                    status = "Success", 
                    message = $"Nhân viên {req.Name} đã được thêm thành công qua logic COBOL." 
                });
            }
            catch (Exception ex)
            {
                // Trả về lỗi chi tiết để debug (ví dụ: lỗi kết nối Postgres)
                return StatusCode(500, new { error = ex.Message, stackTrace = ex.StackTrace });
            }
        }

        // GET: api/employee/list
        [HttpGet("list")]
        public IActionResult ListEmployees()
        {
            try
            {
                // Gọi phương thức hiển thị danh sách trong COBOL
                // Kết quả sẽ xuất hiện trong Console Log của Docker/GitHub Actions
                global::EmployeeRepo.FetchEmployees();

                return Ok(new 
                { 
                    status = "Executed", 
                    message = "Lệnh truy vấn đã chạy. Hãy kiểm tra Console Log để xem danh sách nhân viên." 
                });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { error = ex.Message });
            }
        }
    }

    // Class hứng dữ liệu JSON từ request
    public class EmployeeRequest
    {
        public string? Name { get; set; }
        public int Age { get; set; }
    }
}