require "sidekiq-scheduler"

Sidekiq.configure_server do |config|
  config.on(:startup) do
    schedule_file = "config/sidekiq.yml"

    if File.exist?(schedule_file)
      puts "Cargando schedule desde #{schedule_file}"
      Sidekiq::Scheduler.reload_schedule!
    else
      puts "No se encontró el archivo config/sidekiq.yml"
    end
  end
end