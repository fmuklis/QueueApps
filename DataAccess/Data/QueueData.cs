using Dapper;
using DataAccess.DbAccess;
using DataAccess.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.Data;
public class QueueData : IQueueData
{
    private readonly ISqlDataAccess _db;
    public QueueData(ISqlDataAccess db)
    {
        _db = db;
    }
    public async Task<QueueModel?> GetById(int id)
    {
        var results = await _db.LoadData<QueueModel, dynamic>("[queue].[spQueue_GetById]", new { queueId = id });

        return results.FirstOrDefault();
    }

    public async Task<IEnumerable<QueueModel?>> GetByStatus(int statusId)
    {
        var results = await _db.LoadData<QueueModel?, dynamic>("[queue].[spQueue_ByStatus]", new { StatusId = statusId });

        return results;
    }

    public async Task<QueueModel?> GetCurrentQueue(int counterId, int serviceTypeId, DateTime dateOfQueue)
    {
        var results = await _db.LoadData<QueueModel?, dynamic>("[queue].[spQueue_GetCurrentQueue]", new { CounterId = counterId, TypeId = serviceTypeId, DateOfQueue = dateOfQueue });

        return results.FirstOrDefault();
    }
    public async Task<QueueModel?> GetNext(int serviceTypeId, DateTime dateOfQueue)
    {
        var results = await _db.LoadData<QueueModel?, dynamic>("[queue].[spQueue_GetNext]", new { TypeId = serviceTypeId, DateOfQueue = dateOfQueue });

        return results.FirstOrDefault();
    }
    public async Task<QueueModel?> Create(int serviceTypeId, DateTime dateOfQueue)
    {
        var par = new DynamicParameters();
        par.Add("@serviceTypeId", serviceTypeId);
        par.Add("@dateOfQueue", dateOfQueue);
        par.Add("@queueId", 0, dbType: DbType.Int32, direction: ParameterDirection.Output);

        await _db.SaveData<DynamicParameters>("[queue].[spQueue_Create]", par);

        int queueId = par.Get<int>("@queueId");

        QueueModel? output = await GetById(queueId);
        
        return output;
    }
    
    public async Task<QueueModel?> UpdateStatus(int queueId, int queueStatusId)
    {
        await _db.SaveData<dynamic>("[queue].[spQueue_UpdateStatus]", new { QueueId = queueId, QueueStatusId = queueStatusId });

        QueueModel? output = await GetById(queueId);

        return output;
    }
}
