def populate_data
  load_password

  # put your populate steps here

end


def load_password
  password_file = File.expand_path("#{Rails.root}/tmp/env_config/sample_password.yml", __FILE__)
  if File.exists? password_file
    puts "Using sample user password from #{password_file}"
    password = YAML::load_file(password_file)
    @password = password[:password]
    return
  end

  if Rails.env.development?
    puts "#{password_file} missing.\n" +
         "Set sample user password:"
          input = STDIN.gets.chomp
          buffer = Hash[:password => input]
          Dir.mkdir("#{Rails.root}/tmp", 0755) unless Dir.exists?("#{Rails.root}/tmp")
          Dir.mkdir("#{Rails.root}/tmp/env_config", 0755) unless Dir.exists?("#{Rails.root}/tmp/env_config")
          File.open(password_file, 'w') do |out|
            YAML::dump(buffer, out)
          end
    @password = input
  else
    raise "No sample password file provided, and it is required for any environment that isn't development\n" +
              "Use capistrano's deploy:populate task to generate one"
  end

end

