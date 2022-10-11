namespace DataAccess.Models;

public class ServiceTypeModel
{
    public int ServiceTypeId { get; set; }
    public int ServiceCategoryId { get; set; }
    public int TypeId { get; set; }
    public string ServiceTypeName { get; set; } = string.Empty;
    public string ServiceTypeCode { get; set; } = string.Empty;
}