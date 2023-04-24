using System;
using System.Threading.Tasks;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Host;
using Microsoft.Extensions.Logging;

namespace GSOR.Functions
{
    public class ServiceBusReceiver
    {
        [FunctionName("ServiceBusReceiver")]
        public async Task Run([ServiceBusTrigger("fromfunction", Connection = "ServiceBusConnectionString")]string myQueueItem, ILogger log)
        {
            log.LogInformation($"C# ServiceBus queue trigger function processed message: {myQueueItem}");
            await Notify(myQueueItem);
        }

        private async Task Notify(string message)
        {
        }
    }
}
