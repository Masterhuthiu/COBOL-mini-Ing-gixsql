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