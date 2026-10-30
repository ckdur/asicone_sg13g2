#!/usr/bin/env python3
"""Converts report.tex into Markdown chapters readable on GitHub/GitLab.

Writes README.md (title, abstract, contents, summary, references) and one file per section
(NN-name.md), PNG copies of the PDF figures (fig/*.png), with the numbers of figures, tables and
sections taken from the LaTeX build (build/report.aux, so build the PDF first: `make`).
Needs pandoc and pdftoppm. Usage: python3 make_md.py
"""
import re
import subprocess
from pathlib import Path

HERE = Path(__file__).resolve().parent
TEX = HERE / "report.tex"
AUX = HERE / "build" / "report.aux"

# Mermaid version of the TikZ signal chain of the bench (TikZ does not survive pandoc)
BENCH_MERMAID = """```mermaid
flowchart LR
  dds["MSO20<br/>DDS + CH1"] -- "v_in" --> fe
  subgraph board["Adapter board"]
    fe["Front end<br/>(SE to diff.)"] -- "VIP/VIN" --> chip["ASICONE<br/>ADC, ROs, SPI"]
    ldo["LDOs 3.3/1.2 V<br/>refs, jumpers"] --> chip
  end
  chip <-- "J1: ADC, SPI, RO" --> fpga["ULX3S<br/>RISCVConsole<br/>ADCFIFO, SPI, rocounter, PLL"]
  fpga -- "5 V" --> ldo
  host["Host PC<br/>VmMsoOpenSDK, OpenOCD, Python"] <-- USB --> dds
  host <-- "JTAG, UART" --> fpga
```"""


def run(cmd, **kw):
    return subprocess.run(cmd, check=True, capture_output=True, text=True, **kw).stdout


def labels():
    """label -> number, from the LaTeX aux file."""
    out = {}
    for m in re.finditer(r"\\newlabel\{([^}]+)\}\{\{([^}]*)\}", AUX.read_text()):
        out[m.group(1)] = m.group(2)
    return out


def number_captions(tex):
    """Prefix 'Figure N:' / 'Table N:' to the captions of floats (not of subfigures)."""
    counts = {"figure": 0, "table": 0}
    out, pos, env, outer = [], 0, None, None
    for m in re.finditer(r"\\begin\{(figure|table|subfigure)\}|\\caption\{", tex):
        out.append(tex[pos:m.end()])
        pos = m.end()
        if m.group(1) in ("figure", "table"):
            env = outer = m.group(1)
        elif m.group(1) == "subfigure":
            env = "subfigure"
        elif m.group(0).startswith("\\caption"):
            if env in counts:
                counts[env] += 1
                out.append(f"{env.capitalize()} {counts[env]}: ")
                env = outer = None
            else:
                env = outer  # caption of a subfigure: the float caption comes next
    out.append(tex[pos:])
    return "".join(out)


def ranges(tex):
    """Ranges as "a to b": "-0.80-0.67" is ambiguous in plain text."""
    tex = re.sub(r"\\numrange\{([^}]*)\}\{([^}]*)\}", r"\\num{\1} to \\num{\2}", tex)
    return re.sub(r"\\SIrange\{([^}]*)\}\{([^}]*)\}\{([^}]*)\}", r"\\SI{\1}{\3} to \\SI{\2}{\3}", tex)


def preprocess(tex, bib):
    body = tex[tex.index("\\begin{document}"):]
    body = re.sub(r"\\begin\{abstract\}.*?\\end\{abstract\}", "", body, flags=re.S)
    body = re.sub(r"\\tableofcontents|\\maketitle|\\newpage", "", body)
    body = re.sub(r"\\begin\{tikzpicture\}.*?\\end\{tikzpicture\}", "MERMAIDBENCH", body, flags=re.S)
    body = re.sub(r"\\begin\{thebibliography\}.*?\\end\{thebibliography\}", "", body, flags=re.S)
    body = re.sub(r"\\cite\{([^}]+)\}",
                  lambda m: ",".join(f"CITE{bib.index(k) + 1}CITE" for k in m.group(1).split(",")), body)
    body = ranges(body)
    body = number_captions(body)
    return tex[:tex.index("\\begin{document}")] + body


SI_UNITS = {r"\micro m": "µm", r"\ohm": "Ω", r"\percent": "%", r"\celsius": "°C"}


def si(m):
    unit = m.group(2)
    for k, v in SI_UNITS.items():
        unit = unit.replace(k, v)
    return f"{m.group(1)}\\,\\mathrm{{{unit}}}"


def fix_math(md):
    def one(m):
        x = m.group(1)
        x = re.sub(r"\\SI\{([^}]*)\}\{([^}]*)\}", si, x)
        simple = (x.replace(r"\times", "×").replace(r"\to", "→").replace(r"\div ", "÷")
                  .replace(r"\pm ", "±").strip())
        if re.fullmatch(r"[0-9.+\-−× →÷±]+", simple) or simple in ("×", "→"):
            return simple.replace("-", "−")
        return f"$`{x}`$"
    return re.sub(r"\$`([^`]*)`\$", one, md)


def slug(heading):
    s = heading.strip().lower()
    s = re.sub(r"[^\w\- ]", "", s)
    return s.replace(" ", "-")


def main():
    tex = TEX.read_text()
    lab = labels()
    bib = re.findall(r"\\bibitem\{([^}]+)\}", tex)
    bibtext = re.findall(r"\\bibitem\{[^}]+\}(.*?)(?=\\bibitem|\\end\{thebibliography\})", tex, re.S)

    md = run(["pandoc", "-f", "latex", "-t", "gfm", "--wrap=none"], input=preprocess(tex, bib), cwd=HERE)
    md = fix_math(md)
    md = md.replace("`‘default_nettype none`", "`` `default_nettype none ``")
    md = re.sub(r"<figure>\s*<p>MERMAIDBENCH</p>\s*<figcaption>(.*?)</figcaption>\s*</figure>",
                lambda m: BENCH_MERMAID + "\n\n*" + m.group(1) + "*", md, flags=re.S)
    md = md.replace("MERMAIDBENCH", BENCH_MERMAID)

    # Figures: PDFs as PNG, sizes as widths
    for pdf in sorted(HERE / f for f in set(re.findall(r'<embed src="([^"]+\.pdf)"', md))):
        png = pdf.with_suffix(".png")
        if not png.exists() or png.stat().st_mtime < pdf.stat().st_mtime:
            run(["pdftoppm", "-png", "-r", "600" if pdf.stem == "qfn48_bonding" else "150",
                 "-singlefile", str(pdf), str(pdf.with_suffix(""))])
    md = re.sub(r'<embed src="([^"]+)\.pdf" style="width:([\d.]+)%" />',
                lambda m: f'<img src="{m.group(1)}.png" width="{float(m.group(2)):.0f}%" />', md)
    md = re.sub(r'<img src="([^"]+)" style="width:([\d.]+)%" />',
                lambda m: f'<img src="{m.group(1)}" width="{float(m.group(2)):.0f}%" />', md)
    md = md.replace('<img src="fig/layout_capture.png" />', '<img src="fig/layout_capture.png" width="400" />')
    md = md.replace('<img src="fig/die_photo.jpg" />', '<img src="fig/die_photo.jpg" width="400" />')

    # Captions that pandoc leaves as plain paragraphs (tables): italic
    md = re.sub(r"^((?:Table|Figure) \d+: .*)$", r"*\1*", md, flags=re.M)

    # Number the headings as in the PDF, split into files
    parts, cur, acks = [], None, None
    sec = sub = 0
    for line in md.splitlines():
        m = re.match(r"^(#{1,3}) (.*)$", line)
        if m and len(m.group(1)) == 1 and m.group(2) not in ("Acknowledgements",):
            sec += 1
            sub = 0
            title = f"{sec} {m.group(2)}"
            cur = {"title": title, "lines": [f"# {title}"], "subs": []}
            parts.append(cur)
            continue
        if m and len(m.group(1)) == 2 and cur:
            sub += 1
            title = f"{sec}.{sub} {m.group(2)}"
            cur["subs"].append(title)
            cur["lines"].append(f"## {title}")
            continue
        if m and m.group(2) == "Acknowledgements":
            cur = {"title": "Acknowledgements", "lines": [], "subs": []}
            acks = cur
            continue
        if cur is None:
            continue
        cur["lines"].append(line)

    files = {}
    for p in parts:
        if p["title"] == "Acknowledgements" or p["title"].startswith("1 "):
            p["file"] = "README.md"
        else:
            n, name = p["title"].split(" ", 1)
            p["file"] = f"{int(n):02d}-{slug(name)}.md"
        files.setdefault(p["file"], []).append(p)

    # Where each section number lives, for the cross-references
    where = {}
    for p in parts:
        where[p["title"].split(" ")[0]] = (p["file"], slug(p["title"]))
        for s in p["subs"]:
            where[s.split(" ")[0]] = (p["file"], slug(s))

    def anchor(label, num):
        if label.startswith("sec:"):
            f, a = where.get(num, ("README.md", ""))
            return f, a, num
        return None, None, num

    def fix_refs(text, fname):
        def rep(m):
            label, num = m.group(1), lab.get(m.group(1), m.group(2))
            f, a, txt = anchor(label, num)
            if f is None:
                return txt
            return f"[{txt}]({'' if f == fname else f}#{a})"
        text = re.sub(r'<a href="#([^"]+)" data-reference-type="ref" data-reference="[^"]+">([^<]*)</a>', rep, text)
        text = re.sub(r'<(figure|div) id="[^"]+">', r"<\1>", text)
        text = re.sub(r"\s*CITE(\d+)CITE", r" [[\1]](README.md#references)", text)
        if fname == "README.md":
            text = text.replace("](README.md#", "](#")
        return text

    order = sorted(files, key=lambda f: (f != "README.md", f))
    nav = lambda i: ("[Contents](README.md)"
                     + (f" · Previous: [{files[order[i-1]][0]['title']}]({order[i-1]})" if i > 1 else "")
                     + (f" · Next: [{files[order[i+1]][0]['title']}]({order[i+1]})" if i + 1 < len(order) else ""))

    # README: title, abstract, contents, section 1, references
    abstract = re.search(r"\\begin\{abstract\}(.*?)\\end\{abstract\}", tex, re.S).group(1)
    abstract = fix_math(run(["pandoc", "-f", "latex", "-t", "gfm", "--wrap=none"], input=ranges(abstract)))
    toc = []
    for f in order:
        for p in files[f]:
            if p["title"] == "Acknowledgements":
                continue
            toc.append(f"- [{p['title']}]({'' if f == 'README.md' else f}#{slug(p['title'])})")
            toc += [f"  - [{s}]({'' if f == 'README.md' else f}#{slug(s)})" for s in p["subs"]]
    refs = []
    for i, b in enumerate(bibtext, 1):
        b = run(["pandoc", "-f", "latex", "-t", "gfm", "--wrap=none"], input=b.strip()).strip()
        refs.append(f"{i}. {b}")

    header = ("<!-- Generated from report.tex by make_md.py; edit the LaTeX and re-run. -->\n\n")
    for i, f in enumerate(order):
        body = "\n".join("\n".join(p["lines"]) for p in files[f])
        body = fix_refs(body, f)
        body = re.sub(r"\n{3,}", "\n\n", body).strip()
        if f == "README.md":
            text = (header
                    + "# ASICONE (`asicone_202508`)\n\n"
                    + "**IHP SG13G2 OpenMPW September 2025 (T594): design, tapeout and silicon evaluation**\n\n"
                    + "Ckristian Duran, Symbiotic EDA / The University of Tokyo. October 2026.\n\n"
                    + "PDF version: [report.pdf](report.pdf) (build with `make`).\n\n"
                    + "## Abstract\n\n" + abstract.strip() + "\n\n"
                    + "## Contents\n\n" + "\n".join(toc) + "\n\n"
                    + body + "\n\n## References\n\n" + "\n".join(refs) + "\n\n## Acknowledgements\n\n"
                    + "\n".join(acks["lines"]).strip() + "\n")
        else:
            text = header + nav(i) + "\n\n" + body + "\n\n---\n\n" + nav(i) + "\n"
        (HERE / f).write_text(text)
        print("wrote", f)


if __name__ == "__main__":
    main()
