Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'information#data'

  resources :tree_metric_results, only: [] do
    member do
      get 'repository_id'
      get 'metric_configuration'
      get 'descendant_values'
    end
  end

  resources :hotspot_metric_results, only: [] do
    member do
      get 'repository_id'
      get 'metric_configuration'
      get 'related_results'
    end
  end

  get 'metric_results/:id/module_result' => 'metric_results#module_result', as: 'metric_result_module_result'

  get 'module_results/:id' => 'module_results#get'
  get 'module_results/:id/exists' => 'module_results#exists'
  get 'module_results/:id/metric_results' => 'module_results#metric_results'
  get 'module_results/:id/hotspot_metric_results' => 'module_results#hotspot_metric_results'
  get 'module_results/:id/descendant_hotspot_metric_results' => 'module_results#descendant_hotspot_metric_results'
  get 'module_results/:id/children' => 'module_results#children'
  get 'module_results/:id/repository_id' => 'module_results#repository_id'
  get 'module_results/:id/kalibro_module' => 'module_results#kalibro_module'

  resources :kalibro_modules, only: [:index, :show]
  get 'kalibro_modules/:id/module_results' => 'kalibro_modules#module_results'
  get 'kalibro_modules/:id/exists' => 'kalibro_modules#exists'

  resources :projects, except: [:index, :new, :edit]
  get 'projects/:id/exists' => 'projects#exists'
  get 'projects' => 'projects#all'
  get 'projects/:id/repositories' => 'projects#repositories_of'

  get 'repositories/types' => 'repositories#types'
  get 'repositories/:id/exists' => 'repositories#exists'
  get 'repositories/:id/process' => 'repositories#process_repository'
  get 'repositories/:id/cancel_process' => 'repositories#cancel_process'
  get 'repositories/:id/has_processing' => 'repositories#has_processing'
  get 'repositories/:id/has_ready_processing' => 'repositories#has_ready_processing'
  get 'repositories/:id/last_ready_processing' => 'repositories#last_ready_processing'
  get 'repositories/:id/last_processing_state' => 'repositories#last_processing_state'
  get 'repositories/:id/cancel_process' => 'repositories#cancel_process'
  post 'repositories/:id/first_processing(/:after_or_before)' => 'repositories#first_processing_in_time' # after_or_before is optional for this route
  post 'repositories/:id/last_processing(/:after_or_before)' => 'repositories#last_processing_in_time' # after_or_before is optional for this route
  post 'repositories/:id/has_processing/:after_or_before' => 'repositories#has_processing_in_time'
  post 'repositories/:id/module_result_history_of' => 'repositories#module_result_history_of'
  post 'repositories/:id/metric_result_history_of' => 'repositories#metric_result_history_of'
  post 'repositories/branches' => 'repositories#branches'
  resources :repositories , except: [:new, :edit]

  get 'metric_collector_details' => 'metric_collectors#index'
  post 'metric_collector_details/find' => 'metric_collectors#find'
  get 'metric_collector_details/names' => 'metric_collectors#all_names'

  get 'processings/:id/process_times' => 'processings#process_times'
  get 'processings/:id/error_message' => 'processings#error_message'
  get 'processings/:id' => 'processings#show'
  get 'processings/:id/exists' => 'processings#exists'

  resources :process_times, only: [:index, :show]
  get 'process_times/:id/processing' => 'process_times#processing'

  post 'tests/clean_database' => 'tests#clean_database' unless Rails.env == "production"end
