require 'package'

class Meson < Package
  description 'Fast and user friendly build system'
  homepage 'http://mesonbuild.com'
  version '0.43.0'
  source_url 'https://github.com/mesonbuild/meson/releases/download/0.43.0/meson-0.43.0.tar.gz'
  source_sha256 ''

  binary_url ({ })
  binary_sha256 ({ })

  depends_on 'python3'
  depends_on 'ninja'

  def self.install
    system "python3 setup.py install --prefix=/usr/local"
    system "mkdir -p #{CREW_DEST_DIR}/usr/local/bin"
    system "cp /user/local/bin/meson #{CREW_DEST_DIR}/usr/local/bin"
  end
end
