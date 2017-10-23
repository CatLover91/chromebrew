require 'package'

class FluidSynth < Package
  description "Real-time software synthesizer based on the SoundFont 2 specs"
  homepage "http://www.fluidsynth.org"
  version "1.1.8"
  source_url "https://github.com/FluidSynth/fluidsynth/archive/v1.1.8.tar.gz"
  source)sha256 "318df5aebde8e7353c8878f5c9cb3ba8ed578c2607978b6fbfc5f1cb2ad9d799"

  
  depends_on "pkgconfig" => :build
  depends_on "cmake" => :build
  depends_on "glib"
  depends_on "libsndfile" => :optional
  depends_on "portaudio" => :optional

  def install
    args = std_cmake_args
    args << "-Denable-framework=OFF" << "-DLIB_SUFFIX="
    args << "-Denable-portaudio=ON" if build.with? "portaudio"
    args << "-Denable-libsndfile=OFF" if build.without? "libsndfile"

    mkdir "build" do
      system "cmake", "..", *args
    end
  end
  def self.install
    system "make", "install"
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/fluidsynth --version")
  end
end
