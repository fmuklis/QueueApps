using DataAccess.Models;

namespace DataAccess.Data;
public interface ITypeData
{
    Task<IEnumerable<TypeModel?>> TypesGet();
    Task<TypeModel?> TypeGetById(int id);
}