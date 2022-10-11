using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.Models;
public class OutpatientModel
{
    public int QueueId { get; set; }
    public string TypeName { get; set; } = string.Empty;
    public string CounterName { get; set; } = string.Empty;
    public DateTime DateOfQueue { get; set; }
    public string ServiceTypeCode { get; set; } = string.Empty;
    public int QueueNumber { get; set; }
    public string StatusName { get; set; } = string.Empty;
}
