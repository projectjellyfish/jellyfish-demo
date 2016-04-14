JellyfishDemo::Engine.routes.draw do
  resources :providers, only: [] do
    member do
      get :deprovision
    end
  end
end
