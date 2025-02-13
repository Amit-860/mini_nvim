if vim.g.vscode then
    return
end

local jdtls = require("jdtls")
local lsp_utils = require("lsp_utils")
local mason_registry = require("mason-registry")
local jdtls_path = mason_registry.get_package("jdtls"):get_install_path()
local lombok_path = vim.fn.expand(mason_registry.get_package("lombok-nightly"):get_install_path() .. "/lombok.jar")
-- local lombok_path = vim.fn.expand(vim.fn.stdpath("data") .. "/mason/packages/lombok-nightly/lombok.jar") -- install lombok-nightly from mason
-- local lombok_path = jdtls_path .. vim.fn.expand("/lombok.jar")

-- Setup Workspace
local home = vim.fn.expand("$HOME")
local root_dir = vim.fs.root(0, { ".metadata", ".git", "pom.xml", "build.gradle", "mvnw", ".project" })
local workspace_path = home .. "/.nvim/workspace/"
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = vim.fn.expand(workspace_path .. project_name)
local os_config = "win"
local bundles = {
    vim.fn.glob(
        mason_registry.get_package("java-debug-adapter"):get_install_path()
            .. "/extension/server/com.microsoft.java.debug.plugin-*.jar",
        true
    ),
}

-- vim.list_extend(bundles, require("spring_boot").java_extensions())

-- local java_test_path = mason_registry.get_package("java-test"):get_install_path()
-- local jar_patterns = {
--     java_test_path .. "/extension/server/com*.jar",
--     java_test_path .. "/extension/server/org*.jar",
--     java_test_path .. "/extension/server/junit*.jar",
-- }
--
-- for _, jar_pattern in ipairs(jar_patterns) do
--     vim.list_extend(bundles, vim.split(vim.fn.glob(jar_pattern), "\n"))
-- end

local jdtls_specific_keymaps = function(client, bufnr)
    vim.keymap.set({ "n" }, "<leader>ltc", function()
        require("jdtls").test_class()
    end, { desc = "test_class", noremap = false, buffer = bufnr })
    vim.keymap.set({ "n" }, "<leader>ltm", function()
        require("jdtls").test_nearest_method()
    end, { desc = "test_nearest_method", noremap = true, buffer = bufnr })
    vim.keymap.set({ "n" }, "<leader>ltp", function()
        vim.cmd("RunCode mvn clean compile exec:java")
    end, { desc = "test_project", noremap = true, buffer = bufnr })
end

local config = {
    root_dir = root_dir,
    cmd = {
        "java",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ERROR", -- ALL, OFF, ERROR, INFO, TRACE, DEBUG
        "-Xms2g",
        "--add-modules=ALL-SYSTEM",
        "--add-opens",
        "java.base/java.util=ALL-UNNAMED",
        "--add-opens",
        "java.base/java.lang=ALL-UNNAMED",
        "-javaagent:" .. lombok_path, -- uncomment for lombok support
        "-Xbootclasspath/a:" .. lombok_path, -- uncomment for lombok support
        "-jar",
        vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher.jar"),
        "-configuration",
        jdtls_path .. "/config_" .. os_config,
        "-data",
        workspace_dir,
    },
    flags = {
        debounce_text_changes = 150,
        allow_incremental_sync = false,
    },
    on_init = function(client)
        if client.config.settings then
            client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
        end
    end,
    init_options = {
        bundles = bundles,
    },
    on_attach = function(client, bufnr)
        if client.name == "jdtls" then
            -- Auto-detect main and setup dap config
            require("jdtls.dap").setup_dap_main_class_configs({
                config_overrides = { vmArgs = "-Dspring.profiles.active=local" },
            })
            require("jdtls.dap").setup_dap_main_class_configs({})
            --
            -- Add specific keys for jdtls
            --
        end
        lsp_utils.on_attach(client, bufnr)
        jdtls_specific_keymaps(client, bufnr)
    end,

    -- These depend on nvim-dap, but can additionally be disabled by setting false here.
    dap = { hotcodereplace = "auto", config_overrides = {} },
    dap_main = {},
    test = true,
    handlers = { ["$/progress"] = function(_, result, ctx) end },
    capabilities = lsp_utils.lsp_capabilities(),
    settings = {
        java = {
            eclipse = { downloadSources = true },
            maven = { downloadSources = true },
            implementationsCodeLens = { enabled = false },
            referencesCodeLens = { enabled = false },
            references = { includeDecompiledSources = true },
            signatureHelp = { enabled = true },
            inlayHints = {
                parameterNames = {
                    enabled = "all",
                },
            },
            saveActions = { organizeImports = true },
            completion = {
                maxResults = 20,
                favoriteStaticMembers = {
                    "org.hamcrest.MatcherAssert.assertThat",
                    "org.hamcrest.Matchers.*",
                    "org.hamcrest.CoreMatchers.*",
                    "org.junit.jupiter.api.Assertions.*",
                    "java.util.Objects.requireNonNull",
                    "java.util.Objects.requireNonNullElse",
                    "org.mockito.Mockito.*",
                },
                importOrder = {
                    "java",
                    "javax",
                    "com",
                    "org",
                },
            },
            extendedClientCapabilities = jdtls.extendedClientCapabilities,
            sources = {
                organizeImports = {
                    starThreshold = 9999,
                    staticStarThreshold = 9999,
                },
            },
            codeGeneration = {
                toString = {
                    template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
                },
                useBlocks = true,
            },
            configuration = {
                -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
                -- And search for `interface RuntimeOption`
                -- The `name` is NOT arbitrary, but must match one of the elements from `enum ExecutionEnvironment` in the link above
                runtimes = {
                    {
                        name = "JavaSE-21",
                        path = vim.fn.expand("$HOME/scoop/apps/graalvm-oracle-21jdk/current/"),
                    },
                },
            },
        },
    },
}

-- initializing jdtls lsp on java files
jdtls.start_or_attach(config)
