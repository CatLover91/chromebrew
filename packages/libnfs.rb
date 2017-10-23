require 'package'

class Libnfs < Package
  description "C client library for NFS"
  homepage "https://github.com/sahlberg/libnfs"
  version "2.0.0"
  source_url "https://github.com/sahlberg/libnfs/archive/libnfs-2.0.0.tar.gz"
  source_sha256 "7ea6cd8fa6c461d01091e584d424d28e137d23ff4b65b95d01a3fd0ef95d120e"

  
  depends_on "libtool" => :build
  depends_on "automake" => :build
  depends_on "autoconf" => :build

  def self.build
    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
  end

  def self.install
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <nfsc/libnfs.h>

      int main(void)
      {
        int result = 1;
        struct nfs_context *nfs = NULL;
        nfs = nfs_init_context();

        if (nfs != NULL) {
            result = 0;
            nfs_destroy_context(nfs);
        }

        return result;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lnfs", "-o", "test"
    system "./test"
  end
end
