using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using Gpta.Ticket.WebApp.Models;
using Gpta.Ticket.WebApp.Repository;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Gpta.Ticket.WebApp.Controllers
{
    [Authorize]
    public class ListController : Controller
    {
        public ITicketRepositry TicketRepository { get; }

        public ListController(ITicketRepositry ticketRepository)
        {
            System.Console.WriteLine(" >> In uploadFilesController <<<");
            TicketRepository = ticketRepository ?? throw new System.ArgumentNullException(nameof(ticketRepository));
        }

        public async Task<IActionResult> Index()
        {
            var tickets = await this.TicketRepository.GetTicketsAsync();

            return View(tickets);
        }
    }
}