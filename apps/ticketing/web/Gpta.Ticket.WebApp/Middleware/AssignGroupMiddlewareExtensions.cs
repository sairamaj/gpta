using Microsoft.AspNetCore.Builder;

namespace Gpta.Ticket.WebApp.Middleware
{
    public static class AssignGroupMiddlewareExtensions
    {
        public static IApplicationBuilder UseAssignGroup(
            this IApplicationBuilder builder)
        {
            return builder.UseMiddleware<AssignGroupMiddleware>();
        }
    }
}