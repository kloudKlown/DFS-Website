using Microsoft.Extensions.Configuration;

namespace DFS.Services.Interfaces
{
    public interface IConfigurationService
    {
        IConfiguration Configuration { get; }
    }
}
