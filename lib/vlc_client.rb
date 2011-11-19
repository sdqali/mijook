require 'rubygems'
require 'cgi'
require 'httpclient'
require 'rexml/document'

class VlcClient
  def initialize host, port
    @host = host
    @port = port
    @client  = HTTPClient.new
  end

  def enqueue video_url
    enqueue_url = command(:command => "in_enqueue",
                          :input => url_for(video_url))
    post(enqueue_url)
  end

  def play
    resp = get(status_url)
    if get_state(resp) != "playing"
      post(command(:command => "in_play"))
    end
  end

  def pause
    post(command(:command => "pl_pause"))
  end
  
  def stop
    post(command(:command => "pl_stop"))
  end

  def next
    post(command(:command => "pl_next"))
  end

  def prev
    post(command(:command => "pl_previous"))
  end

  def empty
    post(command(:command => "pl_empty"))
  end

  def vol_up
    post(command(:command => "volume", :val => "%2B20"))
  end

  def vol_down
    post(command(:command => "volume", :val => "-20"))
  end

  def command(args)
    command_string = args.collect { |k,v| "#{k}=#{v}" }.join("&")
    "#{base_url}/requests/status.xml?#{command_string}"
  end

  def url_for video_url
    return "" unless video_url
    CGI.escape(video_url)
  end

  def base_url
    "http://#{@host}:#{@port}"
  end

  def post url
    @client.post url
  end

  def status_url
    "#{base_url}/requests/status.xml"
  end

  def get url
    @client.get(url).body
  end

  def get_state resp
    doc = REXML::Document.new(resp)
    REXML::XPath.first(doc, "//state").text
  end
end
