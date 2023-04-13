using System.ComponentModel;
using Azure.Messaging.ServiceBus;
using Microsoft.Extensions.Configuration;

// Build a config object, using env vars and JSON providers.
IConfiguration config = new ConfigurationBuilder()
    .AddJsonFile("appsettings.json")
    .AddUserSecrets<Program>()
    .Build();

// Get values from the config given their key and their target type.
string? serviceBusConnectionString = config.GetValue<string>("ServiceBusConnectionString");
const string queueName = "FromConsole";

// since ServiceBusClient implements IAsyncDisposable we create it with "await using"
await using ServiceBusClient client = new(serviceBusConnectionString);

// create the sender
ServiceBusSender sender = client.CreateSender(queueName);

// Create options that you want your menu to have
List<Option> options = new();

options = new List<Option>
{
    new("Send 3 Messages", async () => await SendThreeMessages()),
    new("Receive 1 Message", async () => await ReceiveOneMessage()),
    new("Exit", () => Environment.Exit(0)),
};

// Set the default index of the selected item to be the first
int index = 0;

// Write the menu out
WriteMenu(options[index]);

// Store key info in here
ConsoleKeyInfo keyPressed;
do
{
    keyPressed = Console.ReadKey();

    switch (keyPressed.Key)
    {
        // Handle each key input (down arrow will write the menu again with a different selected item)
        case ConsoleKey.DownArrow:
            if (index + 1 < options.Count)
            {
                index++;
                WriteMenu(options[index]);
            }

            break;
        case ConsoleKey.UpArrow:
            if (index - 1 >= 0)
            {
                index--;
                WriteMenu(options[index]);
            }

            break;
        // Handle different action for the option
        case ConsoleKey.Enter:
            options[index].Selected.Invoke();
            index = 0;
            break;
        default:
            WriteMenu(options.First());
            break;
    }
}
while (keyPressed.Key != ConsoleKey.X);

Console.ReadKey();

async Task SendThreeMessages()
{
    Console.Clear();

    // random number between 1 and 1000
    Random random = new();
    int randomNumber = random.Next(1, 1000);

    for (int i = 0; i < 3; i++)
    {
        // create a session message that we can send
        ServiceBusMessage message = new($"From Console {randomNumber} {i}");

        // send the message
        await sender.SendMessageAsync(message);

        // notify
        await Notify($"Sent {message.Body.ToString()}");
        Console.WriteLine(message.Body.ToString());
    }

    Thread.Sleep(3000);
    WriteMenu(options.First());
}

async Task ReceiveOneMessage()
{
    Console.Clear();

    // create a receiver that we can use to receive the message.
    ServiceBusReceiver? receiver = client.CreateReceiver(queueName);

    // the received message is a different type as it contains some service set properties
    ServiceBusReceivedMessage receivedMessage = await receiver.ReceiveMessageAsync();

    // notify
    await Notify($"Received {receivedMessage?.Body}");
    Console.WriteLine(receivedMessage?.Body?.ToString());

    // complete the message, so that it is not received again.
    await receiver.CompleteMessageAsync(receivedMessage);

    // show message for 3 seconds then go back to main menu
    Thread.Sleep(3000);
    WriteMenu(options.First());
}

void WriteMenu(Option selectedOption)
{
    Console.Clear();

    foreach (Option option in options)
    {
        Console.Write(option == selectedOption ? "> " : " ");

        Console.WriteLine(option.Name);
    }
}

async Task Notify(string message)
{

}

public class Option
{
    public string Name { get; }
    public Action Selected { get; }

    public Option(string name, Action selected)
    {
        Name = name;
        Selected = selected;
    }
}
