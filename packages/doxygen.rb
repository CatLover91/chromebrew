require 'package'

class Doxygen < Package
  description 'Generate documentation for several programming languages'
  homepage 'http://doxygen.org/'
  version '1.8.13'
  source_url 'https://github.com/doxygen/doxygen/archive/Release_1_8_13.tar.gz'
  source_sha256 ''

  binary_url ({ })
  binary_sha256 ({ })

  depends_on 'cmake' => :build

  def self.build
    system 'mkdir out'
    Dir.chdir 'out' do
      args = "-DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=#{CREW_PREFIX} -DCMAKE_INSTALL_LIBDIR=#{CREW_DEST_LIB_PREFIX}"
      # args << "-Dbuild_wizard=ON" if build.with? "qt"
      
      system "cmake", "..", *args
      system "cmake --build . --config Release --target install"
    end
  end
    
  def self.install
    Dir.chdir 'out' do
	    system "cmake -DCMAKE_INSTALL)PREFIX=#{CREW_DEST_PREFIX} -DCMAKE_INSTALL_LIBDIR=#{CREW_DEST_LIB_PREFIX} -P cmake_install.cmake"
    end
  end
end
