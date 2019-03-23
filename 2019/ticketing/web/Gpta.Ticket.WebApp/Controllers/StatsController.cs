using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Gpta.Ticket.WebApp.Models;
using Gpta.Ticket.WebApp.Repository;

namespace Gpta.Ticket.WebApp.Controllers
{
    public class StatsController : Controller
    {
        public ITicketRepositry TicketRepository { get; }

        public StatsController(ITicketRepositry ticketRepository)
        {
            TicketRepository = ticketRepository ?? throw new System.ArgumentNullException(nameof(ticketRepository));
        }

        public async Task<IActionResult> Index()
        {
            var summary = await this.TicketRepository.GetSummaryAsync();
            return View(summary);
        }
    }
}
