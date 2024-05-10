# Quickstart guidelines

## TODOs
- General
    - [x] zoxide setup 
    - [ ] Override lsp config mapping preoprly
    - [x] cmp mapping C-space and more mapping config behavior <TAB> in comment check nvchad
- Git 
    - [ ] Diff view : https://github.com/sindrets/diffview.nvim?tab=readme-ov-file
- Telescopes 
    - [ ] Improve telescope git files an grep
    - [ ] Lazygit and dotfiles 
        - https://github.com/jesseduffield/lazygit/discussions/1201#discussioncomment-2546527 
-  LSP
    - jsx comment not correct 
    - [x] Omnisharp dotnet setup 



## Configurations



### AI 

#### ChatGPT 

plugin: https://www.youtube.com/watch?v=jrFjtwm-R94&ab_channel=NerdSignals 
- Act as (persona)
- Docs 
- Chat Grammar correct Bug fixes, Explain


#### Copilot 

https://github.com/CopilotC-Nvim/CopilotChat.nvim

## Keyboards

### Views

| Key          | Description                             |
| ----------   | ----------                              |
| <esc>        | toggle fold if exists else no highlight |
| VIM DEFAULTS | ----------                              |
| <C-g>        | Show current file path                  |
 
### Navigations

gx - custom function to go to links or directly to github page plugin link

- for LSP navigations see below LSP map


#### Help Pages
- C-] go to tags - section (highlighted in red) 
- C-t to go back to previous location tag

| Key        | Description                           |
| ---------- | ----------                            |
| zj / k     | Navigate fold (useful in diff split ) |



#### Files 

Nvim Tree 
| Key   | Description               |
| ---   | -----------               |
| <C-n> | Toggle NvimTree           |
| y     | Copy file name (with ext) | 
| ge    | copy base name (no ext)   |


Config file settings / debug

| Key             | Description                  |
| ---             | -----------                  |
| <local>rl | include lua (check test.lua) |

### Editing 


| Key         | Description                          |
| ----------  | ----------                           |
| C-s         | Save                                 |
| <ll> w      | Save                                 |
| Y, YY       | copy to system clipboard             |
| <ll> q      | Quit                                 |
| za/A        | fold toggle cursor / All             |
| zd          | fold delete                          |
| <leader> fm | Format whole file                    |
| <leader> fF | Toggle Format on Save Buff(!)/Global |


`Markdown` - manual enable on md files table mode auto format when type the  
Tables plugin  (manual enabled)

'Notes' : Key works per buffer
| Key         | Description    |
| ----------- | -------------- |
| <leader> tm | Enable         |
| <leader> tc | Delete column  |


### Searching

`Telescope` is main searching tools using <leader>f

| Key            | Description            |
| -------------- | -----------            |
| _ft            | Find Telescope pickers |
| _ff            | Find Files             |
| _fh            | Help Pages             |
| _fb            | Buffers                |


### Git

| Key            | Description            |
| -------------- | -----------            |
| C-A-j/k        | Next Hunk              |
| ]c, [c         | Next Hunk              |
| <leader> gb    | Git Blame              |
| - l            | Blame Line             |
| - c            | Blame commit Telescope |


### LSP

Setup 



1. Install new LSP server
    Add new language manually 
        :MasonInstall will help download the deps 

    Next time when install in other PC add in config to ensure its installed 
        :MasonInstallAll to install all LSP from config 

2. Put the server in LSP-CONFIG loadup
    - search the server name in server
    - :help lspconfig-all

Using formatters 
`Conform` formatters will work once enable it on the file type config : supported formamter [here](https://github.com/stevearc/conform.nvim?tab=readme-ov-file#formatters)
- install formatters via Mason
- enable on config
- enable format from lazy  = <leader>fm 

| Key            | Description               |
| -------------- | -----------               |
| K              | see documents params      |
| gd             | See references            |
| gr             | Reference lsp             |
| gR             | References telescope      |
| [d and ]d      | Diagnostics Jump          |
| <leader>ca     | Code action - to help fix |
| <leader>ld     | Line diagnostics          |



