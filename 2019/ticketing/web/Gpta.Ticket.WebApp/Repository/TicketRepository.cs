using Pathoschild.Http.Client;
using System;
using System.Collections.Generic;
using Gpta.Ticket.WebApp.Models;
using Newtonsoft.Json;
using System.Threading.Tasks;
using Pathoschild.Http.Client.Formatters;
using System.Net.Http.Formatting;
using System.Net.Http;
using System.Linq;
using System.Net.Http.Headers;
using Newtonsoft.Json.Serialization;
using Microsoft.Extensions.Configuration;

namespace Gpta.Ticket.WebApp.Repository
{
    class TicketRepository : ITicketRepositry
    {
        string _baseUrl;
        public TicketRepository(IConfiguration configuration)
        {
            this._baseUrl = configuration.GetSection("AppConfiguration")["TicketApiBaseUrl"];
            System.Console.WriteLine($"TicketRepository baseUrl: {this._baseUrl}");
        }

        public async Task<IEnumerable<Gpta.Ticket.WebApp.Models.Ticket>> GetTicketsAsync()
        {
            return await new FluentClient(this._baseUrl)
            .GetAsync("/tickets")
            .As<IEnumerable<Gpta.Ticket.WebApp.Models.Ticket>>();
        }

        public async Task AddTicketsAsync(IEnumerable<Gpta.Ticket.WebApp.Models.Ticket> tickets)
        {
            System.Console.WriteLine($"Adding tickets...:{tickets.Count()}");
            var serializerSettings = new JsonSerializerSettings();
            serializerSettings.ContractResolver = new CamelCasePropertyNamesContractResolver();
            var data = JsonConvert.SerializeObject(tickets, serializerSettings);
            var content = new StringContent(data);
            content.Headers.ContentType = MediaTypeHeaderValue.Parse("application/x-www-form-urlencoded");
            await new FluentClient(this._baseUrl)
            .PostAsync("/tickets")
            .WithBodyContent(content);
        }

        public async Task DeleteAllAsync(){
            await new FluentClient(this._baseUrl).DeleteAsync("/tickets");
        }
    }    
}