# ⚡ Svelte Development Guide

Complete Svelte development setup with LSP, TypeScript, Tailwind CSS, and formatting.

---

## 📋 Overview

This configuration provides a modern Svelte development environment with:

- **LSP Servers**: svelte-language-server + TypeScript LSP
- **TypeScript Support**: Full TypeScript integration in `.svelte` files
- **Tailwind CSS**: Autocomplete for Tailwind classes (if using Tailwind)
- **Formatter**: Prettier with Svelte plugin
- **Emmet**: HTML abbreviation expansion
- **Auto-install**: Tools automatically installed via Mason
- **Format on Save**: Automatic Prettier formatting

**Startup Time**: Svelte tools only load when you open a `.svelte` file!

---

## 🚀 Quick Start

### First Time Setup

1. **Create a Svelte project** (SvelteKit recommended):
   ```bash
   npm create svelte@latest myproject
   cd myproject
   npm install
   ```

2. **Open a Svelte file**:
   ```bash
   nvim src/routes/+page.svelte
   ```

3. **Auto-installation begins**:
   - Svelte LSP server installs
   - TypeScript LSP installs
   - Prettier (Svelte plugin) installs
   - Tailwind LSP installs (if detected)
   - Wait 30-60 seconds

4. **Verify**:
   ```vim
   :LspInfo
   " Should show: svelte, ts_ls, and possibly tailwindcss
   ```

5. **Start coding**:
   - Type `<script` and see completions
   - TypeScript errors appear inline
   - Tailwind classes autocomplete
   - Format on save enabled

---

## ⚙️ Features

### Intelligent Code Completion

**Svelte-specific**:
- Component syntax (`<script>`, `<style>`, etc.)
- Svelte directives (`on:click`, `bind:value`, etc.)
- Reactive declarations (`$:`)
- Store syntax (`$store`)
- Component props and exports

**TypeScript/JavaScript**:
- Import suggestions
- Method completion
- Type hints
- Parameter info

**HTML/CSS**:
- Tag completion
- CSS property completion
- Emmet abbreviations (`div.class>p` → expand)
- Tailwind class completion

### Real-Time Diagnostics

- **TypeScript errors**: Type mismatches, undefined variables
- **Svelte errors**: Invalid syntax, unused props
- **CSS errors**: Invalid properties
- **Accessibility warnings**: Missing alt text, etc.

### Format on Save

Prettier automatically formats:
- HTML structure
- JavaScript/TypeScript code
- CSS styling
- Proper indentation
- Consistent quotes and semicolons

---

## ⌨️ Svelte Keymaps

### Standard LSP Navigation
| Key | Description |
|-----|-------------|
| `gd` | Go to definition (components, functions) |
| `gr` | Find references (Telescope) |
| `gi` | Go to implementation |
| `gt` | Go to type definition |
| `K` | Show hover documentation |
| `<C-k>` | Signature help (insert mode) |

### Code Actions
| Key | Description |
|-----|-------------|
| `<Leader>.` | Show code actions |
| `grn` | Rename symbol |
| `<Leader>cf` | Format file (Prettier) |

### Diagnostics
| Key | Description |
|-----|-------------|
| `]d` | Next diagnostic |
| `[d` | Previous diagnostic |
| `<Leader>sd` | Search diagnostics (Telescope) |
| `<Leader>q` | Toggle diagnostic quickfix |

### Svelte-Specific (coming soon)
| Key | Description |
|-----|-------------|
| `<Leader>vc` | Create new component |
| `<Leader>vi` | Import component |
| `<Leader>vt` | Toggle TypeScript |

---

## 🎨 Tailwind CSS Support

### Setup

If your project uses Tailwind CSS, it's automatically detected!

**Detection**: Looks for `tailwind.config.js` or `tailwind.config.ts`

### Features

**Class completion**:
```svelte
<div class="flex items-center gap-|">
              ↑ Autocomplete shows all Tailwind classes!
```

**Hover documentation**:
```svelte
<div class="flex">
         ↑ Hover shows: display: flex;
```

**Color previews**:
```svelte
<div class="bg-blue-500">
                    ↑ See color swatch inline!
```

### Configuration

**Location**: `lua/plugins/lang/svelte.lua`

Tailwind LSP is configured to work with:
- `.svelte` files
- `.html` files
- `.jsx`, `.tsx` files
- `.css`, `.scss` files

---

## 🔧 Configuration

### Svelte LSP Settings

**Location**: `lua/plugins/lang/svelte.lua`

```lua
settings = {
  svelte = {
    plugin = {
      html = { 
        completions = { enable = true, emmet = true }
      },
      svelte = { 
        completions = { enable = true }
      },
      css = { 
        completions = { enable = true }
      },
      typescript = { 
        diagnostics = { enable = true }
      },
    },
  },
}
```

### TypeScript Support

**In `.svelte` files**:
```svelte
<script lang="ts">
  let count: number = 0;
  
  function increment(): void {
    count += 1;
  }
</script>
```

TypeScript LSP automatically activates with full type checking!

### Prettier Configuration

**Create `.prettierrc` in project root**:
```json
{
  "plugins": ["prettier-plugin-svelte"],
  "svelteIndentScriptAndStyle": true,
  "svelteAllowShorthand": true,
  "svelteSortOrder": "scripts-markup-styles"
}
```

---

## 🎯 Common Tasks

### Creating Components

**Svelte component template**:
```svelte
<script lang="ts">
  // Your logic here
  export let title: string;
</script>

<div>
  <h1>{title}</h1>
  <slot />
</div>

<style>
  h1 {
    color: navy;
  }
</style>
```

### Using Stores

```svelte
<script>
  import { writable } from 'svelte/store';
  
  const count = writable(0);
  
  // Auto-subscribe with $
  console.log($count);
</script>

<button on:click={() => $count++}>
  Count: {$count}
</button>
```

### Reactive Statements

```svelte
<script>
  let count = 0;
  
  // Reactive - runs when count changes
  $: doubled = count * 2;
  $: console.log(`Count is ${count}`);
</script>
```

### Component Props with TypeScript

```svelte
<script lang="ts">
  interface Props {
    title: string;
    count?: number;
  }
  
  let { title, count = 0 }: Props = $props();
</script>
```

---

## 📦 Tools & Versions

### Installed Tools

| Tool | Purpose | Auto-Install |
|------|---------|--------------|
| **svelte-language-server** | Svelte LSP | ✅ Yes |
| **typescript-language-server** | TypeScript LSP | ✅ Yes |
| **prettier** | Formatter | ✅ Yes |
| **prettier-plugin-svelte** | Svelte formatting | ✅ Yes |
| **tailwindcss-language-server** | Tailwind completion | ✅ Yes (if detected) |

### Checking Installations

```vim
:Mason                    " See all installed tools
:LspInfo                  " Check active LSP servers
:checkhealth mason        " Diagnose Mason issues
:checkhealth lsp          " Diagnose LSP issues
```

---

## 🔍 Troubleshooting

### LSP Not Starting

**Check active clients**:
```vim
:LspInfo
" Should show 'svelte' and 'ts_ls'
```

**If not active**:
1. Ensure servers installed: `:Mason`
2. Check file type: `:set filetype?` (should be "svelte")
3. Restart LSP: `:LspRestart`
4. Check logs: `:LspLog`

### TypeScript Not Working in `.svelte`

**Check script tag**:
```svelte
<!-- Make sure you have lang="ts" -->
<script lang="ts">
  // TypeScript code here
</script>
```

**Restart LSP**:
```vim
:LspRestart
```

### Tailwind Classes Not Autocompleting

**Check config file exists**:
```bash
ls tailwind.config.js  # or .ts
```

**Verify Tailwind LSP**:
```vim
:LspInfo
" Should show 'tailwindcss' if config detected
```

**Manual install**:
```vim
:MasonInstall tailwindcss-language-server
```

### Format Not Working

1. **Check Prettier installed**: `:Mason`
2. **Manual format**: `<Leader>cf` or `:Format`
3. **Check conform**: `:checkhealth conform`
4. **Verify `.prettierrc`**: Ensure it has svelte plugin

### Import Errors

**Common issue**: Imports not resolving

**Solution**: Ensure `jsconfig.json` or `tsconfig.json` exists:
```json
{
  "compilerOptions": {
    "baseUrl": ".",
    "paths": {
      "$lib/*": ["src/lib/*"]
    }
  }
}
```

---

## 💡 Tips & Tricks

### Emmet in Svelte

```svelte
<!-- Type and press Tab: -->
div.container>h1.title+p.description

<!-- Expands to: -->
<div class="container">
  <h1 class="title"></h1>
  <p class="description"></p>
</div>
```

### Quick Component Import

1. Type component name: `<MyComponent`
2. See error (not imported)
3. Press `<Leader>.` → Select "Add import"

### Reactive Debugging

```svelte
<script>
  let count = 0;
  
  // Debug reactive statements
  $: console.log('Count changed:', count);
  $: {
    console.log('Complex reactive block');
    if (count > 5) {
      console.log('Count is high!');
    }
  }
</script>
```

### SvelteKit Routes

**Understanding route structure**:
```
src/routes/
├── +page.svelte          # / route
├── about/
│   └── +page.svelte      # /about route
└── blog/
    ├── +page.svelte      # /blog route
    └── [slug]/
        └── +page.svelte  # /blog/:slug route
```

Use `gd` to jump between `+page.svelte`, `+page.ts`, and `+page.server.ts`!

---

## 📖 Resources

### Svelte Documentation
- [Svelte Tutorial](https://svelte.dev/tutorial)
- [Svelte Docs](https://svelte.dev/docs)
- [SvelteKit Docs](https://kit.svelte.dev/docs)

### Tool Documentation
- [Svelte LSP](https://github.com/sveltejs/language-tools)
- [TypeScript Docs](https://www.typescriptlang.org/docs/)
- [Tailwind CSS](https://tailwindcss.com/docs)
- [Prettier](https://prettier.io/docs/en/)

### Learning Resources
- [Svelte REPL](https://svelte.dev/repl) - Online playground
- [Svelte Society](https://sveltesociety.dev/) - Recipes and resources
- [SvelteKit Examples](https://github.com/sveltejs/kit/tree/master/sites/kit.svelte.dev)

---

<div align="center">

**Happy Svelte coding!** ⚡

[← Back to Languages](README.md) | [Python →](python.md) | [Rust →](rust.md)

</div>
