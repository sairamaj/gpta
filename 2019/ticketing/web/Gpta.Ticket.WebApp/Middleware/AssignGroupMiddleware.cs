using System;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using GraphLib;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;

namespace Gpta.Ticket.WebApp.Middleware
{
    class AssignGroupMiddleware
    {
        private readonly RequestDelegate _next;
        ILogger _logger;

        public AssignGroupMiddleware(RequestDelegate next, ILogger<AssignGroupMiddleware> logger)
        {
            _next = next;
            _logger = logger;
        }

        public async Task InvokeAsync(HttpContext context)
        {
            var memberOfClaim = context.User.Claims.FirstOrDefault(c => c.Type == System.Security.Claims.ClaimTypes.Role);
            if (memberOfClaim == null && context.User.Identity.IsAuthenticated)
            {
                var config = Util.LoadAppSettings();
                var graphClient = Util.GetAuthenticatedGraphClient(config);
                var nameClaim = context.User.Claims.FirstOrDefault(c => c.Type == "name");
                if (nameClaim == null)
                {
                    throw new ArgumentException($"name claime not found in claim list.");
                }

                try
                {
                    var groups = new PermissionHelper(graphClient).UserMemberOf(nameClaim.Value).Result;
                    foreach (var group in groups)
                    {
                        ((ClaimsIdentity)context.User.Identity)
                        .AddClaim(new Claim(ClaimTypes.Role, group.Display, ClaimValueTypes.String));
                    }
                }
                catch (AggregateException ae)
                {
                    var actualException = ae.Message;
                    if(ae.InnerExceptions.Any())
                    {
                        actualException = ae.InnerExceptions.First().Message;
                    }
                    _logger.LogError($"Error while getting the groups for user:{nameClaim.Value}. No groups were set, Error:{actualException}");
                }
                catch (Exception e)
                {
                    _logger.LogError($"Error while getting the groups for user:{nameClaim.Value}. No groups were set, Error:{e.Message}");
                }
            }

            // Call the next delegate/middleware in the pipeline
            await _next(context);
        }
    }
}