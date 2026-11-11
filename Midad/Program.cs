
using System;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.HttpOverrides;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Midad.Data;
using Midad.Support;
using Midad.Support.Exceptions;
using Midad.Support.Middleware;
using Midad.Support.Providers;

var builder = WebApplication.CreateBuilder(args);


MidadConfig.Load(builder.Configuration);                                    




builder.Services.AddDbContext<AppDbContext>(o => o.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));
builder.Services.AddScoped<DbSeeder>();


builder.Services.AddDistributedMemoryCache();
builder.Services.AddSession(o =>
{
    o.IdleTimeout = TimeSpan.FromMinutes(builder.Configuration.GetValue("Session:Lifetime", 120));
    o.Cookie.Name = builder.Configuration["Session:Cookie"] ?? "midad_session";
    o.Cookie.HttpOnly = true;
    o.Cookie.IsEssential = true;
});
builder.Services.AddMemoryCache();                                          
builder.Services.AddHttpContextAccessor();


AppServiceProvider.Register(builder.Services);
AuthServiceProvider.Boot(builder.Services);
RouteServiceProvider.Boot(builder.Services);
EventServiceProvider.Boot();



builder.Services.AddLocalization(o => o.ResourcesPath = "Resources");


builder.Services.AddControllersWithViews(o =>
{
    o.Filters.Add(new AutoValidateAntiforgeryTokenAttribute());
    o.ModelBinderProviders.Insert(0, new TrimStringsProvider());
})
.AddViewLocalization()
.AddDataAnnotationsLocalization(o => o.DataAnnotationLocalizerProvider = (_, f) => f.Create(typeof(SharedResource)));

builder.Services.Configure<ForwardedHeadersOptions>(TrustProxies.Configure);
builder.Services.AddCors();
builder.Services.AddAntiforgery(o =>
{
    o.FormFieldName = "_token";                                              
    o.HeaderName = "X-CSRF-TOKEN";                                           
});
builder.Services.Configure<Microsoft.AspNetCore.Http.Features.FormOptions>(o => o.MultipartBodyLengthLimit = 8 * 1024 * 1024); 

var app = builder.Build();

App.RootServices = app.Services;
App.HttpContextAccessor = app.Services.GetRequiredService<IHttpContextAccessor>();


if (!app.Environment.IsDevelopment())
{
    Handler.Register(app);
    app.UseHsts();
}
app.UseStatusCodePages();

app.UseHttpsRedirection();
app.UseStaticFiles();                                                       
app.UseHttpMethodOverride(new HttpMethodOverrideOptions { FormFieldName = "_method" }); 


Midad.Support.Http.Kernel.Pipeline(app);


app.MapControllers();
AppServiceProvider.Boot(app);

app.Run();
