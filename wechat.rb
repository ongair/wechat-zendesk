require 'grape'
require 'digest/sha1'
require 'wechat'
require 'nokogiri'

module Wechat
  class API < Grape::API
    version 'v1', using: :header, vendor: 'ongair'
    # format :json
    prefix :api

    resource :connections do
      desc "Return if we are working or not"
      get :status do
        content_type 'application/json'
        true
      end

      get :token do
        # /api/connections/token?signature=7e9ad5445868d6f557be6bad1e56718f62d74150&echostr=479925080936111095&timestamp=1432486903&nonce=1269202536
        content_type 'text/plain'
        token = '1234567890'
        nonce = params[:nonce]
        signature = params[:signature]
        echostr = params[:echostr]
        timestamp = params[:timestamp]

        array = [token, timestamp, nonce].sort!
        check_str = array.join

        digest = Digest::SHA1.hexdigest check_str
        # digest == signature
        resp = echostr if digest == signature
        body resp
      end

      post :token do
        content_type 'application/xml'

        puts 'I have been notified'
        # format :xml
        raw_xml = request.body.read
        notification = Notification.new(raw_xml)
        puts raw_xml
        # body "<xml></xml>"
        doc = Nokogiri::XML(raw_xml)
        # doc

        response = "<xml>
          <ToUserName><![CDATA[#{notification.from}]]></ToUserName>
          <FromUserName><![CDATA[gh_283218bf272e]]></FromUserName>
          <CreateTime>#{Time.now.to_i}</CreateTime>
          <MsgType><![CDATA[text]]></MsgType>
          <Content><![CDATA[#{notification.content}]]></Content>
          </xml>"
        # Nokogiri::XML(response)
        body "<xml></xml>"
      end
    end
  end
end