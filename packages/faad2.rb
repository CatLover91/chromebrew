require 'package'

class Faad2 < Package
  description "ISO AAC audio decoder"
  homepage "http://www.audiocoding.com/faad2.html"
  version "2.8.6"
  source_url "https://downloads.sourceforge.net/project/faac/faad2-src/faad2-2.8.0/faad2-2.8.6.tar.gz"
  source_sha256 "654977adbf62eb81f4fca00152aca58ce3b6dd157181b9edd7bed687a7c73f21"

  
  def self.build
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
  end
  def self.install  
    system "make", "install"
  end

  test do
    assert_match "infile.mp4", shell_output("#{bin}/faad -h", 1)
  end
end
