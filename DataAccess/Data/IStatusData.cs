using DataAccess.Models;

namespace DataAccess.Data;
public interface IStatusData
{
    Task<IEnumerable<StatusModel?>> GetStatus();
}