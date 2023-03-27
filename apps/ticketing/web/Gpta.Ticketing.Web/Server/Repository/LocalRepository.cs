using System.Text.Json;
using System.Text.Json.Serialization;
using Gpta.Ticketing.Web.Shared;

class LocalRepository : IRepository
{
    
    public async Task<TicketSummary> GetSummary()
    {
        await Task.FromResult(0);
        return new TicketSummary{
            Adults = 10,
            CheckedInAdults = 5,
            Kids = 6,
            CheckedInKids = 3
        };
    }

  public async Task<IEnumerable<Ticket>> GetTickets()
    {
        var tickets = new List<Ticket>();

        tickets.Add(new Ticket{ Id="1", Name = "sai1", Adults =2, Kids=2});
        tickets.Add(new Ticket{ Id="2", Name = "sai2", Adults =2, Kids=3});
        return tickets;
    }
}
