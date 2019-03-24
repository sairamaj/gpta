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
    [Authorize(Roles = "TicketingAdministrator")]
    public class UploadController : Controller
    {
        public ITicketRepositry TicketRepository { get; }

        public UploadController(ITicketRepositry ticketRepository)
        {
            System.Console.WriteLine(" >> In uploadFilesController <<<");
            TicketRepository = ticketRepository ?? throw new System.ArgumentNullException(nameof(ticketRepository));
        }

        public IActionResult Index()
        {
            return View();
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

            var summary = await AddTicketsFromFileAsync(filePath);
            // process uploaded files
            // Don't rely on or trust the FileName property without validation.
            System.Console.WriteLine($" >>>>>>>>>>>>>>.   Done {files.Count} size:{size}: filePath:{filePath}");
            return View("Status", summary);
        }

        async Task<UploadSummary> AddTicketsFromFileAsync(string fileName)
        {
            int totalParsed = 0;
            int totalParseFailed = 0;
            var failedLines = new List<FailedLineInfo>();

            const int batchSize = 5;
            var ticketsList = new List<Gpta.Ticket.WebApp.Models.Ticket>();
            int headerLineCount = 2;
            int lineNumber = headerLineCount;  // we start w
            foreach (var line in (await System.IO.File.ReadAllLinesAsync(fileName)).Skip(headerLineCount))
            {
                try
                {
                    totalParsed++;
                    lineNumber++;
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
                catch (System.Exception e)
                {
                    totalParseFailed++;
                    failedLines.Add(new FailedLineInfo(line, lineNumber, $"Parsing error.{e.Message}"));
                }
            }

            if (ticketsList.Any())
            {
                await TicketRepository.AddTicketsAsync(ticketsList);
            }

            var status = string.Empty;
            if (failedLines.Any())
            {
                status = $"Some failed. Total {totalParsed} : failed:{totalParseFailed}";
            }
            else
            {
                status = $"Successfully parsed {totalParsed}";
            }

            return new UploadSummary(status, totalParsed, totalParseFailed, failedLines);
        }

        public async Task<IActionResult> Download(string filename)
        {
            if (filename == null)
                return Content("filename not present");

            var path = Path.Combine(
                           Directory.GetCurrentDirectory(),
                           "wwwroot", filename);

            var memory = new MemoryStream();
            using (var stream = new FileStream(path, FileMode.Open))
            {
                await stream.CopyToAsync(memory);
            }
            memory.Position = 0;
            return File(memory, GetContentType(path), Path.GetFileName(path));
        }

        private string GetContentType(string path)  
        {  
            var types = GetMimeTypes();  
            var ext = Path.GetExtension(path).ToLowerInvariant();  
            return types[ext];  
        }  

         private Dictionary<string, string> GetMimeTypes()  
        {  
            return new Dictionary<string, string>  
            {  
                {".txt", "text/plain"},  
                {".pdf", "application/pdf"},  
                {".doc", "application/vnd.ms-word"},  
                {".docx", "application/vnd.ms-word"},  
                {".xls", "application/vnd.ms-excel"},  
                {".xlsx", "application/vnd.openxmlformatsofficedocument.spreadsheetml.sheet"},  
                {".png", "image/png"},  
                {".jpg", "image/jpeg"},  
                {".jpeg", "image/jpeg"},  
                {".gif", "image/gif"},  
                {".csv", "text/csv"}  
            };  
        } 
    }
}