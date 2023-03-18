using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using Gpta.Ticket.WebApp.Models;
using Gpta.Ticket.WebApp.Repository;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

namespace Gpta.Ticket.WebApp.Controllers
{
    [Authorize(Roles="TicketingAdministrator,TicketingReader")]
    public class ListController : Controller
    {
        public ITicketRepositry TicketRepository { get; }

        public ListController(ITicketRepositry ticketRepository)
        {
            TicketRepository = ticketRepository ?? throw new System.ArgumentNullException(nameof(ticketRepository));
        }

        public async Task<IActionResult> Index()
        {
            var tickets = await this.TicketRepository.GetTicketsAsync();

            return View(tickets);
        }
    }
}