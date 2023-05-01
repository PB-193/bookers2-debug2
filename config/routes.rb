Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users
  root to: "homes#top"
  get "home/about"=>"homes#about"

  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
    resources :book_comments, only: [:create, :destroy]
    resource :favorites, only: [:create, :destroy]
  end
  resources :users, only: [:index,:show,:edit,:update] do
    resource :relationships, only: [:create, :destroy]
  	get 'followings' => 'relationships#followings', as: 'followings'
  	get 'followers' => 'relationships#followers', as: 'followers'
  end

  
  
  # いいね機能の場合は「1人のユーザーは1つの投稿に対して1回しかいいねできない」という仕様であるため、
  # destroyをする際にもユーザーidと投稿(book)idが分かれば、どのいいねを削除すればいいのかが特定できます。
  # そのため、いいねのidはURLに含める必要がない(params[:id]を使わなくても良い)ため、
  # resourcesではなくresourceを使ってURLに/:idを含めない形にしています。
  
  resources :users, only: [:index,:show,:edit,:update]

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
