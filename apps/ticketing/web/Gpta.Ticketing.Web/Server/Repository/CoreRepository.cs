using Gpta.Ticketing.Web.Shared;

internal class CoreRepository
{
    protected async Task<UploadSummary> Upload(Stream stream, Action<IEnumerable<Ticket>> onAdd)
    {
        int totalParsed = 0;
        int totalParseFailed = 0;
        var failedLines = new List<FailedLineInfo>();

        const int batchSize = 5;
        var ticketsList = new List<Ticket>();
        int headerLineCount = 2;
        int lineNumber = 0;
        var sr = new StreamReader(stream);
        while (true)
        {
            var line = await sr.ReadLineAsync();
            System.Console.WriteLine(line);
            if (line == null)
            {
                break;
            }
            lineNumber++;
            if (lineNumber <= headerLineCount)
            {
                continue;   // skip header.
            }
            try
            {
                totalParsed++;
                System.Console.WriteLine("Parsing...");
                var ticket = Ticket.Parse(line);
                if (ticket != null)
                {
                    System.Console.WriteLine(ticket);
                    ticketsList.Add(ticket);
                    if (ticketsList.Count == batchSize)
                    {
                        onAdd(ticketsList);
                        ticketsList.Clear();
                    }
                }
                else
                {
                    totalParseFailed++;
                    failedLines.Add(new FailedLineInfo(line, lineNumber, $"Parsing error, Not all fields exists."));
                }
            }
            catch (System.Exception e)
            {
                totalParseFailed++;
                failedLines.Add(new FailedLineInfo(line, lineNumber, $"Parsing error.{e.Message}"));
            }
        }

        // final batch.
        if (ticketsList.Any())
        {
            onAdd(ticketsList);
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

}