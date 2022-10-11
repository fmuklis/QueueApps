using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.Models;
public class RegistrationModel
{
    public int QueueId { get; set; }
    public ServiceTypeModel ServiceType { get; set; } = new ();
    public CounterModel Counter { get; set; } = new ();
    public DateTime DateOfQueue { get; set; }
    public int QueueNumber { get; set; }
    public StatusModel QueueStatus { get; set; } = new ();
}