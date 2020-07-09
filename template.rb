gem_group :development, :test do
  gem 'rspec-rails'
end

gem_group :rubocop do
  gem 'rubocop'
  gem 'rubocop-performance'
  gem 'rubocop-rails'
end

file '.rubocop.yml', <<-YML
  require:
    - rubocop-performance
    - rubocop-rails

  AllCops:
    Exclude:
      - 'Rakefile'
      - 'bin/*'
      - 'config.ru'
      - 'config/**/*'
      - 'db/schema.rb'
      - 'db/seeds.rb'
      - 'node_modules/**/*'

  Style/ClassAndModuleChildren:
    AutoCorrect: true   
  
  Style/Documentation:
    Enabled: false
YML

after_bundle do
  check_git_user_config
  initialise_rspec
  auto_correct_rubocop_offenses
  initial_git_commit
end

def check_git_user_config
  git config: 'user.name'
  git config: 'user.email'
  if no?("Use existing user?")
    user_name = ask('Enter new user name:')
    user_email = ask('Enter new user email:') 
    git config: "user.name '#{user_name}'"
    git config: "user.email '#{user_email}'"
  end
end

def initialise_rspec
  generate 'rspec:install'
end

def auto_correct_rubocop_offenses
    run 'bundle exec rubocop -A'
end

def initial_git_commit
  git :init
  git add: '.'
  git commit: "-a -m 'Initial commit'"
end