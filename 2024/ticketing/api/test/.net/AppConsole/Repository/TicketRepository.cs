using Pathoschild.Http.Client;
using System;
using System.Collections.Generic;
using AppConsole.Model;
using Newtonsoft.Json;
using System.Threading.Tasks;
using Pathoschild.Http.Client.Formatters;
using System.Net.Http.Formatting;
using System.Net.Http;
using System.Net.Http.Headers;
using Newtonsoft.Json.Serialization;

namespace AppConsole.Repository
{
    class TicketRepository
    {
        string _baseUrl;
        public TicketRepository(string baseUrl)
        {
            this._baseUrl = baseUrl;
        }

        public async Task<IEnumerable<Ticket>> GetTicketsAsync()
        {
            return await new FluentClient(this._baseUrl)
            .GetAsync("/tickets")
            .As<IEnumerable<Ticket>>();
        }

        public async Task AddTicketsAsync(IEnumerable<Ticket> tickets)
        {
            var serializerSettings = new JsonSerializerSettings();
            serializerSettings.ContractResolver = new CamelCasePropertyNamesContractResolver();
            var data = JsonConvert.SerializeObject(tickets, serializerSettings);
            var content = new StringContent(data);
            content.Headers.ContentType = MediaTypeHeaderValue.Parse("application/x-www-form-urlencoded");
            await new FluentClient(this._baseUrl)
            .PostAsync("/tickets")
            .WithBodyContent(content);
        }
    }
}

