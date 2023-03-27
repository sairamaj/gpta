using Microsoft.AspNetCore.Mvc;
using Gpta.Ticketing.Web.Shared;

namespace Gpta.Ticketing.Web.Server.Controllers;

[ApiController]
[Route("[controller]")]
public class TicketsController : ControllerBase
{
    private readonly ILogger<TicketsController> _logger;
    private readonly IRepository _repository;

    public TicketsController(
        ILogger<TicketsController> logger,
        IRepository repository)
    {
        this._logger = logger ?? throw new ArgumentNullException(nameof(logger));
        this._repository = repository ?? throw new ArgumentNullException(nameof(repository));
    }

    [HttpGet]
    [Route("/api/tickets")]
    public async Task<IEnumerable<Ticket>> Get()
    {
        System.Console.WriteLine("/api/tickets...");
        return await this._repository.GetTickets();
    }

    [HttpGet]
    [Route("/api/summary2")]
    public async Task<TicketSummary> GetSummary()
    {
        System.Console.WriteLine("/api/summary2...");
        return await this._repository.GetSummary();
    }
}
