module Winch
  require "open3"

  class Builder

    BUILD_DIR = "#{ENV["HOME"]}/winch/build"
    DOCKER_HOST = "192.168.56.4"

    def initialize
    end

    def bootstrap(name)
      base = "#{BUILD_DIR}/#{name}"

      if File.exist?(base)
        hl_error "#{name} already exists."
        return
      end

      puts "Bootstapping #{name}..."

      dockerfile = File.join(base, "Dockerfile")
      up = File.join(base,"up")
      down = File.join(base, "down")
      hooks_dir = File.join(base, "hooks")
      up_dir = File.join(hooks_dir, "up")
      down_dir = File.join(hooks_dir, "down")
      create_msg = "    create: ".green

      Dir::mkdir(base)

      File.open(dockerfile, "w") do |f|
        f.write "From ubuntu\n"
      end
      puts create_msg + dockerfile

      File.open(up, "w") do |f|
        f.write "docker run -d w(image)\n"
      end
      puts create_msg + up

      File.open(down, "w") do |f|
        f.write "docker stop w(cid)\n"
      end
      puts create_msg + down

      if Dir::mkdir(hooks_dir)
        Dir::mkdir(up_dir)
        Dir::mkdir(down_dir)
        puts create_msg + hooks_dir
        puts create_msg + up_dir
        puts create_msg + down_dir
      end

    end

    def build(name)
      Dir.chdir("#{BUILD_DIR}/#{name}") do
        cmd = "docker -H #{DOCKER_HOST} build -t #{name} ."
        Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|

          if wait_thr.value == 0
            while line = stdout.gets
              hl_info line
            end
          else
            hl_warn "Error to build #{name}"

            hl_info "<>" * 30
            while line = stderr.gets
              hl_error line
            end
          end
        end
      end
    end
  end
end