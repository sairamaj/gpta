using System.Text.Json;
using System.Text.Json.Serialization;
using Gpta.Ticketing.Web.Shared;

class Repository : IRepository
{
    private readonly IHttpClientFactory clientFactory;

    public Repository(IHttpClientFactory clientFactory)
    {
        this.clientFactory =
            clientFactory ?? throw new ArgumentNullException(nameof(clientFactory));
    }

    public async Task<TicketSummary> GetSummary()
    {
        var response = await this.Client.GetAsync($"summary");
        response.EnsureSuccessStatusCode();
        var data = await response.Content.ReadAsStringAsync();
        System.Console.WriteLine(data);
        return JsonSerializer.Deserialize<TicketSummary>(data, new JsonSerializerOptions
        {
            PropertyNameCaseInsensitive = true
        });
    }

    public async Task<IEnumerable<Ticket>> GetTickets()
    {
        throw new System.NotImplementedException();
    }

    private HttpClient Client
    {
        get { return this.clientFactory.CreateClient("ticketing-api"); }
    }
}
