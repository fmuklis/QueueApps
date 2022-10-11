using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace QueueApi.Controllers;
[Route("api/[controller]")]
[ApiController]
public class OutpatientController : ControllerBase
{
    private readonly IOutpatientData _queue;

    public OutpatientController(IOutpatientData queue)
    {
        _queue = queue;
    }

    [HttpGet("Types")]
    public async Task<ActionResult> GetTypes()
    {
        var output = await _queue.TypesGet();

        if (output == null)
        {
            return NotFound();
        }
        
        return Ok(output);        
    }
    
    [HttpGet("Counters")]
    public async Task<ActionResult> GetCounters()
    {
        var output = await _queue.GetCounters();

        if (output == null)
        {
            return NotFound();
        }
        
        return Ok(output);        
    }

    [HttpGet("Status")]
    public async Task<ActionResult> GetStatus()
    {
        var output = await _queue.GetStatus();

        if (output == null)
        {
            return NotFound();
        }
        
        return Ok(output);
    }

    [HttpGet("{queueId}", Name = "GetQueueById")]
    public async Task<ActionResult> GetQueueById(int queueId)
    {
        var queue = await _queue.GetQueueById(queueId);

        if (queue == null)
        {
            return NotFound();
        }

        return Ok(queue);
    }

    [HttpGet("GetByStatus/{statusId}", Name = "GetQueueByStatus")]
    public async Task<ActionResult> GetQueueByStatus(int statusId)
    {
        var queue = await _queue.GetQueueByStatus(statusId, DateTime.Now);

        if (queue == null)
        {
            return NotFound();
        }

        return Ok(queue);
    }

    [HttpGet("LastCalled", Name = "GetQueueLastCalled")]
    public async Task<ActionResult> GetQueueLastCalled(int counterId, int typeId)
    {
        var output = await _queue.GetQueueLastCalled(counterId, typeId, DateTime.Now);

        if (output == null)
        {
            return NotFound();
        }

        return Ok(output);
    }

    [HttpGet("GetNext/{typeId}/{counterId}", Name = "GetQueueNext")]
    public async Task<ActionResult> GetQueueNext(int typeId, int counterId)
    {
        var output = await _queue.GetQueueNext(typeId, counterId, DateTime.Now);

        if (output == null)
        {
            return NotFound();
        }

        return Ok(output);
    }

    [HttpPost("{typeId}")]
    public async Task<ActionResult> CreateQueue(int typeId)
    {
        var queue = await _queue.CreateQueue(typeId, DateTime.Now);

        if (queue == null)
        {
            return NotFound();
        }

        return Ok(queue);
    }

    [HttpPatch("{QueueId}/{QueueStatusId}")]
    public async Task<ActionResult> UpdateQueueStatus(int QueueId, int QueueStatusId)
    {
        var queue = await _queue.UpdateQueueStatus(QueueId, QueueStatusId);

        if (queue == null)
        {
            return NotFound();
        }

        return Ok(queue);        
    }
}
