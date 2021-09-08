Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    devise_for :users, controllers: {sessions: "sessions", registrations: "users"}
    resources :users, except: :new
    resources :courses, except: %i(new edit) do
      member do
        patch :finish
      end
    end
    resources :subjects, except: :index
    resources :tasks, except: %i(index show)
    resources :enrollments, only: %i(show create destroy)
    resources :supervisions, only: %i(create destroy)
    resources :reports
    resources :statuses, except: :index
  end
end
