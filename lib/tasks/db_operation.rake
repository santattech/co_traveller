namespace :db_operation do
  desc "taking backup of each tables"
  task :take_backup, [] => [:environment] do |t, args|
    tables = ActiveRecord::Base.connection.tables
    db_name = ActiveRecord::Base.connection_config[:database]
    host = ActiveRecord::Base.connection_config[:host]
    username = ActiveRecord::Base.connection_config[:username]
    port = ActiveRecord::Base.connection_config[:port]

    folder_name = "db_backup_of_#{db_name}_#{port}_#{Date.today.to_s}"
    Dir::chdir Rails.root
    Dir::mkdir folder_name unless File.directory?(folder_name)
    Dir::chdir folder_name

    tables.each do |table|
      cmd = nil
      puts "taking backup of table: #{table}"
      cmd = "pg_dump -h #{host} -p #{port} -U #{username} -Fc #{db_name} -t #{table} > #{table}.dump"
      system cmd
      cmd = "pg_dump -h #{host} -p #{port} -U #{username} -d #{db_name} -t #{table} > #{table}.sql"
      system cmd

      model_files = Dir[Rails.root + 'app/models/*.rb']

      if File.exists?((Rails.root + "app/models/#{table.singularize}.rb").to_s)
        CsvService.to_csv(table.singularize.titleize.gsub(" ", ""))
      end
    end

    puts "taking backup of DB"
    cmd = "pg_dump -h #{host} -p #{port} -U #{username} -Fc #{db_name} > #{db_name}.dump"
    puts cmd
    system cmd
    cmd = "pg_dump -h #{host} -p #{port} -U #{username} -d #{db_name} > #{db_name}.sql"
    puts cmd
    system cmd
  end

  desc "purging DB"
  task :purge, [] => [:environment] do |t, args|
    puts "cleaning up all data"
    DatabaseCleaner.clean_with(:truncation)
  end

  desc "Restore certain tables"
  task :restore_tables, [] => [:environment] do |t, args|
    db_name = ActiveRecord::Base.connection_config[:database]
    host = ActiveRecord::Base.connection_config[:host]
    username = ActiveRecord::Base.connection_config[:username]
    port = ActiveRecord::Base.connection_config[:port]
    Dir::chdir Rails.root
    folder_name = "db_backup_of_#{db_name}_#{port}_#{Date.today.to_s}"
    Dir::chdir folder_name
    puts "Restore schema migrations"
    cmd = "psql -h #{host} -p #{port} -U #{username} -d #{db_name} -f schema_migrations.sql"

    puts cmd
    system cmd
    arr = [Country.table_name, City.table_name, Location.table_name, Depot.table_name, ParkingLot.table_name]
    arr = []

    arr.each do |table|
      Dir::chdir Rails.root
      Dir::chdir folder_name
      puts "restoring data for #{table}"
      #cmd = "pg_restore -h localhost -p 5432 -U postgres -d carbooking_dev_test #{table}.dump"
      cmd = "psql -h #{host} -p #{port} -U #{username} -d #{db_name} -f #{table}.sql"

      puts cmd
      system cmd

      # to restore from csv
      # model_name = table.singularize.camelize
      # file = File.open(Rails.root + "db_backup_#{Date.today.to_s}" + "#{model_name}.csv")
      # CsvService.import(model_name, file)
    end

    puts "Update Depot available count field"
    Depot.update_all(available_vehicle_count: 0)
    puts "Execute seed data"
    Rails.application.load_seed
  end

  private

  def with_config
    yield Rails.application.class.parent_name.underscore,
          ActiveRecord::Base.connection_config[:host],
      ActiveRecord::Base.connection_config[:database],
      ActiveRecord::Base.connection_config[:username]
  end
end
