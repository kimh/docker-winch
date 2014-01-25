module Winch
  class Builder
    def initialize
    end

    def bootstrap(name)
      if File.exist?(name)
        hl_error "#{name} already exists."
        return
      end

      puts "Bootstapping #{name}..."

      base = "./#{name}"
      dockerfile = File.join(base, "Dockerfile")
      up = File.join(base,"up")
      down = File.join(base, "down")
      hooks_dir = File.join(base, "hooks")
      up_dir = File.join(hooks_dir, "up")
      down_dir = File.join(hooks_dir, "down")
      create_msg = "    create: ".green

      Dir::mkdir(name)

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

    def build
    end
  end
end