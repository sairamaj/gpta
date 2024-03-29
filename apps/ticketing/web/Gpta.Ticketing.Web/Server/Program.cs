using Microsoft.AspNetCore.ResponseCompression;
using Microsoft.Extensions.Options;
var builder = WebApplication.CreateBuilder(args);


// Add services to the container.

builder.Services.AddControllersWithViews();
builder.Services.AddRazorPages();
builder.Services.AddTransient(sp => sp.GetRequiredService<IHttpClientFactory>().CreateClient("Ticketing.ServerAPI"));
builder.Services.AddSingleton<IRepository, Repository>();
//builder.Services.AddSingleton<IRepository, LocalRepository>();
builder.Services.AddHttpClient("ticketing-api", c =>
{
    Console.WriteLine($"Reading api options...");
    var apiOptions = builder.Services.BuildServiceProvider().GetService<IOptions<ApiOptions>>().Value;
    Console.WriteLine($"Api Options:{apiOptions.BaseUrl}");
    c.BaseAddress = new System.Uri(apiOptions.BaseUrl);
    c.DefaultRequestHeaders.Add("x-api-key", apiOptions.ApiKey);
});
builder.Services.Configure<ApiOptions>(op => { builder.Configuration.Bind("ApiSettings", op); });
var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseWebAssemblyDebugging();
}
else
{
    app.UseExceptionHandler("/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

app.UseHttpsRedirection();

app.UseBlazorFrameworkFiles();
app.UseStaticFiles();

app.UseRouting();


app.MapRazorPages();
app.MapControllers();
app.MapFallbackToFile("index.html");

app.Run();
