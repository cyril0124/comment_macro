---@diagnostic disable

local prj_dir = os.projectdir()
local bin_dir = path.join(prj_dir, "bin")

target("comment_macro", function()
    set_kind("phony")
    set_default(true)
    on_build(function(target)
        os.exec("cargo build --release")
        os.mkdir(path.join(prj_dir, "bin"))
        os.cp(path.join(prj_dir, "target/release/comment_macro"), bin_dir)
    end)
end)

target("clean", function()
    set_kind("phony")
    set_default(false)
    on_run(function(target)
        os.tryrm(path.join(prj_dir, "target"))
    end)
end)

target("test", function()
    set_kind("phony")
    set_default(false)
    on_run(function(target)
        local comment_macro = path.join(bin_dir, "comment_macro")
        assert(os.isfile(comment_macro), "comment_macro not found")

        local test_dir = path.join(prj_dir, "tests")
        local golden_dir = path.join(test_dir, "golden")
        local function run_and_compare(file, golden_file, extra_args)
            local ret_file = os.iorun(comment_macro .. " " .. file .. " " .. (extra_args or ""))
            local ret_content = io.readfile(ret_file)
            local golden_content = io.readfile(golden_file)
            assert(ret_content == golden_content,
                "ret_content is not equal to golden_content\n\tret_file: " ..
                ret_file .. "\n\tgolden_file: " .. golden_file)
        end

        run_and_compare(
            path.join(test_dir, "test.lua"),
            path.join(golden_dir, "test.lua")
        )
        run_and_compare(
            path.join(test_dir, "test_include.v"),
            path.join(golden_dir, "test_include.v")
        )
        run_and_compare(
            path.join(test_dir, "test.py"),
            path.join(golden_dir, "test.py")
        )
        run_and_compare(
            path.join(test_dir, "test_no_directive.v"),
            path.join(test_dir, "test_no_directive.v")
        )
        run_and_compare(
            path.join(test_dir, "test_no_directive.v"),
            path.join(golden_dir, "test_no_directive.v"),
            "--force-enable"
        )
        run_and_compare(
            path.join(test_dir, "multiple_lua_blocks.c"),
            path.join(golden_dir, "multiple_lua_blocks.c")
        )

        local ret_file = os.iorun(comment_macro .. " " .. path.join(test_dir, "test.lua") .. " --outdir ./target")
        assert(path.directory(ret_file) == "./target")
    end)
end)
