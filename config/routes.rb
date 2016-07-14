Rails.application.routes.draw do
  resources :emergencies, except: [:new], param: :code
  resources :responders, except: [:new], param: :name
end
