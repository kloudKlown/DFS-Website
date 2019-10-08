using DFS.Data.Managers;
using DFS.Services.Interfaces;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Text;

namespace DFS.Services
{
    public class ConfigurationService : IConfigurationService
    {
        public IConfiguration Configuration { get; private set; }

        public ConfigurationService(IConfiguration config)
        {
            Configuration = config;

            BaseManagers.SetConnectionString("NBA", config.GetConnectionString("NBA"));
        }
    }
}
