# latexformat

> A Simple LaTeX formatter written in Nim

While working on a PhD paper with LaTeX source files recently, I noticed that formatting my paper became unbearably slow as the project grew.

This inspired the creation of `latexformat`, a dead‑simple yet fast LaTeX formatter written in fewer than 60 lines of code using the Nim programming language. It does not aim to cover all edge cases and instead prioritizes cache locality and predictability. It reads through the LaTeX source code, line by line, on a single pass and determines the indentation based on keywords such as `{}`, `\begin{...}`, `\end{...}`, and `%`.

While it is far from a full LaTeX parser, it helped me format [my recently published paper](https://arxiv.org/abs/2603.18140) on arXiv and has been tested to handle medium- to large-size JHEP papers with ease. On my personal computer, such files are typically formatted in around 5 ~ 10 ms, while the feature-rich `latexindent` often takes several seconds.

##### Installation 
To compile the source code, simply run
```bash
nim c -d:release latexformat.nim
```
Integrating with [conform.nvim](https://github.com/stevearc/conform.nvim) is easy: please ensure that the compiled executable is in your `PATH`, then add the following lines to your configuration.
```lua
return {
    "stevearc/conform.nvim",
    opts = {
        formatters_by_ft = {
            tex = { "latexformat" },
        },
        formatters = {
            ["latexformat"] = {
                command = "latexformat",
                stdin = true,
            },
        },
    },
}
```

##### Usage: 
```bash
cat file.tex | latexformat > formatted_file.tex
```

##### Future work
Although straightforward to implement, I will leave these to future works:
- Extra arguments to specify the indentation
- Support for special cases such as verbatim environments
- A config file to include a "whitelist" of keywords ignored by the program

Any feedback would be greatly appreciated. Happy TeXing!
