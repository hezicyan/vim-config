local ls = require("luasnip")

local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local l = require("luasnip.extras").lambda
local r = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local types = require("luasnip.util.types")

ls.snippets = {
  cpp = {
    s('read', {
      c(1, {
        t('int'),
        t('unsigned int'),
        t('long long'),
        t('unsigned long long'),
        i(),
      }),
      t({ ' Read() {', '\t' }),
      r(1),
      t({
        ' res = 0;',
        '\tchar ch;',
        '\twhile (!isdigit(ch = getchar())) continue;',
        '\tdo {',
        "\t\tres = res * 10 + ch - '0';",
        '\t} while (isdigit(ch = getchar()));',
        '\treturn res;',
        '}',
      }),
      i(0),
    }),

    s('readf', {
      t({
        'char ReadChar() {',
        '\tstatic const int kBufSize = 1000000;',
        '\tstatic char inbuf[kBufSize + 10];',
        '\tstatic char* now = inbuf;',
        '\tstatic char* lim = inbuf;',
        '\tif (now == lim) {',
        '\t\tlim = fread(inbuf, sizeof(char), kBufSize, stdin) + inbuf;',
        '\t\tnow = inbuf;',
        '\t}',
        '\treturn now == lim ? EOF : *(now++);',
        '}',
        '',
        '',
      }),
      c(1, {
        t('int'),
        t('unsigned int'),
        t('long long'),
        t('unsigned long long'),
        i(),
      }),
      t({ ' Read() {', '\t' }),
      r(1),
      t({
        ' res = 0;',
        '\tchar ch;',
        '\twhile (!isdigit(ch = ReadChar())) continue;',
        '\tdo {',
        "\t\tres = res * 10 + ch - '0';",
        '\t} while (isdigit(ch = ReadChar()));',
        '\treturn res;',
        '}',
      }),
      i(0),
    }),

    s('readneg', {
      c(1, {
        t('int'),
        t('long long'),
        i(),
      }),
      t({ ' Read() {', '\t' }),
      r(1),
      t({
        ' res = 0;',
        '\tbool neg = false;',
        '\tchar ch;',
        "\twhile (!isdigit(ch = getchar())) neg |= ch == '-';",
        '\tdo {',
        "\t\tres = res * 10 + ch - '0';",
        '\t} while (isdigit(ch = getchar()));',
        '\treturn neg ? -res : res;',
        '}',
      }),
      i(0),
    }),

    s('readnegf', {
      t({
        'char ReadChar() {',
        '\tstatic const int kBufSize = 1000000;',
        '\tstatic char inbuf[kBufSize + 10];',
        '\tstatic char* now = inbuf;',
        '\tstatic char* lim = inbuf;',
        '\tif (now == lim) {',
        '\t\tlim = fread(inbuf, sizeof(char), kBufSize, stdin) + inbuf;',
        '\t\tnow = inbuf;',
        '\t}',
        '\treturn now == lim ? EOF : *(now++);',
        '}',
        '',
        '',
      }),
      c(1, {
        t('int'),
        t('long long'),
        i(),
      }),
      t({ ' Read() {', '\t' }),
      r(1),
      t({
        ' res = 0;',
        '\tbool neg = false;',
        '\tchar ch;',
        "\twhile (!isdigit(ch = ReadChar())) neg |= ch == '-';",
        '\tdo {',
        "\t\tres = res * 10 + ch - '0';",
        '\t} while (isdigit(ch = ReadChar()));',
        '\treturn neg ? -res : res;',
        '}',
      }),
      i(0),
    }),

    s('main', {
      t({
        'int main() {',
        '\t'
      }),
      i(0, '// Code here...'),
      t({
        '',
        '\treturn 0;',
        '}'
      }),
    }),

    s('freopen', {
      t('freopen("'),
      f(function(_, snip)
        return snip.env.TM_FILENAME_BASE
      end, {}),
      t({
        '.in", "r", stdin);',
        'freopen("',
      }),
      f(function(_, snip)
        return snip.env.TM_FILENAME_BASE
      end, {}),
      t({
        '.out", "w", stdout);',
        '',
      }),
    }),
  },
}
