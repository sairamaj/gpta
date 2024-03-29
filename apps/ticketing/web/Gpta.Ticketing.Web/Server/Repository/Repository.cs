using System.Net.Http.Headers;
using System.Text.Json;
using System.Text.Json.Serialization;
using Gpta.Ticketing.Web.Shared;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;

internal class Repository : CoreRepository, IRepository
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
        return System.Text.Json.JsonSerializer.Deserialize<TicketSummary>(data, new JsonSerializerOptions
        {
            PropertyNameCaseInsensitive = true
        });
    }

    public async Task<IEnumerable<Ticket>> GetTickets()
    {
        return await this.Client.GetFromJsonAsync<IEnumerable<Ticket>>("");
    }

    public async Task<UploadSummary> Upload(Stream stream) => await base.Upload(stream, async tickets =>
    {
        System.Console.WriteLine("Repository Begin Upload...");
        foreach (var t in tickets)
        {
            System.Console.WriteLine(t);
        }
        await this.Save(tickets);
        System.Console.WriteLine("Repository End...");
    });

    private async Task Save(IEnumerable<Ticket> tickets)
    {
        var serializerSettings = new JsonSerializerSettings();
        serializerSettings.ContractResolver = new CamelCasePropertyNamesContractResolver();
        var data = JsonConvert.SerializeObject(tickets, serializerSettings);
        var content = new StringContent(data);
        content.Headers.ContentType = MediaTypeHeaderValue.Parse("application/x-www-form-urlencoded");

        // todo: why it is not working with AWS gateway base url and resource in postasync()
        await this.Client.PostAsync("", content);
    }

    public async Task ClearAll()
    {
        await this.Client.DeleteAsync("");
    }

    private HttpClient Client
    {
        get { return this.clientFactory.CreateClient("ticketing-api"); }
    }
}
