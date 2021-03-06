require 'package'

class TwoLame < Package
  description "Optimized MPEG Audio Layer 2 (MP2) encoder"
  homepage "https://sourceforge.net/projects/twolame/"
  version "0.3.13"
  source_url "https://downloads.sourceforge.net/twolame/twolame-0.3.13.tar.gz"
  source_sha256 "98f332f48951f47f23f70fd0379463aff7d7fb26f07e1e24e42ddef22cc6112a"

  option "with-libsndfile", "Build the twolame frontend"

  deprecated_option "frontend" => "with-libsndfile"

  depends_on "libsndfile" => :optional

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
  end

  def self.install
    system "make", "install"
  end
end
