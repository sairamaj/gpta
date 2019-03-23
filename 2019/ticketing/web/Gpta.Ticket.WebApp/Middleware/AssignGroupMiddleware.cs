using System;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using GraphLib;
using Microsoft.AspNetCore.Http;

namespace Gpta.Ticket.WebApp.Middleware
{
    class AssignGroupMiddleware
    {
        private readonly RequestDelegate _next;

        public AssignGroupMiddleware(RequestDelegate next)
        {
            _next = next;
        }

        public async Task InvokeAsync(HttpContext context)
        {
            System.Console.WriteLine(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
            var memberOfClaim = context.User.Claims.FirstOrDefault(c => c.Type == System.Security.Claims.ClaimTypes.Role);
            if (memberOfClaim == null && context.User.Identity.IsAuthenticated)
            {
                System.Console.WriteLine("*******************");
                System.Console.WriteLine("Missing member type and adding...");

                var config = Util.LoadAppSettings();
                var graphClient = Util.GetAuthenticatedGraphClient(config);
                var nameClaim = context.User.Claims.FirstOrDefault(c => c.Type == "name");
                if (nameClaim == null)
                {
                    throw new ArgumentException($"name claime not found in claim list.");
                }
                var groups = new PermissionHelper(graphClient).UserMemberOf(nameClaim.Value).Result;
                Console.WriteLine($"group count: {groups.Count}");
                foreach (var group in groups)
                {
                    System.Console.WriteLine($"group: {group.Display}");
                    ((ClaimsIdentity)context.User.Identity)
                    .AddClaim(new Claim(ClaimTypes.Role, group.Display, ClaimValueTypes.String));
                }
            }

            Console.WriteLine($"AssignGroupMiddleware.Invoke Before");
            // Call the next delegate/middleware in the pipeline
            await _next(context);
            Console.WriteLine($"AssignGroupMiddleware.Invoke After");
            System.Console.WriteLine(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
        }
    }
}