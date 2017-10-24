require 'package'

class Glfw < Package
  description "Multi-platform library for OpenGL applications"
  homepage "http://www.glfw.org/"
  version "3.2.1"
  source_url "https://github.com/glfw/glfw/archive/3.2.1.tar.gz"
  source_sha256 "e10f0de1384d75e6fc210c53e91843f6110d6c4f3afbfb588130713c2f9d8fe8"

  head "https://github.com/glfw/glfw.git"

  
  option "without-shared-library", "Build static library only (defaults to building dylib only)"
  option "with-examples", "Build examples"
  option "with-test", "Build test programs"

  depends_on "cmake" => :build

  deprecated_option "build-examples" => "with-examples"
  deprecated_option "static" => "without-shared-library"
  deprecated_option "build-tests" => "with-test"
  deprecated_option "with-tests" => "with-test"

  def self.build
    args = std_cmake_args + %w[
      -DGLFW_USE_CHDIR=TRUE
      -DGLFW_USE_MENUBAR=TRUE
    ]
    args << "-DBUILD_SHARED_LIBS=TRUE" if build.with? "shared-library"
    args << "-DGLFW_BUILD_EXAMPLES=TRUE" if build.with? "examples"
    args << "-DGLFW_BUILD_TESTS=TRUE" if build.with? "test"
    args << "."

    system "cmake", *args
  end

  def self.install
    system "make", "install"
    libexec.install Dir["examples/*"] if build.with? "examples"
    libexec.install Dir["tests/*"] if build.with? "test"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #define GLFW_INCLUDE_GLU
      #include <GLFW/glfw3.h>
      #include <stdlib.h>
      int main()
      {
        if (!glfwInit())
          exit(EXIT_FAILURE);
        glfwTerminate();
        return 0;
      }
    EOS

    if build.with? "shared-library"
      system ENV.cc, "test.c", "-o", "test",
             "-I#{include}", "-L#{lib}", "-lglfw"
    else
      system ENV.cc, "test.c", "-o", "test",
             "-I#{include}", "-L#{lib}", "-lglfw3",
             "-framework", "IOKit",
             "-framework", "CoreVideo",
             "-framework", "AppKit"
    end
    system "./test"
  end
end