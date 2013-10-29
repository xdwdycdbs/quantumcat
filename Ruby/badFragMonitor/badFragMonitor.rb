require 'inotify'
require 'digest'
require 'openssl'
require 'socket'

DISK = ARGV[0]

def sha1sum(filename)
  digest = OpenSSL::Digest::SHA1.new

  File.open(filename, 'rb') do |f|
    while buffer = f.read(1024 * 1024)
      digest << buffer
    end
  end

  return digest.hexdigest
end

def scanDisk
  sha1sumStr = "find #{DISK} -name \"*.dat\" -exec sha1sum {} \\; | awk '{arr[\$2] = \$1} END{for(i in arr){l=split(i, a, \"/\"); if(substr(a[l], 0, 40)!=arr[i]) {print \"Bad Fragment:\", i}}}'"
  result = `#{sha1sumStr}`

  for item in result.split("\n")
    p item
  end
end

def doEvent(i)
  t = Thread.new do
    i.each_event do |ev|
      l = ev.name.length
      hash = ev.name.scan(/[a-f0-9]{40}/)
      filename = DISK + hash[1][0..1] + "/" + hash[1][2..3] + "/" + ev.name
      if hash[0] != sha1sum(filename)
        p "Bad fragment:#{filename}"
      end
    end
  end

  return t
end

def init(i)
  dir = Dir.open(DISK)
  path = ""

  begin
    dir.each {|file|
      if file != "." && file != ".." && File.directory?(DISK + file)
        path = DISK + file
        subdir = Dir.open(path)
        subdir.each {|subfile|
          if subfile != "." && subfile != ".."
            fullpath = path + "/" + subfile
            i.add_watch(fullpath, Inotify::MOVE | Inotify::MODIFY)
          end
        }
        subdir.close
      end
    }
  ensure
    dir.close
  end
end

i = Inotify.new
scanDisk
init(i)
monitor = doEvent(i)
monitor.join
