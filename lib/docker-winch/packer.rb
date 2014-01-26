module Winch
  require "open3"

  class Packer

    REPO_DIR = "#{ENV["HOME"]}/winch/repo"
    BUILD_DIR = "#{ENV["HOME"]}/winch/build"
    DOCKER_HOST = "192.168.56.4"

    def initialize
    end

    def pack(name)
      Dir.chdir("#{BUILD_DIR}/#{name}") do
        container = File.join(BUILD_DIR, name, "#{name}.container")
        cmd = "tar zcvf #{container} --exclude #{container} ./*"
        Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|

          if wait_thr.value == 0
            puts "    create: ".green + "#{container}"
          else
            hl_warn "Error to pack #{name}"

            hl_info "<>" * 30
            while line = stderr.gets
              hl_error line
            end
          end
        end
      end
    end

    def push(name)
      container_file = File.join(BUILD_DIR, name, "#{name}.container")

      unless File.exists?(container_file)
        puts "    error: ".red + "#{container_file} does not exist"
        return
      end

      Dir.chdir("#{REPO_DIR}") do
        cmd = "cp #{container_file} . && git add ./#{name}.container && git commit -m 'update container' && git push -u origin master"

        Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|

          if wait_thr.value == 0
            while line = stdout.gets
              hl_info line
            end
          else
            hl_warn "Error to pack #{name}"

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