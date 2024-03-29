using Microsoft.AspNetCore.Mvc;
using Gpta.Ticketing.Web.Shared;
using System.Text.Json;

namespace Gpta.Ticketing.Web.Server.Controllers;

[ApiController]
[Route("[controller]")]
public class AdministratorController : ControllerBase
{
    private readonly ILogger<TicketsController> _logger;
    private readonly IRepository _repository;

    public AdministratorController(
        ILogger<TicketsController> logger,
        IRepository repository)
    {
        this._logger = logger ?? throw new ArgumentNullException(nameof(logger));
        this._repository = repository ?? throw new ArgumentNullException(nameof(repository));
    }

    [HttpPost]
    [Route("/admin/tickets/upload")]
    public async Task<UploadSummary> Post()
    {
        System.Console.WriteLine("__________________________");
        System.Console.WriteLine("-------- Upload ------------");
        System.Console.WriteLine("__________________________");

        if (HttpContext.Request.Form.Files.Any())
        {
            foreach (var file in HttpContext.Request.Form.Files)
            {
                System.Console.WriteLine("=========================");
                System.Console.WriteLine($"FileName: {file.FileName}");
                System.Console.WriteLine($"ContentType: {file.ContentType}");
                System.Console.WriteLine($"ContentDisposition: {file.ContentDisposition}");
                System.Console.WriteLine("=========================");
                var summary = await this._repository.Upload(file.OpenReadStream());
                System.Console.WriteLine(JsonSerializer.Serialize(summary));
                return summary;
            }
        }

        return null;
    }

    [HttpDelete]
    [Route("/admin/tickets")]
    public async Task Delete()
    {
        await this._repository.ClearAll();
    }
}
