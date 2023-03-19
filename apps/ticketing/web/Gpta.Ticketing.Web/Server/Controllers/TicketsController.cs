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
    public IEnumerable<Ticket> Get()
    {
        yield return new Ticket{ Id="1", Name = "sai1", Adults =2, Kids=2};
        yield return new Ticket{ Id="2", Name = "sai2", Adults =2, Kids=3};
    }

    [HttpGet]
    [Route("/api/summary")]
    public async Task<TicketSummary> GetSummary()
    {
        return await this._repository.GetSummary();
    }
}
