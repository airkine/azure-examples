locals {
  waf_block_html = <<-HTML
  <!doctype html>
  <html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Blocked by Azure Front Door WAF</title>
    <style>
      :root { --bg: #fff3cd; --fg: #1f2937; --accent: #ef4444; }
      html, body { height: 100%; margin: 0; }
      body { display: grid; place-items: center; background: var(--bg); color: var(--fg); font-family: system-ui, -apple-system, Segoe UI, Roboto, sans-serif; }
      .card { background: white; border-radius: 16px; padding: 28px 32px; box-shadow: 0 10px 30px rgba(0,0,0,.08); max-width: 720px; border: 3px dashed var(--accent); }
      h1 { margin: 0 0 10px; font-size: 1.6rem; }
      p { margin: 0.25rem 0; line-height: 1.5; }
      .emoji { font-size: 2rem; margin-right: .5rem; }
      code { background: #f3f4f6; padding: .15rem .35rem; border-radius: 6px; }
      .footer { margin-top: 12px; font-size: .9rem; color: #6b7280; }
    </style>
  </head>
  <body>
    <main class="card" role="main" aria-label="Request blocked">
      <h1><span class="emoji">🧱</span> Nice try! Your request was blocked.</h1>
      <p>Azure Front Door's Web Application Firewall is feeling protective today.</p>
      <p>If you think this is a mistake, please contact the site owner and include the time and what you were doing.</p>
      <p class="footer">HTTP <code>403</code> • Served by Azure Front Door WAF</p>
    </main>
  </body>
  </html>
  HTML
}
