require 'package'

class Libmodplug < Package
  description "Library from the Modplug-XMMS project"
  homepage "https://modplug-xmms.sourceforge.io/"
  version "0.8.9.0"
  source_url "https://downloads.sourceforge.net/modplug-xmms/libmodplug/0.8.9.0/libmodplug-0.8.9.0.tar.gz"
  source_sha256 "457ca5a6c179656d66c01505c0d95fafaead4329b9dbaa0f997d00a3508ad9de"

  
  resource "testmod" do
    # Most favourited song on modarchive:
    # https://modarchive.org/index.php?request=view_by_moduleid&query=60395
    source_url "https://api.modarchive.org/downloads.php?moduleid=60395#2ND_PM.S3M"
    source_sha256 "f80735b77123cc7e02c4dad6ce8197bfefcb8748b164a66ffecd206cc4b63d97"
  end

  def self.build
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
  end

  def self.install
    system "make", "install"
  end

  test do
    # First a basic test just that we can link on the library
    # and call an initialization method.
    (testpath/"test_null.cpp").write <<~EOS
      #include "libmodplug/modplug.h"
      int main() {
        ModPlugFile* f = ModPlug_Load((void*)0, 0);
        if (!f) {
          // Expecting a null pointer, as no data supplied.
          return 0;
        } else {
          return -1;
        }
      }
    EOS
    system ENV.cc, "test_null.cpp", "-L#{lib}", "-lmodplug", "-o", "test_null"
    system "./test_null"

    # Second, acquire an actual music file from a popular internet
    # source and attempt to parse it.
    resource("testmod").stage testpath
    (testpath/"test_mod.cpp").write <<~EOS
      #include "libmodplug/modplug.h"
      #include <fstream>
      #include <sstream>

      int main() {
        std::ifstream in("downloads.php");
        std::stringstream buffer;
        buffer << in.rdbuf();
        int length = buffer.tellp();
        ModPlugFile* f = ModPlug_Load(buffer.str().c_str(), length);
        if (f) {
          // Expecting success
          return 0;
        } else {
          return -1;
        }
      }
    EOS
    system ENV.cc, "test_mod.cpp", "-L#{lib}", "-lmodplug", "-lstdc++", "-o", "test_mod"
    system "./test_mod"
  end
end
