using Gpta.Ticketing.Web.Shared;

public interface IRepository
 {
    Task ClearAll();
    Task<TicketSummary> GetSummary();
    Task<IEnumerable<Ticket>> GetTickets();
    Task<UploadSummary> Upload(Stream stream);  
 }