using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Gpta.Ticket.WebApp.Models;
using Microsoft.AspNetCore.Authorization;

namespace Gpta.Ticket.WebApp.Controllers
{
    [Authorize]
    public class DebugController : Controller
    {
        public IActionResult Index()
        {
            return View(User.Claims);
        }
    }
}