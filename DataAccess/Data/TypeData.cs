using DataAccess.DbAccess;
using DataAccess.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.Data;
public class TypeData : ITypeData
{
    private readonly ISqlDataAccess _db;

    public TypeData(ISqlDataAccess db)
    {
        _db = db;
    }
    public async Task<TypeModel?> TypeGetById(int id)
    {
        var results = await _db.LoadData<TypeModel?, dynamic>("queue.spType_GetById", new { typeId = id });

        return results.FirstOrDefault();
    }

    public async Task<IEnumerable<TypeModel?>> TypesGet()
    {
        var results = await _db.LoadData<TypeModel?, dynamic>("queue.spType_Get", new {});

        return results;
    }
}
