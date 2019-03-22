using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Gpta.Ticket.WebApp.Models;

namespace Gpta.Ticket.WebApp.Controllers
{
    public class DebugController : Controller
    {
        public IActionResult Index()
        {
            return View(User.Claims);
        }
    }
}