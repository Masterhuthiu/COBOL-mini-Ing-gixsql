using Npgsql;
using System.IO;
using System.Threading.Tasks;

namespace MiniIngenium.Services;

public class DbService
{
    private readonly string _connStr;

    public DbService()
    {
        var host = System.Environment.GetEnvironmentVariable("PGHOST") ?? "db";
        var db   = System.Environment.GetEnvironmentVariable("PGDATABASE") ?? "ingenium";
        var user = System.Environment.GetEnvironmentVariable("PGUSER") ?? "postgres";
        var pass = System.Environment.GetEnvironmentVariable("PGPASSWORD") ?? "postgres";
        _connStr = $"Host={host};Database={db};Username={user};Password={pass}";
    }

    public NpgsqlConnection GetConnection() => new NpgsqlConnection(_connStr);

    public async Task InitSchemaAsync()
    {
        // Schema đã được psql load trước khi app start (trong CI và Docker CMD)
        // Chỉ cần verify connection OK
        await using var conn = GetConnection();
        await conn.OpenAsync();
        await using var cmd = new NpgsqlCommand(
            "SELECT COUNT(*) FROM information_schema.tables " +
            "WHERE table_name = 'policy'", conn);
        var count = (long)(await cmd.ExecuteScalarAsync() ?? 0L);
        if (count == 0)
            throw new InvalidOperationException(
                "Table 'policy' not found. " +
                "Run: psql -f db/schema.sql before starting the app.");
    }
}