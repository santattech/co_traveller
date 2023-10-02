class LastLocationMail
  include Delayed::RecurringJob
  run_every 5.minutes
  # run_at '11:00am'
  timezone 'Kolkata'
  queue 'slow-jobs'

  def perform
    # Do some work here!
    Rails.logger.info "Starting LastLocationMail..."
    last_location = Location.order(:id).last
    lat = last_location.lat
    lng = last_location.lng
    time = last_location.created_at.in_time_zone('Kolkata')
    url = "http://maps.google.com/maps?z=18&t=m&q=#{last_location.lat},#{last_location.lng}"
    location_str = ''
    results = Geocoder.search([lat, lng]) rescue nil
    location_str = results.first.address if results.present?
    last_location.update(other_info: location_str) if location_str.present?

    smtp_settings = {
      user_name: 'akbpdcl',
      password: ENV['SMTP_PASSWORD'],
      address: 'smtp.gmail.com',
      domain: 'smtp.gmail.com',
      port: 587,
      authentication: 'login',
      # /tls: true,
      enable_starttls_auto: true
    }



    ################################################################################
    ############# SEND MAIL ########################################################
    ################################################################################
    ################################################################################

    # Mail meta data
    from_name = 'akbpdcl@gmail.com'
    from_mail = 'akbpdcl@gmail.com'
    to_name = 'Anup'
    to_mail = ['santattech@gmail.com', 'akbpdcl@gmail.com', 'b.debapriya90@gmail.com']
    subject = 'Santanu last location'

    # rubocop:disable Layout/LineLength
    str = "<p style='font-size:16px;padding:5px;border:1px solid #782020;'>
             Ritam was at near #{location_str} with latitude, longitude: #{lat}, #{lng} at the time of: #{time}
           </p>"

    str = str + "<p> Meta data of location: #{results.to_s} </p>"

    str = str + "<p style='font-size:16px;padding:5px;border:1px solid #782020;'>
                  Please click here #{url} to get the location in Google Map.
                </p>"
    # rubocop:enable Layout/LineLength

    message = '<h3>
                Dear Santanu,
                </h3>
                <p>
                  ' + str + '
                </p>
    '
    

    footer = '<p style="font-size:20px;font-style:italic;margin-top:45px;color:coral;">
                Best Regards,
                <br/>
                Ruby Code
              </p>'
    message += footer

    # Servers and Authentication
    smtp_domain = smtp_settings[:domain]

    # The subject and the message
    t = Time.now

    # The date/time should look something like: Thu, 03 Jan 2006 12:33:22 -0700
    msg_date = t.strftime('%a, %d %b %Y %H:%M:%S +0800')

    # Compose the message for the email
    puts 'Compose the message for the email'
    msg = <<~END_OF_MESSAGE
      Date: #{msg_date}
      From: #{from_name} <#{from_mail}>
      MIME-Version: 1.0
      Content-type: text/html
      To: #{to_name} <#{to_mail}>
      Subject: #{subject}
      #{message}
    END_OF_MESSAGE

    puts 'start sending mail'
    puts msg

    begin
      smtp = Net::SMTP.new(smtp_settings[:address], smtp_settings[:port])
      smtp.enable_starttls
      smtp.start(smtp_domain, smtp_settings[:user_name], smtp_settings[:password],
                 smtp_settings[:authentication]) do |sm|
        sm.send_message msg, from_mail, to_mail
      end
    rescue StandardError => e
      raise "Exception occured: #{e} "
    end


    Rails.logger.info "Here is the location: #{lat}, #{lng}"
    Rails.logger.info "End of LastLocationMail..."
  end
end