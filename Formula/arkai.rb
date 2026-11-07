require_relative "arkai_python_resources"

class Arkai < Formula
  include Language::Python::Virtualenv

  desc "CLI for orchestrating coding agents with local or cloud inference"
  homepage "https://github.com/LeGambiArt/arkai"
  url "https://github.com/LeGambiArt/arkai/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "4433392d14817af00f67a11e1c4f619dc3dabdf4b33d71720c5a33f95fd861d3"
  license "Apache-2.0"
  head "https://github.com/LeGambiArt/arkai.git", branch: "main"

  option "with-rag", "Install Arkai's RAG dependencies"
  option "with-mlx", "Install Arkai's MLX dependencies"

  depends_on "cmake" => :build if build.with?("rag")
  depends_on "rust" => :build if build.with?("rag") || build.with?("mlx") || OS.linux?

  depends_on "arapuca"
  depends_on "libyaml"
  depends_on :macos if build.with?("mlx")
  depends_on "python@3.14"
  depends_on "wtmcp"

  on_macos do
    depends_on arch: :arm64 if build.with?("rag") || build.with?("mlx")
    depends_on macos: :sonoma if build.with?("rag") || build.with?("mlx")
  end

  on_linux do
    depends_on "libffi"
  end
  ArkaiPythonResources.declare self, ArkaiPythonResources::LINUX_KEYRING if OS.linux?

  if build.with?("rag") || build.with?("mlx")
    ArkaiPythonResources.declare self, ArkaiPythonResources::SHARED
  end

  ArkaiPythonResources.declare self, ArkaiPythonResources::RAG if build.with?("rag")
  ArkaiPythonResources.declare self, ArkaiPythonResources::MLX if build.with?("mlx")

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/fd/11/b524cbd9bbdaca58608e4cf4053fd463417549e1959fa8d3aa18319f9555/certifi-2026.10.23.tar.gz"
    sha256 "a9895e6e2758b371e0545e321a3a8fd1fcfd9829ada8824a936dfb16aaaf36cd"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "jaraco-classes" do
    url "https://files.pythonhosted.org/packages/06/c0/ed4a27bc5571b99e3cff68f8a9fa5b56ff7df1c2251cc715a652ddd26402/jaraco.classes-3.4.0.tar.gz"
    sha256 "47a024b51d0239c0dd8c8540c6c7f484be3b8fcf0b2d85c13825780d3b3f3acd"
  end

  resource "jaraco-context" do
    url "https://files.pythonhosted.org/packages/af/50/4763cd07e722bb6285316d390a164bc7e479db9d90daa769f22578f698b4/jaraco_context-6.1.2.tar.gz"
    sha256 "f1a6c9d391e661cc5b8d39861ff077a7dc24dc23833ccee564b234b81c82dfe3"
  end

  resource "jaraco-functools" do
    url "https://files.pythonhosted.org/packages/6c/1f/c23395957d41ccf27c4e535c3d334c4051e5395b3752057ba4cbaec35c56/jaraco_functools-4.6.0.tar.gz"
    sha256 "880c577ec9720b3a052d5bc611fb9f2269b3d87902ef42440df443b88e443280"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/43/4b/674af6ef2f97d56f0ab5153bf0bfa28ccb6c3ed4d1babf4305449668807b/keyring-25.7.0.tar.gz"
    sha256 "fe01bd85eb3f8fb3dd0405defdeac9a5b4f6f0439edbb3149577f244a2e8245b"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/52/b8/c63995bebbb9ac9c059350e0fb8c82c2420c85aeca7d34e40aecf3df9281/more_itertools-11.2.1.tar.gz"
    sha256 "cbf08fd0af284dc69718b9b76a8e6203df624d70209ea511e4219d350c856f63"
  end

  if build.with?("rag") || build.with?("mlx")
    on_macos do
      on_arm do
        resource "numpy-wheel" do
          url "https://files.pythonhosted.org/packages/d5/b2/c6ce165acffceb15a82c07b9cc77d391f86b3f379ba62911908ae5d34b91/numpy-2.5.4-cp314-cp314-macosx_14_0_arm64.whl"
          sha256 "956555e0603a4d38019ae6925711cb9dc43195c076a928accf7ea5d50bddfe53"
        end
      end
    end

    on_linux do
      on_arm do
        resource "numpy-wheel" do
          url "https://files.pythonhosted.org/packages/63/d6/34b0a2b0741386a63025a65a2c09caaaaaad6d0ca95b66cd65c30dd7fcb5/numpy-2.5.4-cp314-cp314-manylinux_2_27_aarch64.manylinux_2_28_aarch64.whl"
          sha256 "4054173604cd8658796053f1f3bc0befb68ec1c0762c57fdad61e199256a8617"
        end
      end

      on_intel do
        resource "numpy-wheel" do
          url "https://files.pythonhosted.org/packages/16/d5/928078d2b28f26829b138b4a6c3980045022fb409f570657a224ae60ef4e/numpy-2.5.4-cp314-cp314-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
          sha256 "d549420b8858885cea8838a727842249218b9c1da24dd517e25c9c7a948310a3"
        end
      end
    end
  end

  if build.with?("rag")
    on_macos do
      on_arm do
        resource "torch-wheel" do
          url "https://files.pythonhosted.org/packages/ee/90/1241e7db5ccc2455f8735bd6b1becfad39916206ad18001c4c0014d139e2/torch-2.14.0-cp314-cp314-macosx_14_0_arm64.whl"
          sha256 "860423e970f2ce02c4476e8e2d1350131b1c5c5a5e4912180e78b50b53241efa"
        end

        resource "onnxruntime-wheel" do
          url "https://files.pythonhosted.org/packages/d7/55/b511099a435972b86b5d04ef374cdca8de920311cc979180029b80145bf5/onnxruntime-1.31.1-cp314-cp314-macosx_14_0_arm64.whl"
          sha256 "8536ac43682caa7492c46d6cfd4c3c8db288dcf0619508431a22170b670ee1d0"
        end

        resource "scipy-wheel" do
          url "https://files.pythonhosted.org/packages/70/e8/6b0c288c50942d78193696c9f15f9a0874f5178aa0ddf40f83d9924b3e8d/scipy-1.18.1-cp314-cp314-macosx_14_0_arm64.whl"
          sha256 "011413b7426b75012840e35649e00fe0a2c3bae89fed433876e3a99251572efc"
        end

        resource "scikit-learn-wheel" do
          url "https://files.pythonhosted.org/packages/9b/ed/d68115577c8b42b0442ebd8180945d4008880a33176094640e00b585128e/scikit_learn-1.9.1-cp314-cp314-macosx_12_0_arm64.whl"
          sha256 "8893bc6331f60f18d4ac75e12ed356e2dcf6a564bf767918b5b7ca54c8c8be49"
        end

        resource "pymupdf-wheel" do
          url "https://files.pythonhosted.org/packages/36/5c/e636dacbb4d3d39985e20904e3f13712c181e0e9bec6553953583a6723b1/pymupdf-2.1-cp311-abi3-macosx_11_0_arm64.whl"
          sha256 "1bb2284bde6067f05f83961ea678480060870dc966ad520bcf97da0b0eccf40c"
        end
      end
    end

    on_linux do
      on_arm do
        resource "torch-wheel" do
          url "https://download-r2.pytorch.org/whl/cpu/torch-2.14.0%2Bcpu-cp314-cp314-manylinux_2_28_aarch64.whl"
          version "2.14.0"
          sha256 "27b34640fea7268862961b734c723873e15b1c2657b1eb84bcfac053e5841527"
        end

        resource "onnxruntime-wheel" do
          url "https://files.pythonhosted.org/packages/06/ef/98f0060d6cf58f9f663268fef65fe729120b8fbe26ef35eaa2c8d9030d33/onnxruntime-1.31.1-cp314-cp314-manylinux_2_28_aarch64.whl"
          sha256 "c878686b75cade1ed59131aa018ab004b1e64368b0d54041912450b9642cf04f"
        end

        resource "scipy-wheel" do
          url "https://files.pythonhosted.org/packages/0b/56/030af62bea3cf878e0028515dff78c123b01633606a879b63f42d2db99cc/scipy-1.18.1-cp314-cp314-manylinux_2_27_aarch64.manylinux_2_28_aarch64.whl"
          sha256 "2d3ab0e8c69a17dd3559eab8cbb88f258e285c94d572c2719033f90f83290c89"
        end

        resource "scikit-learn-wheel" do
          url "https://files.pythonhosted.org/packages/c4/6c/06c7eb61a438e389cbf3f7210897069bec5a883dbe03c189ae792781e11a/scikit_learn-1.9.1-cp314-cp314-manylinux_2_27_aarch64.manylinux_2_28_aarch64.whl"
          sha256 "b5492cf2df5226691c32611de8734bcf42148c6547ae53c7f4e6b847793addc0"
        end

        resource "pymupdf-wheel" do
          url "https://files.pythonhosted.org/packages/10/f9/bf895749cbe37a881f4e3d6eb29b6112bedf366829f3709c94c1e3b6ac22/pymupdf-2.1-cp311-abi3-manylinux_2_28_aarch64.whl"
          sha256 "5a1a1fee36d5598013614e06eef25aaa68819d828f5401170dbcaf6f2714d1dd"
        end
      end

      on_intel do
        resource "torch-wheel" do
          url "https://download-r2.pytorch.org/whl/cpu/torch-2.14.0%2Bcpu-cp314-cp314-manylinux_2_28_x86_64.whl"
          version "2.14.0"
          sha256 "f152f41dc5dc462afe0de780e451ebb47ea8b4451f8f919f9537aa8e2cbe1d7e"
        end

        resource "onnxruntime-wheel" do
          url "https://files.pythonhosted.org/packages/aa/74/a891a659ccc427469de0d7bdbd5ff770a35f73084ee590ce02456cf61f7f/onnxruntime-1.31.1-cp314-cp314-manylinux_2_28_x86_64.whl"
          sha256 "c20d7f15d84427db070b163f78c2c7146cc93edd6113fa7327671259a24184fe"
        end

        resource "scipy-wheel" do
          url "https://files.pythonhosted.org/packages/6b/89/2a844506d49651e9aa1af6ef95b6bd8031cb1d5a4375edec6155037e04cf/scipy-1.18.1-cp314-cp314-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
          sha256 "ac0333bdf38309aa3dcbe7e3fa7ea29e7a2c37c6ea306a757b700ded8e4596ad"
        end

        resource "scikit-learn-wheel" do
          url "https://files.pythonhosted.org/packages/86/4e/0bab75490ca4b85fad8388739c7ebc71d9db553f8c69e39943ee8db0aaae/scikit_learn-1.9.1-cp314-cp314-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
          sha256 "993d332ff80e62efae9e39603b7e872297c418d780f01a01855269a3489c950f"
        end

        resource "pymupdf-wheel" do
          url "https://files.pythonhosted.org/packages/f4/dc/e244c162ab621a45bfe36e33fe432264ef7e40592f739474864df66a2dd8/pymupdf-2.1-cp311-abi3-manylinux_2_28_x86_64.whl"
          sha256 "a9efa2e9e5f469d3b5749199329739cfef1ff1d1846538ced4885c544eecbcd9"
        end
      end
    end
  end

  if build.with?("mlx")
    on_macos do
      on_arm do
        resource "mlx-wheel" do
          url "https://files.pythonhosted.org/packages/99/2f/ed874a2de4ad30b47f27960373880aa24b53d8963ea81125e12e460340c2/mlx-0.32.4-cp314-cp314-macosx_14_0_arm64.whl"
          sha256 "f1e6ef441e1e2ce54159022a8fa5597f8ea4f7acf278752049c4f774bbd0501d"
        end

        resource "mlx-metal-wheel" do
          url "https://files.pythonhosted.org/packages/77/24/7e5b7ed5d28abacab4577c7a8dd1fca6e9058504f5f95ae4333c09420e2e/mlx_metal-0.32.4-py3-none-macosx_14_0_arm64.whl"
          sha256 "8019b2db622599267d66cc168b2f0dbf5af929790a6c3b3913e00eabc42a7947"
        end

        resource "sentencepiece-wheel" do
          url "https://files.pythonhosted.org/packages/a7/5b/267e83f3990d0ef941141cb1bb9d0ed4c595623bb07ee5d78ee78aa05ee4/sentencepiece-0.2.3-cp314-cp314-macosx_11_0_arm64.whl"
          sha256 "ba4dfdbb2972e42d01ad32fe03788717e94d92830f981b7895835e65bfe92b2c"
        end
      end
    end
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/70/b3/c19426f783614d625699a4b247faf628ea9ab1db228674491767b417f9e1/setuptools-84.2.1.tar.gz"
    sha256 "3ff8b3b5492a0aa66960f4419365a86b84e013070d4313e4d4a6894f5d64d6bc"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/d0/20/50ed6bdf27dec98b568a8ae25dc599f35baa3d9709f9e83fd1edb56b9a90/wheel-0.48.0.tar.gz"
    sha256 "94800765601e9171bf5d58d066e640662842bcedcbab982b2c90787a2c987322"
  end

  def install
    if OS.linux? && build.with?("rag") && Version.new(OS::Linux::Glibc.system_version.to_s) < Version.new("2.28")
      odie "The RAG extra requires glibc 2.28 or newer for its Python wheels."
    end

    venv = virtualenv_create(libexec, "python3.14")
    wheel_resources = %w[
      mlx-wheel
      mlx-metal-wheel
      numpy-wheel
      onnxruntime-wheel
      pymupdf-wheel
      scikit-learn-wheel
      scipy-wheel
      sentencepiece-wheel
      torch-wheel
    ]
    venv.pip_install resources.reject { |r| r.test? || wheel_resources.include?(r.name) }

    install_wheel venv, "numpy-wheel" if build.with?("rag") || build.with?("mlx")
    if build.with?("rag")
      %w[scipy-wheel scikit-learn-wheel pymupdf-wheel torch-wheel onnxruntime-wheel].each do |name|
        install_wheel venv, name
      end
    end
    if build.with?("mlx")
      install_wheel venv, "mlx-wheel"
      install_wheel venv, "mlx-metal-wheel"
      install_wheel venv, "sentencepiece-wheel"
    end

    venv.pip_install_and_link buildpath
  end

  def install_wheel(venv, name)
    venv.pip_install resource(name).fetch
  end

  def caveats
    <<~EOS
      Install a supported coding-agent CLI and an inference backend separately.
      Git (and Git LFS for some models) is needed for Git-backed model downloads.
      Install with --with-rag to add RAG support (Linux x86_64/aarch64 or Apple Silicon macOS).
      Install with --with-mlx to add MLX support (Apple Silicon macOS 14 or newer only).
      RAG wheels require glibc 2.28 or newer on Linux.
      The Python keyring package is included by default.
    EOS
  end

  test do
    assert_match(/arkai \d+\.\d+\.\d+/, shell_output("#{bin}/arkai --version"))
    assert_match(/usage:/, shell_output("#{bin}/arkai --help").downcase)
  end
end
