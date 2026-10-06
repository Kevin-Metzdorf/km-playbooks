#!/usr/bin/env bash
# Prüft die Skills gegen den Agent-Skills-Standard und die Regeln von km-playbooks:
# Frontmatter, Sperrliste werkzeugspezifischer Begriffe, Verweise auf Dateien.
# Nutzung: ./scripts/check-skills.sh [skills-ordner]   (Standard: skills/ dieses Repos)
# Exit 1 bei mindestens einem Befund. Benötigt bash, grep und ruby.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILLS="$(cd "${1:-$ROOT/skills}" && pwd)"
SPERRLISTE="$ROOT/scripts/skills-sperrliste.txt"
BASE="$(dirname "$SKILLS")"
errors=0

# Sperrliste: fester Text, ohne Groß-/Kleinschreibung, in allen Textdateien.
while IFS= read -r term; do
  case "$term" in '' | '#'*) continue ;; esac
  while IFS= read -r hit; do
    echo "$hit: werkzeugspezifischer Begriff '$term'"
    errors=$((errors + 1))
  done < <(cd "$BASE" && { grep -r -n -I -i -F -- "$term" "$(basename "$SKILLS")" || true; } | cut -d: -f1,2)
done < "$SPERRLISTE"

# Frontmatter und Verweise (YAML braucht Ruby).
if ! ruby -E UTF-8:UTF-8 -ryaml - "$SKILLS" "$BASE" <<'RUBY'; then
# encoding: utf-8
skills, base = ARGV
allowed = %w[name description license compatibility metadata allowed-tools]
forbidden = %r{templates/(confluence|AGENTS|CLAUDE|GEMINI|theme|\.github)|docs/(spec-vorlage|kunde|prozess|prompts|ci|agenten)\.md|km-playbooks}
found = 0
report = lambda { |file, line, msg| puts "#{file.sub("#{base}/", "")}:#{line}: #{msg}"; found += 1 }

Dir.glob(File.join(skills, "*")).select { |d| File.directory?(d) }.sort.each do |dir|
  skill = File.join(dir, "SKILL.md")
  unless File.file?(skill)
    report.call(skill, 1, "SKILL.md fehlt")
    next
  end
  text = File.read(skill, encoding: "UTF-8")
  line_of = lambda { |key| (text.lines.index { |l| l.start_with?("#{key}:") } || 0) + 1 }

  fm = text[/\A---\n(.*?)^---[ \t]*$/m, 1]
  if fm.nil?
    report.call(skill, 1, "Frontmatter fehlt (--- am Dateianfang)")
  else
    begin
      y = YAML.safe_load(fm)
    rescue Psych::Exception => e
      report.call(skill, 1, "Frontmatter ist kein gültiges YAML (#{e.message.lines.first.strip})")
      y = :fehler
    end
    if !y.is_a?(Hash)
      report.call(skill, 1, "Frontmatter muss eine Zuordnung mit „name“ und „description“ sein") unless y == :fehler
    else
      folder = File.basename(dir)
      (y.keys - allowed).each { |k| report.call(skill, line_of.call(k), "Feld „#{k}“ gehört nicht zum Agent-Skills-Standard") }
      name = y["name"]
      if !name.is_a?(String) || name.empty?
        report.call(skill, 1, "Pflichtfeld „name“ fehlt")
      else
        report.call(skill, line_of.call("name"), "„name“ (#{name}) muss dem Ordnernamen (#{folder}) entsprechen") if name != folder
        unless name.match?(/\A[a-z0-9]+(-[a-z0-9]+)*\z/) && name.size <= 64
          report.call(skill, line_of.call("name"), "„name“: nur Kleinbuchstaben, Ziffern und einzelne Bindestriche, höchstens 64 Zeichen")
        end
      end
      desc = y["description"]
      if !desc.is_a?(String) || desc.strip.empty?
        report.call(skill, 1, "Pflichtfeld „description“ fehlt")
      elsif desc.size > 1024
        report.call(skill, line_of.call("description"), "„description“ hat #{desc.size} Zeichen, höchstens 1024")
      end
      if y.key?("compatibility") && !(y["compatibility"].is_a?(String) && (1..500).cover?(y["compatibility"].size))
        report.call(skill, line_of.call("compatibility"), "„compatibility“ muss Text mit 1–500 Zeichen sein")
      end
      if y.key?("license") && !(y["license"].is_a?(String) && !y["license"].empty?)
        report.call(skill, line_of.call("license"), "„license“ muss Text sein")
      end
      if y.key?("metadata") && !(y["metadata"].is_a?(Hash) && y["metadata"].all? { |k, v| k.is_a?(String) && v.is_a?(String) })
        report.call(skill, line_of.call("metadata"), "„metadata“ muss eine Zuordnung von Text zu Text sein")
      end
      if y.key?("allowed-tools") && !y["allowed-tools"].is_a?(String)
        report.call(skill, line_of.call("allowed-tools"), "„allowed-tools“ muss Text sein")
      end
    end
  end

  # Verweise in allen Markdown-Dateien des Skills.
  Dir.glob(File.join(dir, "**", "*.md")).sort.each do |md|
    File.read(md, encoding: "UTF-8").each_line.with_index(1) do |l, n|
      l.scan(/\]\(([^)\s#]+)(?:#[^)]*)?\)/).flatten.each do |target|
        next if target.match?(%r{\A([a-z]+:|/|<)}) || target.include?("<")
        report.call(md, n, "Link auf fehlende Datei „#{target}“") unless File.exist?(File.join(File.dirname(md), target))
      end
      l.scan(/`((?:assets|references|scripts)\/[^`\s]+)`/).flatten.each do |path|
        next if path.include?("<")
        report.call(md, n, "Verweis auf fehlende Datei „#{path}“") unless File.exist?(File.join(dir, path))
      end
      l.scan(forbidden) { report.call(md, n, "Verweis auf einen Pfad in km-playbooks („#{Regexp.last_match(0)}“); Dateien gehören in den Skill-Ordner") }
    end
  end
end
exit(found.zero? ? 0 : 1)
RUBY
  errors=$((errors + 1))
fi

if [ "$errors" -gt 0 ]; then
  echo "Skill-Prüfung fehlgeschlagen." >&2
  exit 1
fi
echo "Skill-Prüfung bestanden: $(find "$SKILLS" -mindepth 2 -maxdepth 2 -name SKILL.md | wc -l | tr -d ' ') Skills."
