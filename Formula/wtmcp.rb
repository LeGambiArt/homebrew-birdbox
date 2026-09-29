class Wtmcp < Formula
  desc "MCP server with plugin-based integrations for developer tools"
  homepage "https://github.com/LeGambiArt/wtmcp"
  url "https://github.com/LeGambiArt/wtmcp/archive/refs/tags/v0.1.9.tar.gz"
  sha256 "899b789c6f2a93fd4c147f3205b071b5e5e8c1c02440ee32337c5c8d07d09ce7"
  license "GPL-3.0-only"
  head "https://github.com/LeGambiArt/wtmcp.git", branch: "main"

  depends_on "go" => :build
  depends_on "arapuca"
  depends_on "python@3"

  def install
    system "git", "submodule", "update", "--init", "--recursive" if File.directory?(".git")
    ENV.prepend_path "PKG_CONFIG_PATH", formula_opt_lib("arapuca")/"pkgconfig"

    version_str = if build.head?
      Utils.git_short_head
    else
      version.to_s
    end

    build_date = Time.now.utc.strftime("%Y-%m-%dT%H:%M:%SZ")

    ldflags = %W[
      -s -w
      -X main.Version=#{version_str}
      -X main.BuildDate=#{build_date}
    ]
    goflags = %w[-trimpath -buildmode=pie]

    system "go", "build", *goflags, *std_go_args(ldflags:), "./cmd/wtmcp"
    system "go", "build", *goflags, *std_go_args(ldflags:, output: bin/"wtmcpctl"), "./cmd/wtmcpctl"

    go_plugins = %w[bugzilla gitlab google-calendar google-docs google-drive google-gmail]
    go_plugins.each do |plugin|
      system "go", "build", *goflags, "-ldflags", ldflags.join(" "),
             "-o", "plugins/#{plugin}/handler", "./plugins/#{plugin}"
    end

    Dir.glob("plugins/*/plugin.yaml").each do |yaml_path|
      plugin_dir = Pathname.new(File.dirname(yaml_path))
      plugin_name = File.basename(plugin_dir)
      next if plugin_name.start_with?("_")

      target = share/"wtmcp/plugins"/plugin_name
      target.install Dir[plugin_dir/"plugin.yaml"]
      target.install Dir[plugin_dir/"context.md"]
      target.install Dir[plugin_dir/"handler"] if File.exist?(plugin_dir/"handler")
      Dir.glob(File.join(plugin_dir, "*.py")).each { |f| target.install f }
    end
  end

  def caveats
    <<~EOS
      Plugins are installed to:
        #{share}/wtmcp/plugins/

      Configure credentials in:
        ~/.config/wtmcp/env.d/

      User plugins can be installed to:
        ~/.config/wtmcp/plugins/

      User plugins are disabled by default. To enable them, run:
        wtmcpctl plugins user-plugins enable

      To configure the MCP server for an agent in the current directory, run:
        wtmcpctl agent enable <agent>

      Supported agents: claude-code, gemini, cursor.
    EOS
  end

  test do
    assert_match(/\d/, shell_output("#{bin}/wtmcp --version"))
    assert_match(/\d/, shell_output("#{bin}/wtmcpctl --version"))
  end
end
