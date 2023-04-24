# Service Bus Demo

A simple set of example code in dotnet 7.x to show patterns on sending and receiving data on a client with Azure Service Bus.

## Azure Resources Required

In order to build and use this code, the developer will need the following:

This code leverages the [Configuration](https://docs.microsoft.com/en-us/dotnet/api/microsoft.extensions.configuration?view=dotnet-plat-ext-5.0) nuget package and functionality, which in turn looks at the `appsettings.json` (or `secrets.json`) file for different connection strings.  

- **Service Bus Connection String** - Stored as `ServiceBusConnectionString`

## Important

It is **HIGHLY** recommended that developers use the `dotnet user-secrets` command (e.g. `dotnet user-secrets set ServiceBusConnectionString "xxxxxx"`) on local machines to cache the two connection strings listed above instead of adding them to the `appsettings.json`.  This practice helps to prevent accidentally checking confidential information into repos and exposing that information inadvertently to peers or the public.  Please see https://docs.microsoft.com/en-us/aspnet/core/security/app-secrets for more information.

```powershell
dotnet user-secrets init
dotnet user-secrets set ServiceBusConnectionString "xxxxxx"
```
