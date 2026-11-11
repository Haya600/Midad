// Source: bootstrap/app.php, public/index.php, app/Http/Kernel.php, app/Providers/*.php, config/*.php
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

// ── config/*.php ──────────────────────────────────────────────────────────
MidadConfig.Load(builder.Configuration);                                    // config('midad.*')
// TODO(Laravel): config('app.timezone') = Asia/Riyadh sets PHP's default timezone; .NET uses the host's local time
// (DateTime.Now) - run the server in Arab Standard Time or convert with TimeZoneInfo where dates are produced.

// ── config/database.php (sqlsrv) ─────────────────────────────────────────
builder.Services.AddDbContext<AppDbContext>(o => o.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));
builder.Services.AddScoped<DbSeeder>();

// ── config/session.php (StartSession) ────────────────────────────────────
builder.Services.AddDistributedMemoryCache();
builder.Services.AddSession(o =>
{
    o.IdleTimeout = TimeSpan.FromMinutes(builder.Configuration.GetValue("Session:Lifetime", 120));
    o.Cookie.Name = builder.Configuration["Session:Cookie"] ?? "midad_session";
    o.Cookie.HttpOnly = true;
    o.Cookie.IsEssential = true;
});
builder.Services.AddMemoryCache();                                          // RateLimiter facade store (login lock)
builder.Services.AddHttpContextAccessor();

// ── app/Providers ─────────────────────────────────────────────────────────
AppServiceProvider.Register(builder.Services);
AuthServiceProvider.Boot(builder.Services);
RouteServiceProvider.Boot(builder.Services);
EventServiceProvider.Boot();
// BroadcastServiceProvider is not registered (commented out in config/app.php)

// ── localisation: lang/ar.json → Resources/SharedResource.ar.resx ─────────
builder.Services.AddLocalization(o => o.ResourcesPath = "Resources");

// ── MVC: VerifyCsrfToken (global antiforgery), TrimStrings, translated validation messages ──
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
    o.FormFieldName = "_token";                                              // @csrf posts "_token" like Laravel
    o.HeaderName = "X-CSRF-TOKEN";                                           // fetch() calls send the <meta name="csrf-token"> value
});
builder.Services.Configure<Microsoft.AspNetCore.Http.Features.FormOptions>(o => o.MultipartBodyLengthLimit = 8 * 1024 * 1024); // ValidatePostSize (post_max_size 8M)

var app = builder.Build();

App.RootServices = app.Services;
App.HttpContextAccessor = app.Services.GetRequiredService<IHttpContextAccessor>();

// ── app/Exceptions/Handler.php ───────────────────────────────────────────
if (!app.Environment.IsDevelopment())
{
    Handler.Register(app);
    app.UseHsts();
}
app.UseStatusCodePages();

app.UseHttpsRedirection();
app.UseStaticFiles();                                                       // public/* → wwwroot/* (storage:link → wwwroot/storage)
app.UseHttpMethodOverride(new HttpMethodOverrideOptions { FormFieldName = "_method" }); // @method('PUT') / @method('DELETE')

// ── app/Http/Kernel.php: global + 'web' middleware ───────────────────────
Midad.Support.Http.Kernel.Pipeline(app);

// ── routes/web.php, hotel.php, supplier.php, admin.php → attribute routes on the controllers ──
app.MapControllers();
AppServiceProvider.Boot(app);

app.Run();
