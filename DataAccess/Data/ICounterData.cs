using DataAccess.Models;

namespace DataAccess.Data;
public interface ICounterData
{
    Task<IEnumerable<CounterModel?>> GetCounters();    
}