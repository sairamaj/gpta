using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using Microsoft.Identity.Client;
using Microsoft.Graph;
using Microsoft.Extensions.Configuration;
using GraphLib;

namespace ConsoleGraphTest
{
    class Program
    {
        static void Main(string[] args)
        {
            var config = Util.LoadAppSettings();
            if (null == config)
            {
                Console.WriteLine("Missing or invalid appsettings.json file. Please see README.md for configuration instructions.");
                return;
            }

            //Query using Graph SDK (preferred when possible)
            GraphServiceClient graphClient = Util.GetAuthenticatedGraphClient(config);
            List<QueryOption> options = new List<QueryOption>{
                new QueryOption("$top", "2")
            };

            var graphResult = graphClient.Users.Request(options).GetAsync().Result;
            Console.WriteLine("Graph SDK Result");
            foreach (var g in graphResult)
            {
                Console.WriteLine(g.DisplayName);
            }
            //Console.WriteLine("Mail nick name:" + graphResult[0].DisplayName);
            //Console.WriteLine("Member of:" + graphResult[0].MemberOf);
            //return;
            var alias = args[0];
            var groups = new PermissionHelper(graphClient).UserMemberOf(alias).Result;
            Console.WriteLine($"group count: {groups.Count}");
            foreach (var group in groups)
            {
                System.Console.WriteLine($"group: {group.Display}");
            }
            //Direct query using HTTPClient (for beta endpoint calls or not available in Graph SDK)
            // HttpClient httpClient = GetAuthenticatedHTTPClient(config);
            // Uri Uri = new Uri("https://graph.microsoft.com/v1.0/users?$top=1");
            // var httpResult = httpClient.GetStringAsync(Uri).Result;

            // Console.WriteLine("HTTP Result");
            // Console.WriteLine(httpResult);
        }
    }
}
