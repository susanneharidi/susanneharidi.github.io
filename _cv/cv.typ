// Layout of the PDF CV (files/Susanne_Haridi_CV.pdf), built by _cv/build.lua.
// The entries come from cv.qmd, the publications from publications.yml.
// The header details and the section order are set below.

#import "cv-content.typ": cv-sections

// ----- Header -----

#let name = "Susanne Haridi"
#let position = [Postdoctoral Researcher · Department of Psychology, LMU Munich]
#let contact = (
  link("mailto:susanne.haridi@psy.lmu.de")[susanne.haridi\@psy.lmu.de],
  link("https://susanneharidi.github.io")[susanneharidi.github.io],
  link("https://orcid.org/0000-0002-5738-2236")[ORCID 0000-0002-5738-2236],
  link("https://scholar.google.com/citations?user=D9ujv3IAAAAJ")[Google Scholar],
)
#let interests = [Computational models of cognition, long-term memory retrieval, scaling of cognitive effort, benchmarks for cognitive science.]

// ----- Section order -----

// Headings of the sections in cv.qmd, in the order they appear in the PDF.
// "publications" marks where the publication sections go. Sections of
// cv.qmd that are not listed here are added at the end.
#let order = (
  "Positions",
  "Education",
  "Fellowships",
  "publications",
  "Teaching & mentoring",
  "Service",
  "Earlier research experience",
  "Summer schools",
  "Skills",
)

// Publication sections: heading and "type" in publications.yml.
#let publication-sections = (
  ("Journal articles", "journal"),
  ("Preprints", "preprint"),
  ("Talks & organized sessions", "talk"),
  ("Posters", "poster"),
)

// Author name shown in bold, and the length above which author lists are shortened
// (the same rules as on the website, see _templates/publications.ejs).
#let is-me(author) = author.starts-with("Haridi,")
#let max-authors = 10

// ----- Style -----

#let accent = rgb("#1d6b73")
#let muted = luma(95)

#set document(title: name + " – Curriculum Vitae", author: name)
#set text(font: "Libertinus Serif", size: 10.5pt, lang: "en")
#set par(leading: 0.55em, spacing: 0.5em)
#show link: set text(fill: accent)
#set page(
  paper: "a4",
  margin: (x: 2cm, top: 1.8cm, bottom: 2cm),
  footer: context {
    set text(size: 8.5pt, fill: muted)
    grid(
      columns: (1fr, auto, 1fr),
      align: (left, center, right),
      [#name · Curriculum Vitae],
      [Last updated #datetime.today().display("[month repr:long] [year]")],
      counter(page).display("1 / 1", both: true),
    )
  },
)

#let section(title) = block(above: 1.2em, below: 0.6em, sticky: true)[
  #text(size: 12.5pt, fill: accent, tracking: 0.03em, smallcaps(title))
  #v(-0.35em)
  #line(length: 100%, stroke: 0.5pt + accent)
]

#let entry(date, body) = block(
  below: 0.7em,
  grid(
    columns: (3.4cm, 1fr),
    column-gutter: 0.4cm,
    text(fill: muted, date),
    body,
  ),
)

// ----- Publications -----

#let format-author(author) = {
  let equal = author.ends-with("*")
  let base = if equal { author.slice(0, -1).trim() } else { author }
  let shown = if is-me(base) { strong(base) } else { base }
  if equal { shown + super(typographic: false, "*") } else { shown }
}

#let format-authors(authors) = {
  let names = authors.split(";").map(n => n.trim()).filter(n => n != "")
  if names.len() > max-authors {
    let keep = (0, 1, names.len() - 1)
    let mine = names.position(is-me)
    if mine != none and mine not in keep { keep.push(mine) }
    let parts = ()
    let previous = -1
    for i in keep.sorted() {
      if previous >= 0 { parts.push(if i - previous > 1 { ", … " } else { ", " }) }
      parts.push(format-author(names.at(i)))
      previous = i
    }
    parts.join() + [ (#names.len() authors). ]
  } else {
    let shown = names.map(format-author)
    let list = if shown.len() <= 2 { shown.join(" & ") } else { shown.slice(0, -1).join(", ") + ", & " + shown.last() }
    // Author lists usually end in an initial ("Schulz, E."), which already has a period.
    list + if names.last().ends-with(".") { " " } else { ". " }
  }
}

#let short-url(url) = url.replace(regex("^https?://(www\.)?"), "")

#let publication-link(item) = {
  if "doi" in item {
    link("https://doi.org/" + item.doi)[doi:#item.doi]
  } else if item.at("venue", default: "") == "arXiv" and "details" in item {
    link("https://arxiv.org/abs/" + item.details)[arXiv:#item.details]
  } else if "preprint" in item {
    link(item.preprint, short-url(item.preprint))
  } else if "abstract" in item {
    [Abstract: #link(item.abstract, short-url(item.abstract))]
  }
}

#let publication(item) = {
  let title = item.title
  if "kind" in item {
    text(size: 8.5pt, fill: accent, tracking: 0.04em, upper(item.kind))
    h(0.4em)
  }
  format-authors(item.authors)
  [#title#if not title.ends-with(regex("[.?!]")) [.] ]
  emph(item.venue)
  if "details" in item [, #item.details]
  [. ]
  publication-link(item)
  if "note" in item {
    linebreak()
    text(size: 9.5pt, fill: muted, item.note)
  }
}

#let publications = yaml("/publications.yml")

#let publication-list() = {
  let first = true
  for (title, type) in publication-sections {
    let items = publications.filter(p => p.type == type).sorted(key: p => p.date).rev()
    if items.len() > 0 {
      section(title)
      if first {
        text(size: 9.5pt, fill: muted)[My name is shown in bold; \* marks equal contribution.]
        v(0.3em)
        first = false
      }
      for item in items {
        entry(item.date.slice(0, 4), publication(item))
      }
    }
  }
}

// ----- Document -----

#text(size: 24pt, fill: accent, name)
#v(-0.4em)
#text(size: 11.5pt, position)
#v(-0.1em)
#text(size: 9.5pt, contact.join([ #h(0.3em)·#h(0.3em) ]))
#v(0.3em)
#text(size: 10pt)[*Research interests:* #interests]

#let by-title = (:)
#for s in cv-sections { by-title.insert(s.title, s) }
#let sections = order + cv-sections.map(s => s.title).filter(t => t not in order)

#for title in sections {
  if title == "publications" {
    publication-list()
  } else if title in by-title {
    section(title)
    for e in by-title.at(title).entries { entry(e.date, e.body) }
  }
}
