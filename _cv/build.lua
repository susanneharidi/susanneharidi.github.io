-- Builds files/Susanne_Haridi_CV.pdf before every render (see "pre-render"
-- in _quarto.yml).
--
-- 1. Reads the CV entries from cv.qmd and writes them to _cv/cv-content.typ.
-- 2. Compiles _cv/cv.typ with Typst (included in Quarto). That template adds
--    the publications from publications.yml and sets the layout.

local OUTPUT = "files/Susanne_Haridi_CV.pdf"
-- This section of cv.qmd only links to the Publications page; the PDF lists
-- the publications themselves instead.
local SKIP = { ["Publications"] = true }

local function read_file(path)
  local f = assert(io.open(path, "r"))
  local text = f:read("a")
  f:close()
  return text
end

local function typst(blocks)
  local out = pandoc.write(pandoc.Pandoc(blocks), "typst")
  return (out:gsub("%s+$", ""))
end

local function typst_string(s)
  return '"' .. s:gsub("\\", "\\\\"):gsub('"', '\\"') .. '"'
end

local doc = pandoc.read(read_file("cv.qmd"), "markdown")

local sections = {}
local current = nil
for _, block in ipairs(doc.blocks) do
  if block.t == "Header" and block.level == 2 then
    current = { title = pandoc.utils.stringify(block), entries = {} }
    if not SKIP[current.title] then
      table.insert(sections, current)
    end
  elseif block.t == "Div" and block.classes:includes("cv-entry") and current then
    local date = block.content[1]
    local body = pandoc.List()
    for i = 2, #block.content do
      body:insert(block.content[i])
    end
    if date and date.t == "Para" then
      date = pandoc.Plain(date.content)
    end
    table.insert(current.entries, {
      date = date and typst({ date }) or "",
      body = typst(body),
    })
  end
end

local lines = {
  "// Generated from cv.qmd by _cv/build.lua. Do not edit; edit cv.qmd instead.",
  "#let cv-sections = (",
}
for _, section in ipairs(sections) do
  table.insert(lines, "  (title: " .. typst_string(section.title) .. ", entries: (")
  for _, entry in ipairs(section.entries) do
    table.insert(lines, "    (date: [" .. entry.date .. "], body: [" .. entry.body .. "]),")
  end
  table.insert(lines, "  )),")
end
table.insert(lines, ")")

local f = assert(io.open("_cv/cv-content.typ", "w"))
f:write(table.concat(lines, "\n"), "\n")
f:close()

local bin = os.getenv("QUARTO_BIN_PATH")
local quarto = bin and (bin .. "/quarto") or "quarto"
local ok = os.execute(string.format('"%s" typst compile --root . _cv/cv.typ %s', quarto, OUTPUT))
if not ok then
  error("Could not build " .. OUTPUT .. " (see the Typst error above)")
end
print("Built " .. OUTPUT)
