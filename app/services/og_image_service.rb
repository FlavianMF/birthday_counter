class OgImageService
  def self.generate_data(event, milestone_type, metadata = {})
    data = {
      event_name: event.name,
      host_name: event.host.name,
      milestone_type: milestone_type,
      timestamp: Time.current.to_i
    }

    case milestone_type
    when 'message_count'
      data[:value] = event.messages.count
      data[:text] = "We hit #{data[:value]} messages!"
    when 'ranking'
      data[:user_name] = metadata[:user_name]
      data[:rank] = metadata[:rank]
      data[:text] = "#{data[:user_name]} is ranked ##{data[:rank]}!"
    else
      data[:text] = "A special moment at #{event.name}!"
    end

    data
  end

  def self.image_url(event, milestone_type, metadata = {})
    # In a real implementation, this would point to a service that renders HTML to PNG
    # e.g., using a library like Puppeteer or a dedicated microservice.
    data = generate_data(event, milestone_type, metadata)
    query = data.to_query
    "/api/v1/og_image/#{event.id}?#{query}"
  end
end
