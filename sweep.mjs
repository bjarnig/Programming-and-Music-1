// Overflow / accent / figure sweep over a built Slidev deck served locally.
// Usage: node sweep.mjs <baseUrl> <slideCount>
import { chromium } from 'playwright-chromium'

const base = process.argv[2]
const n = parseInt(process.argv[3], 10)

const browser = await chromium.launch()
const page = await browser.newPage({ viewport: { width: 1280, height: 720 } })

let problems = 0
let accentSlides = []

for (let i = 1; i <= n; i++) {
  await page.goto(`${base}/${i}`, { waitUntil: 'networkidle' })
  await page.waitForTimeout(120)

  const r = await page.evaluate(() => {
    // Slidev keeps neighbouring slides mounted, and they collapse to zero width.
    // The active one is the widest, so pick that rather than the first in the DOM.
    const slide = [...document.querySelectorAll('.slidev-layout')]
      .sort((a, b) => b.getBoundingClientRect().width - a.getBoundingClientRect().width)[0]
    if (!slide || slide.getBoundingClientRect().width < 100) return { missing: true }
    const sb = slide.getBoundingClientRect()
    const out = []

    // anything whose painted box escapes the slide
    for (const el of slide.querySelectorAll('*')) {
      if (!el.getClientRects().length) continue
      const b = el.getBoundingClientRect()
      if (b.width === 0 || b.height === 0) continue
      const over = Math.max(b.bottom - sb.bottom, sb.top - b.top,
                            b.right - sb.right, sb.left - b.left)
      if (over > 2) {
        out.push({ tag: el.tagName.toLowerCase(),
                   cls: (el.className && el.className.baseVal !== undefined
                         ? el.className.baseVal : el.className || '').toString().slice(0, 40),
                   over: Math.round(over) })
      }
    }

    // the blue accent must stay scarce
    const accent = slide.querySelectorAll('.q, .workshop').length

    // an image must not sit on top of text
    const imgs = [...slide.querySelectorAll('img')].map(e => e.getBoundingClientRect())
    const texts = [...slide.querySelectorAll('p, li, h1, blockquote, pre')]
      .filter(e => e.textContent.trim())
      .map(e => e.getBoundingClientRect())
    let collide = 0
    for (const a of imgs) for (const b of texts) {
      if (a.left < b.right && a.right > b.left && a.top < b.bottom && a.bottom > b.top) collide++
    }

    const broken = [...slide.querySelectorAll('img')]
      .filter(e => e.complete && e.naturalWidth === 0).map(e => e.getAttribute('src'))

    // keep only the outermost offender per slide, children repeat the parent's overflow
    const worst = out.sort((x, y) => y.over - x.over).slice(0, 2)
    return { worst, accent, collide, broken }
  })

  if (r.missing) { console.log(`  ${i}: no slide layout found`); problems++; continue }
  if (r.worst.length) {
    console.log(`  ${i}: OVERFLOW ${r.worst.map(w => `${w.tag}.${w.cls} by ${w.over}px`).join(', ')}`)
    problems++
  }
  if (r.collide) { console.log(`  ${i}: figure overlaps text (${r.collide})`); problems++ }
  if (r.broken.length) { console.log(`  ${i}: broken image ${r.broken.join(', ')}`); problems++ }
  if (r.accent) accentSlides.push(i)
}

console.log(`accent (.q/.workshop) on ${accentSlides.length}/${n} slides: ${accentSlides.join(', ')}`)
console.log(problems === 0 ? 'SWEEP CLEAN' : `SWEEP: ${problems} problem(s)`)
await browser.close()
