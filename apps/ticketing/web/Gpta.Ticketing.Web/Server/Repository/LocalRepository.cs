using Gpta.Ticketing.Web.Shared;

internal class LocalRepository : CoreRepository, IRepository
{
    public async Task ClearAll()
    {
        System.Console.WriteLine("LocalRepository ClearAll");
        await Task.Delay(0);
    }

    public async Task<TicketSummary> GetSummary()
    {
        await Task.FromResult(0);
        return new TicketSummary
        {
            Adults = 10,
            CheckedInAdults = 5,
            Kids = 6,
            CheckedInKids = 3
        };
    }

    public async Task<IEnumerable<Ticket>> GetTickets()
    {
        await Task.Delay(0);
        var tickets = new List<Ticket>();

        tickets.Add(new Ticket { Id = "1", Name = "sai1", Adults = 2, Kids = 2 });
        tickets.Add(new Ticket { Id = "2", Name = "sai2", Adults = 2, Kids = 3 });
        return tickets;
    }

    public async Task<UploadSummary> Upload(Stream stream)
    {
        return await base.Upload(stream, tickets => {
            System.Console.WriteLine("LocalRepository Begin Upload...");
            foreach(var t in tickets){
                System.Console.WriteLine(t);
            }
            System.Console.WriteLine("LocalRepository End...");
        });
    }
}
