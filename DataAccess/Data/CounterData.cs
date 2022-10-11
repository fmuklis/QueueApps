using DataAccess.DbAccess;
using DataAccess.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.Data;
public class CounterData : ICounterData
{
    private readonly ISqlDataAccess _db;

    public CounterData(ISqlDataAccess db)
    {
        _db = db;
    }

    public async Task<IEnumerable<CounterModel?>> GetCounters()
    {
        var results = await _db.LoadData<CounterModel?, dynamic>("[queue].[spCounter_Get]", new {});

        return results;
    }

    public async Task<CounterModel?> CounterGetById(int id)
    {
        var results = await _db.LoadData<CounterModel?, dynamic>("[queue].[spCounter_GetById]", new { queueId = id });

        return results.FirstOrDefault();
    }
}
