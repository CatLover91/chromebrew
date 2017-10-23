require 'package'

class Libmpdclient < Package
  description 'Library for MPD in the C, C++, and Objective-C languages'
  homepage 'https://www.musicpd.org/libs/libmpdclient/'
  version '2.13'
  source_url 'https://www.musicpd.org/download/libmpdclient/2/libmpdclient-2.13.tar.xz'
  shource_sha256 ''

  binary_url({
    
  })
  binary_sha256 ({
    
  })

  depends_on "doxygen" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build

  def self.install
    system "meson", "--prefix=#{CREW_DEST_DIR}", ".", "output"
    system "ninja", "-c", "output"
    system "ninja", "-c", "output", "install"
  end
end
