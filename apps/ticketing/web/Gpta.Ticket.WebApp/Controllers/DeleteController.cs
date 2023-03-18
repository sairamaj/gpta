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
    [Authorize(Roles="TicketingAdministrator")]
    public class DeleteController : Controller
    {
        public ITicketRepositry TicketRepository { get; }

        public DeleteController(ITicketRepositry ticketRepository)
        {
            TicketRepository = ticketRepository ?? throw new System.ArgumentNullException(nameof(ticketRepository));
        }

        public IActionResult Index()
        {
            return View();
        }

        [HttpPost]
        public async Task<IActionResult> Delete()
        {
            await TicketRepository.DeleteAllAsync();
            return RedirectToAction("Index", "List", new { });
        }
    }
}