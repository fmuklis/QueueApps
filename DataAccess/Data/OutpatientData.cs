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
public class OutpatientData : IOutpatientData
{
    private readonly ISqlDataAccess _db;
    public OutpatientData(ISqlDataAccess db)
    {
        _db = db;
    }
    public async Task<OutpatientModel?> GetQueueById(int id)
    {
        var results = await _db.LoadData<OutpatientModel, dynamic>("[queue].[spOutpatient_GetById]", new { queueId = id });

        return results.FirstOrDefault();
    }

    public async Task<IEnumerable<OutpatientModel?>> GetQueueByStatus(int queueStatusId, DateTime dateOfQueue)
    {
        var results = await _db.LoadData<OutpatientModel?, dynamic>("[queue].[spOutpatient_GetByStatus]", new { QueueStatusId = queueStatusId, DateOfQueue = dateOfQueue });

        return results;
    }

    public async Task<OutpatientModel?> GetQueueLastCalled(int counterId, int typeId, DateTime dateOfQueue)
    {
        var results = await _db.LoadData<OutpatientModel?, dynamic>("[queue].[spOutpatient_GetCurrentQueue]", new { CounterId = counterId, TypeId = typeId, DateOfQueue = dateOfQueue });

        return results.FirstOrDefault();
    }
    public async Task<OutpatientModel?> GetQueueNext(int typeId, int counterId,  DateTime dateOfQueue)
    {
        var results = await _db.LoadData<OutpatientModel?, dynamic>("[queue].[spOutpatient_GetNext]", new { TypeId = typeId, CounterId = counterId, DateOfQueue = dateOfQueue });

        return results.FirstOrDefault();
    }
    public async Task<OutpatientModel?> CreateQueue(int typeId, DateTime dateOfQueue)
    {
        var par = new DynamicParameters();
        par.Add("@typeId", typeId);
        par.Add("@dateOfQueue", dateOfQueue);
        par.Add("@queueId", 0, dbType: DbType.Int32, direction: ParameterDirection.Output);

        await _db.SaveData<DynamicParameters>("[queue].[spOutpatient_Create]", par);

        int queueId = par.Get<int>("@queueId");

        OutpatientModel? output = await GetQueueById(queueId);

        return output;
    }

    public async Task<OutpatientModel?> UpdateQueueStatus(int queueId, int queueStatusId)
    {
        await _db.SaveData<dynamic>("[queue].[spOutpatient_UpdateStatus]", new { QueueId = queueId, QueueStatusId = queueStatusId });

        OutpatientModel? output = await GetQueueById(queueId);

        return output;
    }

    public async Task<TypeModel?> TypeGetById(int id)
    {
        var results = await _db.LoadData<TypeModel?, dynamic>("queue.spOutpatientType_GetById", new { typeId = id });

        return results.FirstOrDefault();
    }

    public async Task<IEnumerable<TypeModel?>> TypesGet()
    {
        var results = await _db.LoadData<TypeModel?, dynamic>("queue.spOutpatientType_Get", new { });

        return results;
    }

    public async Task<IEnumerable<StatusModel?>> GetStatus()
    {
        var results = await _db.LoadData<StatusModel?, dynamic>("queue.spOutpatientStatus_Get", new {});

        return results;
    }

    public async Task<IEnumerable<CounterModel?>> GetCounters()
    {
        var results = await _db.LoadData<CounterModel?, dynamic>("[queue].[spOutpatientCounter_Get]", new { });

        return results;
    }
}
