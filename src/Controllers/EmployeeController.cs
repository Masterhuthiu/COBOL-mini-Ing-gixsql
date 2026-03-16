[ApiController]
[Route("api/[controller]")]
public class EmployeeController : ControllerBase
{
    [HttpPost("add")]
    public IActionResult Add([FromBody] EmployeeRequest req)
    {
        // Gọi phương thức static trong EmployeeRepo.cob
        EmployeeRepo.InsertEmployee(req.Name, req.Age);
        return Ok(new { status = "Success", message = $"Added {req.Name}" });
    }

    [HttpGet("list")]
    public IActionResult GetList()
    {
        // Lưu ý: FetchEmployees trong COBOL của bạn hiện đang dùng DISPLAY
        // Để API trả về JSON, bạn cần chỉnh sửa COBOL trả về List hoặc chuỗi.
        // Tạm thời gọi để kiểm tra log Console:
        EmployeeRepo.FetchEmployees();
        return Ok(new { status = "Executed", message = "Check console log for output" });
    }
}

public class EmployeeRequest { public string Name { get; set; }; public int Age { get; set; }; }