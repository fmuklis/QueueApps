using DataAccess.Models;

namespace DataAccess.Data;
public interface IServiceCategoryData
{
    Task<ServiceCategoryModel?> GetServiceCategory(int id);
}