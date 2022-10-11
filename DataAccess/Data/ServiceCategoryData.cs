using DataAccess.DbAccess;
using DataAccess.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.Data;
public class ServiceCategoryData : IServiceCategoryData
{
    private readonly ISqlDataAccess _db;

    public ServiceCategoryData(ISqlDataAccess db)
    {
        _db = db;
    }

    public async Task<ServiceCategoryModel?> GetServiceCategory(int id)
    {
        var results = await _db.LoadData<ServiceCategoryModel?, dynamic>("queue.spServiceCategory_GetById", new { queueId = id });

        return results.FirstOrDefault();
    }
}
