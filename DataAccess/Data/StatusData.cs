using DataAccess.DbAccess;
using DataAccess.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.Data;
public class StatusData : IStatusData
{
    private readonly ISqlDataAccess _db;

    public StatusData(ISqlDataAccess db)
    {
        _db = db;
    }

    public async Task<IEnumerable<StatusModel?>> GetStatus()
    {
        var results = await _db.LoadData<StatusModel?, dynamic>("queue.spStatus_GetById", new { });

        return results;
    }

}
