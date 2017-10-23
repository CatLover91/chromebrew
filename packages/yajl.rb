require 'package'

class Yajl < Package
  description "Yet Another JSON Library"
  homepage "https://lloyd.github.io/yajl/"
  version "2.1.0"
  souce_url "https://github.com/lloyd/yajl/archive/2.1.0.tar.gz"
  source_sha256 "3fb73364a5a30efe615046d07e6db9d09fd2b41c763c5f7d3bfb121cd5c5ac5a"

  
  # Configure uses cmake internally
  depends_on "cmake" => :build

  def self.build
    ENV.deparallelize

    system "cmake", ".", *std_cmake_args
  end

  def self.install
    system "make", "install"
    (include/"yajl").install Dir["src/api/*.h"]
  end

  test do
    output = pipe_output("#{bin}/json_verify", "[0,1,2,3]").strip
    assert_equal "JSON is valid", output
  end
end
