Rails.application.routes.draw do
  Rails.application.routes.draw do
    root "weather#index"
    get "/weather", to: "weather#show", as: 'weather'
  end
end
