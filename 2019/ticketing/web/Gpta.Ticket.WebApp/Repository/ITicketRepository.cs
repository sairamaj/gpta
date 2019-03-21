using System.Collections.Generic;
using System.Threading.Tasks;

namespace Gpta.Ticket.WebApp.Repository
{
    public interface ITicketRepositry
    {
        Task<IEnumerable<Gpta.Ticket.WebApp.Models.Ticket>> GetTicketsAsync();
        Task AddTicketsAsync(IEnumerable<Gpta.Ticket.WebApp.Models.Ticket> tickets);
        Task DeleteAllAsync();
    }
}