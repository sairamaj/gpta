using Gpta.Ticketing.Web.Shared;

public interface IRepository
 {
    Task<TicketSummary> GetSummary();
 }