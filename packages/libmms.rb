require 'package'

class Libmms < Package
  description "Library for parsing mms:// and mmsh:// network streams"
  homepage "https://sourceforge.net/projects/libmms/"
  version "0.6.4"
  source_url "https://downloads.sourceforge.net/project/libmms/libmms/0.6.4/libmms-0.6.4.tar.gz"
  source_sha256 "3c05e05aebcbfcc044d9e8c2d4646cd8359be39a3f0ba8ce4e72a9094bee704f"

  
  depends_on "pkgconfig" => :build
  depends_on "glib"

  def self.build
    ENV.append "LDFLAGS", "-liconv"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
  end

  def self.install  
    system "make", "install"
  end
end
