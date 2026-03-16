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
        [HttpPost("add")]
        public IActionResult AddEmployee([FromBody] EmployeeRequest req)
        {
            // Gọi trực tiếp phương thức static trong EmployeeRepo.cbl
            // EmployeeRepo.InsertEmployee(req.Name, req.Age);
            return Ok(new { message = "Thêm nhân viên thành công từ COBOL logic!" });
        }
    }
}