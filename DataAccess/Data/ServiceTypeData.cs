using DataAccess.DbAccess;
using DataAccess.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.Data;
public class ServiceTypeData : IServiceTypeData
{
    private readonly ISqlDataAccess _db;

    public ServiceTypeData(ISqlDataAccess db)
    {
        _db = db;
    }

    public async Task<IEnumerable<ServiceTypeModel?>> ServiceTypeGet()
    {
        var results = await _db.LoadData<ServiceTypeModel?, dynamic>("queue.spServiceType_Get", new {});

        return results;
    }

    public async Task<ServiceTypeModel?> ServiceTypeGetById(int id)
    {
        var results = await _db.LoadData<ServiceTypeModel?, dynamic>("queue.spServiceType_GetById", new { serviceTypeId = id });

        return results.FirstOrDefault();
    }
}
