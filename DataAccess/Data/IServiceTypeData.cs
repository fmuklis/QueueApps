using DataAccess.Models;

namespace DataAccess.Data;
public interface IServiceTypeData
{
    Task<IEnumerable<ServiceTypeModel?>> ServiceTypeGet();
    Task<ServiceTypeModel?> ServiceTypeGetById(int serviceTypeId);
}