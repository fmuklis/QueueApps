using DataAccess.DbAccess;
using DataAccess.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.Data;
public class RegistrationData
{
    private readonly ISqlDataAccess _db;

    public RegistrationData(ISqlDataAccess db)
    {
        _db = db;
    }

    private void mapObj<T, U, V>()
    {
    }

    public async Task<RegistrationModel?> GetById(int id)
    {
        //dynamic mapObj = <RegistrationModel, ServiceTypeModel, CounterModel, StatusModel>;
        
        var response = await _db.LoadData <RegistrationModel, ServiceTypeModel, CounterModel, dynamic>("[queue].[spCounter_Get]", new { Id = id });

        return response.FirstOrDefault();
    }
}
