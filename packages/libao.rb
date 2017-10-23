require 'package'

class Libao < Formula
  description "Cross-platform Audio Library"
  homepage "https://www.xiph.org/ao/"
  version "1.2.2"
  source_url "https://github.com/xiph/libao/archive/1.2.2.tar.gz"
  source_sha256 "df8a6d0e238feeccb26a783e778716fb41a801536fe7b6fce068e313c0e2bf4d"
  head "https://git.xiph.org/libao.git"

  
  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "pulseaudio" => :optional

  def self.build
    ENV["AUTOMAKE_FLAGS"] = "--include-deps"
    system "./autogen.sh"

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-static
    ]

    args << "--enable-pulse" if build.with? "pulseaudio"

    system "./configure", *args
  end

  def self.install  
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <ao/ao.h>
      int main() {
        ao_initialize();
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-I#{include}", "-L#{lib}", "-lao", "-o", "test"
    system "./test"
  end
end
