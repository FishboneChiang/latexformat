import std/strutils

proc isEscaped(s: string, pos: int): bool =
  var spos = pos - 1
  while spos >= 0 and s[spos] == '\\': spos -= 1
  return ((pos-spos) mod 2 == 0)

proc left_right_pairs(line: string): (int, int) =
  var left: int = 0
  var right: int = 0
  for i in 0..<(line.len):
    if line[i] == '{' or line[i] == '[':
      if i > 0 and isEscaped(line, i): continue
      left += 1
    if line[i] == '}' or line[i] == ']':
      if i > 0 and isEscaped(line, i): continue
      right += 1
  return (left, right)

when isMainModule:
  let indent = "\t"
  var level = 0

  for line in lines(stdin):
    let raw_content = strip(line, chars = {'\t', ' '})
    if raw_content.len > 0 and raw_content[0] == '%': echo line; continue
    if raw_content.len == 0: echo ""; continue
    var cpos = 0
    while 0 <= cpos and cpos < raw_content.len:
      cpos = raw_content.find("%", cpos)
      if cpos > 0 and isEscaped(raw_content, cpos): cpos += 1
      else: break
    if cpos >= raw_content.len: cpos = -1
    let content = if cpos == -1: raw_content else: raw_content[0..<cpos]
    let comment = if cpos == -1: "" else: raw_content[cpos..^1]

    if content.contains(r"\begin{document}") or content.contains(r"\end{document}"):
      echo content, comment; continue
    var (l, r) = left_right_pairs(content)
    var pos = 0
    while true:
      pos = content.find('\\', pos)
      if pos == -1: break
      if pos+6 < content.len and content.toOpenArray(pos+1, pos+6) == r"begin{":
        l += 1
      elif pos+4 < content.len and content.toOpenArray(pos+1, pos+4) == r"end{":
        r += 1
      pos.inc

    let net = l - r
    if net < 0:
      level += net
      if level < 0: level = 0
      echo indent.repeat(level), content, comment
    else:
      echo indent.repeat(level), content, comment
      level += net
