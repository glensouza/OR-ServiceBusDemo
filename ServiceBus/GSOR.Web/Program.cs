using Microsoft.AspNetCore.ResponseCompression;
using Microsoft.AspNetCore.SignalR;
using MiniValidation;
using System.Text.Json;
using GSOR.Web.Hubs;
using System.Reflection;
using Azure.Messaging.ServiceBus;

WebApplicationBuilder builder = WebApplication.CreateBuilder(args);


string? serviceBusConnectionString = builder.Configuration.GetValue<string>("ServiceBusConnectionString");
const string queueName = "fromfunction";

// since ServiceBusClient implements IAsyncDisposable we create it with "await using"
await using ServiceBusClient sbClient = new(serviceBusConnectionString);

// create the sender
ServiceBusSender sender = sbClient.CreateSender(queueName);

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddSignalR();
builder.Services.AddResponseCompression(opts =>
{
    opts.MimeTypes = ResponseCompressionDefaults.MimeTypes.Concat(
        new[] { "application/octet-stream" });
});

// Add services to the container.
builder.Services.AddRazorPages();

builder.Services.AddCors(options => options.AddPolicy("ApiCorsPolicy", corsBuilder =>
{
    corsBuilder.WithOrigins(builder.Configuration["ViewerSource"] ?? throw new InvalidOperationException()).AllowAnyMethod().AllowAnyHeader();
}));

WebApplication app = builder.Build();

app.UseResponseCompression();
app.UseCors("ApiCorsPolicy");

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

app.MapSwagger();
app.UseSwaggerUI();

app.MapHub<MessageHub>("/api/messageHub");

app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseRouting();

app.UseAuthorization();

app.MapRazorPages();

app.MapPost("/api/send/{message}", async (string message, IHubContext<MessageHub> context) =>
    {
        await context.Clients.All.SendAsync("NewMessage", message);
    })
    .WithName("SendMessage");

app.MapPost("api/queue/{message}", async (string message, IHubContext<MessageHub> context) =>
    {
        // TODO: Service Bus Queue Message
        Random random = new();
        int randomNumber = random.Next(1, 1000);

        for (int i = 0; i < 3; i++)
        {
            // create a session message that we can send
            ServiceBusMessage sbMessage = new($"{randomNumber} {i}");

            // send the message
            await sender.SendMessageAsync(sbMessage);

            // notify
            await context.Clients.All.SendAsync("NewMessage", $"Sent {queueName} {sbMessage.Body}");
        }
    })
    .WithName("QueueMessage");

app.Run();
