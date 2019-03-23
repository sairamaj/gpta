using System.Collections.Generic;
using System.Threading.Tasks;

namespace Gpta.Ticket.WebApp.Repository
{
    public interface ITicketRepositry
    {
        Task<IEnumerable<Gpta.Ticket.WebApp.Models.Ticket>> GetTicketsAsync();
        Task<IEnumerable<Gpta.Ticket.WebApp.Models.TicketCheckIn>> GetCheckInsAsync();
        Task AddTicketsAsync(IEnumerable<Gpta.Ticket.WebApp.Models.Ticket> tickets);

        Task<Gpta.Ticket.WebApp.Models.TicketSummary> GetSummaryAsync();
        Task DeleteAllAsync();
    }


}