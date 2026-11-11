



(function () {
  var body = document.body;
  function setOpen(open) {
    body.classList.toggle('md-nav-open', open);
    document.querySelectorAll('[data-md-toggle]').forEach(function (b) {
      b.setAttribute('aria-expanded', open ? 'true' : 'false');
    });
  }
  document.addEventListener('click', function (e) {
    if (e.target.closest('[data-md-toggle]')) { setOpen(!body.classList.contains('md-nav-open')); return; }
    if (e.target.closest('.md-backdrop') || e.target.closest('.side a, .hdr .nav a')) setOpen(false);
  });
  document.addEventListener('keydown', function (e) { if (e.key === 'Escape') setOpen(false); });
  window.addEventListener('resize', function () { if (window.innerWidth >= 992) setOpen(false); });
  
  function onScroll() { body.classList.toggle('md-scrolled', window.scrollY > 4); }
  window.addEventListener('scroll', onScroll, { passive: true });
  onScroll();
})();
