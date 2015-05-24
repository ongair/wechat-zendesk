require 'grape'

module Wechat
  class API < Grape::API
    version 'v1', using: :header, vendor: 'ongair'
    format :json
    prefix :api

    resource :connections do
      desc "Return if we are working or not"
      get :status do
        true
      end
    end
  end
end