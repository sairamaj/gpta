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
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Caching.Memory;
namespace Gpta.Ticket.WebApp.Repository
{
    class TicketRepository : ITicketRepositry
    {
        string _baseUrl;
        ILogger _logger;
        IMemoryCache _cache;

        const string TicketsCacheKey = "tickets";
        public TicketRepository(
            IConfiguration configuration,
            ILogger<TicketRepository> logger,
            IMemoryCache cache)
        {
            _logger = logger;
            _cache = cache;
            this._baseUrl = configuration.GetSection("AppConfiguration")["TicketApiBaseUrl"];
            _logger.LogInformation($"TicketRepository baseUrl: {this._baseUrl}");
        }

        public async Task<IEnumerable<Gpta.Ticket.WebApp.Models.Ticket>> GetTicketsAsync()
        {
            var cachedTickets = GetCachedTickets();
            if (cachedTickets != null)
            {
                this._logger.LogInformation("GetTicketsAsync.Returning tickets from cache.");
                return cachedTickets;
            }

            // When we use with base Url and GetAsync with resource then AWS gateway is not working
            // Might be something FluentClient is not forming properly.
            // TODO: debug this
            var tickets = await new FluentClient(this._baseUrl + "/tickets")
            .GetAsync("")
            .As<IEnumerable<Gpta.Ticket.WebApp.Models.Ticket>>();

            this.SetTicketsCache(tickets);
            return tickets;
        }

        public async Task<IEnumerable<Gpta.Ticket.WebApp.Models.TicketCheckIn>> GetCheckInsAsync()
        {
            return await new FluentClient(this._baseUrl + "/tickets/checkins")
            .GetAsync("")
            .As<IEnumerable<Gpta.Ticket.WebApp.Models.TicketCheckIn>>();
        }

        public async Task<Gpta.Ticket.WebApp.Models.TicketSummary> GetSummaryAsync()
        {
            return await new FluentClient(this._baseUrl + "/tickets/summary")
            .GetAsync("")
            .As<Gpta.Ticket.WebApp.Models.TicketSummary>();
        }

        public async Task AddTicketsAsync(IEnumerable<Gpta.Ticket.WebApp.Models.Ticket> tickets)
        {
            var serializerSettings = new JsonSerializerSettings();
            serializerSettings.ContractResolver = new CamelCasePropertyNamesContractResolver();
            var data = JsonConvert.SerializeObject(tickets, serializerSettings);
            var content = new StringContent(data);
            content.Headers.ContentType = MediaTypeHeaderValue.Parse("application/x-www-form-urlencoded");

            // todo: why it is not working with AWS gateway base url and resource in postasync()
            await new FluentClient(this._baseUrl + "/tickets")
            .PostAsync("")
            .WithBodyContent(content);

            this.SetTicketsCache(null);
        }

        public async Task DeleteAllAsync()
        {
            _logger.LogInformation("Deleting all tickets");
            await new FluentClient(this._baseUrl + "/tickets").DeleteAsync("");
            this.SetTicketsCache(null);
        }

        private IEnumerable<Gpta.Ticket.WebApp.Models.Ticket> GetCachedTickets()
        {
            object tickets;
            if (_cache.TryGetValue(TicketsCacheKey, out tickets))
            {
                return tickets as IEnumerable<Gpta.Ticket.WebApp.Models.Ticket>; ;
            }
            
            return null;
        }

        private void SetTicketsCache(IEnumerable<Gpta.Ticket.WebApp.Models.Ticket> tickets)
        {
            _cache.Set(TicketsCacheKey, tickets);
        }
    }
}