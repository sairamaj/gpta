using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Gpta.Ticket.WebApp.Models;
using Gpta.Ticket.WebApp.Repository;
using Microsoft.AspNetCore.Authorization;

namespace Gpta.Ticket.WebApp.Controllers
{
    [Authorize(Roles="Administrator,Reader")]
    public class CheckInController : Controller
    {
        public ITicketRepositry TicketRepository { get; }

        public CheckInController(ITicketRepositry ticketRepository)
        {
            System.Console.WriteLine(" >> In uploadFilesController <<<");
            TicketRepository = ticketRepository ?? throw new System.ArgumentNullException(nameof(ticketRepository));
        }
        public async Task<IActionResult> Index()
        {
            var checkIns = await TicketRepository.GetCheckInsAsync();
            var tickets = await TicketRepository.GetTicketsAsync();
            checkIns = checkIns.Select(c=> {
                var checkedInTicket = tickets.FirstOrDefault(t=> t.Id == c.Id);
                c.Name = checkedInTicket == null ? "NA" : checkedInTicket.Name;
                return c;
            });
            return View(checkIns);
        }
    }
}
