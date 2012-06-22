Pod::Spec.new do |s|
  s.name         = 'DTCStuff-objc'
  s.version      = '0.1'
  s.license       = { :type => 'MIT',
                      :text => %Q|Copyright (c) 2011 Eric Doughty-Papassideris\n\n| +
                              %Q|Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\n| +
                               %Q|The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\n| +
                               %Q|THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE| }
  s.summary      = 'Utility code re-used across objc projects'
  s.homepage     = 'https://github.com/drentec/DTCStuff-objc'
  s.author       = 'Dren Tec SAS'
  # s.source       = { :git => 'git://github.com/drentec/DTCStuff-objc.git', :tag => 'v0.1' }
  s.source       = { :git => '/Users/eric/Documents/Private/Paris/DrenTec/old_data/DrenTec/DTCStuff-iOS/DTCStuff-objc/' }
  s.source_files = 'Foundation/*'
  s.clean_paths  = ["*.xcodeproj", "*.xcworkspace"]
  s.subspec 'iOS' do |iOS|
    iOS.source_files = 'iOS/*'
    iOS.platform = :ios, '5.0'
    iOS.dependency 'Reachability', '~> 3.0.0'
    iOS.subspec 'StyleExt' do |t20|
      t20.source_files = 'iOS-StyleExt/*'
      t20.dependency 'Three20Lite', '~> 2.0.0'
    end
  end
end