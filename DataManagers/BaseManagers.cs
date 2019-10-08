
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using DFS.Common;

namespace DFS.Data.Managers
{
    public abstract class BaseManagers
    {
        private static Dictionary<string, string> connectionStrings = new Dictionary<string, string>();

        public BaseManagers()
        {

        }

        public static IDbConnection GetConnection(string database)
        {
            return new SqlConnection(connectionStrings[database]);
        }

        public static void SetConnectionString(string name, string connectionString)
        {
            connectionStrings[name] = connectionString;
        }
    }
}
