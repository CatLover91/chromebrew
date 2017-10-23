require 'package'

class Libupnp < Package
  description "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  version "1.6.22"
  source_url "https://downloads.sourceforge.net/project/pupnp/pupnp/libUPnP%201.6.22/libupnp-1.6.22.tar.bz2"
  source_sha256 "0bdfacb7fa8d99b78343b550800ff193264f92c66ef67852f87f042fd1a1ebbc"

  binary_url ({
  })

  binary_sha256 ({
  })

  option "without-ipv6", "Disable IPv6 support"

  def self.build
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]
    args << "--enable-ipv6" if build.with? "ipv6"

    system "./configure", *args
  end

  def self.install
    system "make", "install"
  end
end
