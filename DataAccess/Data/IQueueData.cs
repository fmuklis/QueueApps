using DataAccess.Models;

namespace DataAccess.Data;
public interface IQueueData
{
    Task<QueueModel?> GetById(int queueId);
    Task<IEnumerable<QueueModel?>> GetByStatus(int statusId);
    Task<QueueModel?> GetCurrentQueue(int counterId, int serviceTypeId, DateTime dateOfQueue);
    Task<QueueModel?> GetNext(int serviceTypeId, DateTime dateOfQueue);
    Task<QueueModel?> Create(int serviceTypeId, DateTime dateOfQueue);
    Task<QueueModel?> UpdateStatus(int queueId, int queueStatusId);
}