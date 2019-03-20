using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using Gpta.Ticket.WebApp.Models;
using Gpta.Ticket.WebApp.Repository;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Gpta.Ticket.WebApp.Controllers
{
    // https://malcoded.com/posts/react-file-upload
    public class UploadFilesController : Controller
    {
        public ITicketRepositry TicketRepository { get; }

        public UploadFilesController(ITicketRepositry ticketRepository)
        {
            System.Console.WriteLine(" >> In uploadFilesController <<<");
            TicketRepository = ticketRepository ?? throw new System.ArgumentNullException(nameof(ticketRepository));
        }

        [HttpPost]
        public async Task<IActionResult> Upload(List<IFormFile> files)
        {
            System.Console.WriteLine(">>>>>>>>>>>>>>. In Upload Post...");
            long size = files.Sum(f => f.Length);

            // full path to file in temp location
            var filePath = Path.GetTempFileName();

            foreach (var formFile in files)
            {
                if (formFile.Length > 0)
                {
                    using (var stream = new FileStream(filePath, FileMode.Create))
                    {
                        await formFile.CopyToAsync(stream);
                    }
                }
            }

            await AddTicketsFromFileAsync(filePath);
            // process uploaded files
            // Don't rely on or trust the FileName property without validation.
            System.Console.WriteLine($" >>>>>>>>>>>>>>.   Done {files.Count} size:{size}: filePath:{filePath}");
            return Ok(new { count = files.Count, size, filePath });
        }

        async Task AddTicketsFromFileAsync(string fileName)
        {
            const int batchSize = 5;
            var ticketsList = new List<Gpta.Ticket.WebApp.Models.Ticket>();
            foreach (var line in (await System.IO.File.ReadAllLinesAsync(fileName)).Skip(2))
            {
                var ticket = Gpta.Ticket.WebApp.Models.Ticket.Parse(line);
                if (ticket != null)
                {
                    System.Console.WriteLine($" ticket: {ticket}");
                    ticketsList.Add(ticket);
                    if (ticketsList.Count == batchSize)
                    {
                        await TicketRepository.AddTicketsAsync(ticketsList);
                        ticketsList.Clear();
                    }
                }
            }

            if (ticketsList.Any())
            {
                await TicketRepository.AddTicketsAsync(ticketsList);
            }
        }
    }
}