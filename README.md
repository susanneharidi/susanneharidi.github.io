# susanneharidi.github.io

Source of my personal academic website, built with [Quarto](https://quarto.org).
Every push to `main` rebuilds the site and publishes it through GitHub Actions
(`.github/workflows/publish.yml`), usually within 2–3 minutes.

## Where things live

| What | File |
|---|---|
| Bio, profile links, contact, selected publications | `index.qmd` |
| All publications, preprints, talks and posters | `publications.yml` |
| CV (including teaching and service) | `cv.qmd` |
| Legal notice and privacy statement | `legal.qmd` |
| Menu, footer, theme | `_quarto.yml` |
| Headshot, favicon, poster PDFs | `files/` |
| Colours (light / dark) | `styles/light.scss`, `styles/dark.scss` |
| Layout of the publication entries | `_templates/publications.ejs`, `styles/site.css` |

## Common edits (all possible in GitHub's web editor)

**Add a paper, preprint, talk or poster:** open `publications.yml`, copy an entry
of the same kind (everything from `- type:` to the next blank line), paste it,
and change the values. The field list at the top of the file explains every
option. Entries are sorted by `date` automatically. Set `selected: true` to show
an entry on the home page as well.

**Add a poster PDF:** upload the PDF to `files/posters/` (on GitHub: open the
folder → *Add file* → *Upload files*) and add `poster: files/posters/<name>.pdf`
to the entry.

**Update the Cognition 2023 preprint link:** once the accepted manuscript is on
PsyArXiv, follow the comment in that entry in `publications.yml`.

**Edit the CV:** each entry in `cv.qmd` is a block between two `:::` lines; the
first line is the date, the rest is the description.

## Preview locally

```bash
quarto preview
```

This opens the site in the browser and reloads it whenever a file changes.

## Visitor statistics (GoatCounter)

Statistics are visible only after logging in at <https://susanneharidi.goatcounter.com>.
The tracking snippet is in `_includes/goatcounter.html`; visits from `localhost`
(the local preview) are not counted.

## Privacy

Never commit private documents. `*.docx` files and the `private/` folder are
excluded in `.gitignore`.

## Credits

- Publication list template and button styles adapted from
  [drganghe/quarto-academic-website-template](https://github.com/drganghe/quarto-academic-website-template)
  (MIT License, © 2025 Gang He; license text in `_templates/publications.ejs`).
- ORCID, Google Scholar and OSF icons from [Simple Icons](https://simpleicons.org) (CC0 1.0);
  all other icons from [Bootstrap Icons](https://icons.getbootstrap.com) (MIT License).
