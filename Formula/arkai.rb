require_relative "arkai_python_resources"

class Arkai < Formula
  include Language::Python::Virtualenv

  desc "CLI for orchestrating coding agents with local or cloud inference"
  homepage "https://github.com/LeGambiArt/arkai"
  url "https://github.com/LeGambiArt/arkai/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "b2825bf54abdfcc2f4f4210fb8f16461cc3003bcaded6516655553d16d1e4056"
  license "Apache-2.0"
  head "https://github.com/LeGambiArt/arkai.git", branch: "main"

  option "with-rag", "Install Arkai's RAG dependencies"
  option "with-mlx", "Install Arkai's MLX dependencies"

  depends_on "cmake" => :build if build.with?("rag")
  depends_on "rust" => :build if build.with?("rag") || build.with?("mlx") || OS.linux?

  depends_on "arapuca"
  depends_on "libyaml"
  depends_on :macos if build.with?("mlx")
  depends_on "python@3.15"
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
          url "https://files.pythonhosted.org/packages/47/c0/d0b335a499a04b65f532c3f034346ef390f81299060f928492dabc1e0272/numpy-2.5.4-cp315-cp315-macosx_14_0_arm64.whl"
          sha256 "0b4724a19de67bea8cfc4970798efa78bcbbe2ac2613cfac16721a42d44de2a5"
        end
      end
    end

    on_linux do
      on_arm do
        resource "numpy-wheel" do
          url "https://files.pythonhosted.org/packages/b3/02/5dad269b02166965a7b4ca14adaddd75dbee0de42435bfecf561b84ba5a6/numpy-2.5.4-cp315-cp315-manylinux_2_27_aarch64.manylinux_2_28_aarch64.whl"
          sha256 "325518d4245b9e331387702aa58c2ce1dc4cdcbb41dfb4ccd5dcbc7e08db1266"
        end
      end

      on_intel do
        resource "numpy-wheel" do
          url "https://files.pythonhosted.org/packages/93/3a/01360c8036822ed9f7aa32189a77d1476567ec1e8e1383522389e4faac45/numpy-2.5.4-cp315-cp315-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
          sha256 "56733449d2544178beaa4545cee357370440cf056c197f9c7bfb19dbfdd0e86d"
        end
      end
    end
  end

  if build.with?("rag")
    # Arkai's RAG extra doesn't request ONNX Runtime, which has no CPython 3.15 wheel.
    on_macos do
      on_arm do
        resource "torch-wheel" do
          url "https://files.pythonhosted.org/packages/99/34/c7ff06165cb09238e945aa2ae63b9186583a47a9880aacd349d37e521f08/torch-2.15.0-cp315-cp315-macosx_14_0_arm64.whl"
          sha256 "06a686eb717cd3d1662363082820be45497318887c596d691af0af0c7649c8f0"
        end

        resource "scipy-wheel" do
          url "https://files.pythonhosted.org/packages/a4/19/68f1c50f609d955d230e66d25d02bd3e1e167ec540232135354fb9a4b9e3/scipy-1.18.1-cp315-cp315-macosx_14_0_arm64.whl"
          sha256 "1bca3b943fc2567ea49cd02c99abde49da4d5178ec46f624bd8255cda8755beb"
        end

        resource "scikit-learn-wheel" do
          url "https://files.pythonhosted.org/packages/64/c9/cc93e8a7fe204e43d70e96e5eb89871643be20025eea05eb4fdaf19afe39/scikit_learn-1.9.1-cp315-cp315-macosx_12_0_arm64.whl"
          sha256 "e1b468241f4a7a9a7a0d6479ad3cc47681cc151a4046c530f2777c3d68f08942"
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
          url "https://download-r2.pytorch.org/whl/cpu/torch-2.15.0%2Bcpu-cp315-cp315-manylinux_2_28_aarch64.whl"
          version "2.15.0"
          sha256 "2cec97b29524b3352bb794321976da7cef2ecee171866499c5630c865396c0a2"
        end

        resource "scipy-wheel" do
          url "https://files.pythonhosted.org/packages/b7/db/30992f9b51a63de671daf3888ffd18378b6cb9ec9f2c972264238ffa7fd6/scipy-1.18.1-cp315-cp315-manylinux_2_27_aarch64.manylinux_2_28_aarch64.whl"
          sha256 "82f201b4c878551d48558337aab270d3c6cca5507b8737c8d8a608d234cccde0"
        end

        resource "scikit-learn-wheel" do
          url "https://files.pythonhosted.org/packages/a2/61/0c6080f0d356fb966053009e7f25e9bff6cf74b0b16195ccf0c3757d1ae8/scikit_learn-1.9.1-cp315-cp315-manylinux_2_27_aarch64.manylinux_2_28_aarch64.whl"
          sha256 "8ca869d0080a5723cde2d5a8b54a2da1ff7e68735a9e9adb3da1243183a0fa01"
        end

        resource "pymupdf-wheel" do
          url "https://files.pythonhosted.org/packages/10/f9/bf895749cbe37a881f4e3d6eb29b6112bedf366829f3709c94c1e3b6ac22/pymupdf-2.1-cp311-abi3-manylinux_2_28_aarch64.whl"
          sha256 "5a1a1fee36d5598013614e06eef25aaa68819d828f5401170dbcaf6f2714d1dd"
        end
      end

      on_intel do
        resource "torch-wheel" do
          url "https://download-r2.pytorch.org/whl/cpu/torch-2.15.0%2Bcpu-cp315-cp315-manylinux_2_28_x86_64.whl"
          version "2.15.0"
          sha256 "3552930ba3d358d3ff0b6fee19cb296e199767443c0c86be2a715471036d9233"
        end

        resource "scipy-wheel" do
          url "https://files.pythonhosted.org/packages/91/d4/bf3e735dc0b9d5a8ff45079d2540e17d3aff7a2f0048dd8f552ffd031d2b/scipy-1.18.1-cp315-cp315-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
          sha256 "0ac49ea97594532dd44b7136094d35f5440fa06e6d9c6384a74c01764df388c5"
        end

        resource "scikit-learn-wheel" do
          url "https://files.pythonhosted.org/packages/47/bb/98a31f10fffbd39edcc2f8bf4119b29652248bb110b7d45c84e68aa293ab/scikit_learn-1.9.1-cp315-cp315-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
          sha256 "6754b7cabfc3df0b1f7b38f7a344f559bbae9d82f0ac5e3d48cccbd19fdcefdf"
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
          url "https://files.pythonhosted.org/packages/74/d7/6abf128b1740d8be1d711d8ded6ccd4714c53d8af8b6267ac6aae285c60e/mlx-0.32.4-cp315-cp315-macosx_14_0_arm64.whl"
          sha256 "4f8e640fd3afcc19da343c5a769743f361573b8db98cd739e295a387921486a5"
        end

        resource "mlx-metal-wheel" do
          url "https://files.pythonhosted.org/packages/77/24/7e5b7ed5d28abacab4577c7a8dd1fca6e9058504f5f95ae4333c09420e2e/mlx_metal-0.32.4-py3-none-macosx_14_0_arm64.whl"
          sha256 "8019b2db622599267d66cc168b2f0dbf5af929790a6c3b3913e00eabc42a7947"
        end

        resource "sentencepiece-wheel" do
          url "https://files.pythonhosted.org/packages/c7/f8/02dc219a545896743edbb0bc60dd7e48fbb1cc96d9299a870b5fca0014ea/sentencepiece-0.2.3-cp315-cp315-macosx_11_0_arm64.whl"
          sha256 "0ef20da5e56faff98bfcd1eb78c9abedc10253035051ab34e0c4be22734390ef"
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

    venv = virtualenv_create(libexec, "python3.15")
    wheel_resources = %w[
      mlx-wheel
      mlx-metal-wheel
      numpy-wheel
      pymupdf-wheel
      scikit-learn-wheel
      scipy-wheel
      sentencepiece-wheel
      torch-wheel
    ]
    venv.pip_install resources.reject { |r| r.test? || wheel_resources.include?(r.name) }

    install_wheel venv, "numpy-wheel" if build.with?("rag") || build.with?("mlx")
    if build.with?("rag")
      %w[scipy-wheel scikit-learn-wheel pymupdf-wheel torch-wheel].each do |name|
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
