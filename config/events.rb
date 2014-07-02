WebsocketRails::EventMap.describe do
  subscribe :client_connected,    to: ChatController, with_method: :client_connected
  subscribe :new_message,         to: ChatController, with_method: :new_message
  subscribe :new_user,            to: ChatController, with_method: :new_user
  subscribe :change_username,     to: ChatController, with_method: :change_username
  subscribe :client_disconnected, to: ChatController, with_method: :delete_user

  subscribe :init_map,            to: MapEventsController, with_method: :init_map

  # You can use this file to map incoming events to controller actions.
  # One event can be mapped to any number of controller actions. The
  # actions will be executed in the order they were subscribed.
  #
  # Uncomment and edit the next line to handle the client connected event:
  #   subscribe :client_connected, :to => Controller, :with_method => :method_name
  #
  # Here is an example of mapping namespaced events:
  #   namespace :product do
  #     subscribe :new, :to => ProductController, :with_method => :new_product
  #   end
  # The above will handle an event triggered on the client like `product.new`.
end
