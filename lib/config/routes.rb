Rubee::Router.draw do |router|
  router.get('/', to: 'welcome#show') # override it for your app

  router.get('/users', to: 'users#index', react: { view_name: 'user.tsx' })
end
