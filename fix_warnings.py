from pathlib import Path
import re
import sys

out_file = Path(r"c:\Users\User\AppData\Roaming\Code\User\workspaceStorage\281e77587af491f595faf53efde32244\GitHub.copilot-chat\chat-session-resources\4fda18e4-551a-4064-8573-aa0cadfb8673\call_5MQxVbJ8jvc2KFQnsH1DEv2r__vscode-1778381287937\content.txt")
if not out_file.exists():
    print('Analysis output file not found:', out_file)
    sys.exit(1)
text = out_file.read_text(encoding='utf-8')
issues = []
for line in text.splitlines():
    m = re.search(r'^(warning|info) - (.+?) -\s+(.+?):(\d+):(\d+) - (.+)$', line)
    if m:
        severity, message, path, line_num, col, code = m.groups()
        issues.append((severity, message.strip(), Path(path.replace('\\', '/')), int(line_num), int(col), code.strip()))

for severity, message, fpath, line_num, col, code in issues:
    if not fpath.exists():
        continue
    lines = fpath.read_text(encoding='utf-8').splitlines()
    if code == 'unused_import':
        if 'app_localizations_fallback.dart' in lines[line_num - 1]:
            print('Removing unused import in', fpath)
            lines.pop(line_num - 1)
            fpath.write_text('\n'.join(lines) + '\n', encoding='utf-8')
    elif code in ('unused_field', 'unused_local_variable'):
        if line_num - 1 < len(lines):
            candidate = lines[line_num - 1]
            if any(kw in candidate for kw in ['static const Color', 'final', 'var', 'const']):
                print('Removing unused declaration in', fpath, 'line', line_num, '->', candidate.strip())
                lines.pop(line_num - 1)
                fpath.write_text('\n'.join(lines) + '\n', encoding='utf-8')
    elif code == 'no_leading_underscores_for_local_identifiers' and 'selectedMethod' in message:
        content = fpath.read_text(encoding='utf-8')
        updated = content.replace('_selectedMethod', 'selectedMethod')
        if content != updated:
            print('Renaming _selectedMethod in', fpath)
            fpath.write_text(updated, encoding='utf-8')
    elif code == 'curly_braces_in_flow_control_structures' and 'chat_screen.dart' in str(fpath):
        content = fpath.read_text(encoding='utf-8')
        updated = content.replace('for (final c in _dotControllers)\n      c.dispose();', 'for (final c in _dotControllers) {\n      c.dispose();\n    }')
        if content != updated:
            print('Adding braces to for loop in', fpath)
            fpath.write_text(updated, encoding='utf-8')
    elif code == 'unnecessary_brace_in_string_interps':
        content = fpath.read_text(encoding='utf-8')
        updated = re.sub(r'\$\{([A-Za-z_][A-Za-z0-9_]*)\}', r'$\1', content)
        if content != updated:
            print('Simplifying interpolation in', fpath)
            fpath.write_text(updated, encoding='utf-8')
    elif code == 'use_super_parameters':
        content = fpath.read_text(encoding='utf-8')
        new = re.sub(r'\{Key\? key(,\s*)?', '{super.key\1', content)
        new = new.replace(': super(key: key)', '')
        if content != new:
            print('Updating super parameter in', fpath)
            fpath.write_text(new, encoding='utf-8')
    elif code == 'use_build_context_synchronously':
        content = fpath.read_text(encoding='utf-8').splitlines()
        idx = line_num - 1
        if 0 <= idx < len(content):
            line = content[idx].strip()
            if 'await ' in line:
                guard = '    if (!mounted) return;'
                insert_pos = idx + 1
                if insert_pos < len(content) and guard not in content[insert_pos:insert_pos+4]:
                    print('Inserting mounted guard in', fpath, 'after line', line_num)
                    content.insert(insert_pos, guard)
                    fpath.write_text('\n'.join(content) + '\n', encoding='utf-8')

for fpath in Path('lib/screens').rglob('*.dart'):
    content = fpath.read_text(encoding='utf-8')
    updated = content
    updated = updated.replace('.withOpacity(', '.withValues(alpha: ')
    updated = updated.replace(') :  super(key: key)', ')')
    if updated != content:
        print('Applying withOpacity and super parameter replacements in', fpath)
        fpath.write_text(updated, encoding='utf-8')

# Remove exact unused lines if still present
exact_unused = [
    "final specialties = List<String>.from(counsellor['specialties'] ?? []);",
    "final light  = _medAccents[index % _medAccents.length][1];",
]
for fpath in Path('lib/screens').rglob('*.dart'):
    lines = fpath.read_text(encoding='utf-8').splitlines()
    changed = False
    for ul in exact_unused:
        while ul in lines:
            idx = lines.index(ul)
            name = ul.split()[1]
            if sum(1 for line in lines if name in line) == 1:
                print('Removing exact unused line in', fpath, '->', ul)
                lines.pop(idx)
                changed = True
            else:
                break
    if changed:
        fpath.write_text('\n'.join(lines) + '\n', encoding='utf-8')

print('Batch script completed.')
