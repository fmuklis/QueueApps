using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.Models;
public class QueueModel
{
    public int QueueId { get; set; }
    public int ServiceTypeId { get; set; }
    public int CounterId { get; set; }
    public DateTime DateOfQueue { get; set; }
    public int QueueNumber { get; set; }
    public int QueueStatusId { get; set; }
}
