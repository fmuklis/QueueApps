using DataAccess.Models;

namespace DataAccess.Data;
public interface IOutpatientData : ICounterData, IStatusData, ITypeData
{
    Task<OutpatientModel?> CreateQueue(int typeId, DateTime dateOfQueue);
    Task<OutpatientModel?> GetQueueById(int id);
    Task<IEnumerable<OutpatientModel?>> GetQueueByStatus(int queueStatusId, DateTime dateOfQueue);
    Task<OutpatientModel?> GetQueueLastCalled(int counterId, int typeId, DateTime dateOfQueue);
    Task<OutpatientModel?> GetQueueNext(int typeId, int counterId, DateTime dateOfQueue);
    Task<OutpatientModel?> UpdateQueueStatus(int queueId, int queueStatusId);
}