+++
title = "Search"
description = "Find content across the site."
+++
<script>
async function go(){
  const r = await fetch('/index.json');
  const data = await r.json();
  const q = new URLSearchParams(location.search).get('q') || '';
  const input = document.getElementById('q');
  const out = document.getElementById('out');
  input.value = q;
  function score(item, q){
    const s = q.toLowerCase();
    let sc = 0;
    if(item.title && item.title.toLowerCase().includes(s)) sc += 5;
    if(item.description && item.description.toLowerCase().includes(s)) sc += 3;
    if(item.content && item.content.toLowerCase().includes(s)) sc += 1;
    return sc;
  }
  function render(list){
    out.innerHTML = list.map(x => `
      <div style="margin:1rem 0">
        <a href="${x.permalink}"><strong>${x.title}</strong></a><br>
        <small>${x.description||''}</small>
      </div>`).join('') || '<p>No results.</p>';
  }
  function run(){
    const s = input.value.trim();
    if(!s){ out.innerHTML = '<p>Type above to search.</p>'; return; }
    const ranked = data.map(d => ({...d, _s: score(d, s)})).filter(d => d._s>0).sort((a,b)=>b._s-a._s).slice(0,50);
    render(ranked);
    const u = new URL(location); u.searchParams.set('q', s); history.replaceState(null,'',u);
  }
  input.addEventListener('input', run);
  run();
}
document.addEventListener('DOMContentLoaded', go);
</script>
<div>
  <input id="q" type="search" placeholder="Search..." style="padding:.6rem 1rem;border-radius:8px;border:1px solid #333;width:100%;max-width:480px">
  <div id="out" style="margin-top:1rem"></div>
</div>
