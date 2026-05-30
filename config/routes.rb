# config/routes.rb
Rails.application.routes.draw do
  # GhRev landing page — single-page marketing site.
  root 'landing#index'

  # Health check / fallback for any other path → bounce to root.
  match '*unmatched', to: redirect('/'), via: :all, constraints: lambda { |req| !req.path.start_with?('/rails/') && !req.path.start_with?('/assets/') }
end
