require 'package'

class Wavpack < Package
  description "Hybrid lossless audio compression"
  homepage "http://www.wavpack.com/"
  version "5.1.0"
  source_url "http://www.wavpack.com/wavpack-5.1.0.tar.bz2"
  source_sha256 "1939627d5358d1da62bc6158d63f7ed12905552f3a799c799ee90296a7612944"

  
  head do
    url "https://github.com/dbry/WavPack.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  def self.build
    args = %W[--prefix=#{prefix} --disable-dependency-tracking]

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
  end

  def self.install
    system "make", "install"
  end

  test do
    system bin/"wavpack", test_fixtures("test.wav"), "-o", testpath/"test.wv"
    assert_predicate testpath/"test.wv", :exist?
  end
end
