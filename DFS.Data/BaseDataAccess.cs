using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;

namespace DFS.Data
{
    /// <summary>
    /// TODO: Fix this Entier Class and more abstraction
    /// </summary>
    public class BaseDataAccess
    {
        protected string ConnectionString { get; set; }

        public SqlParameter AddParameter(string parameterName, SqlDbType type, object parameterValue)
        {
            return new SqlParameter(parameterName, type, int.MaxValue, ParameterDirection.Input, true, 0, 0, string.Empty, DataRowVersion.Current, parameterValue  );

        }

    }
}
