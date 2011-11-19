require 'rubygems'
require 'cgi'
require 'httpclient'

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

  def play video_url=nil
    play_url =  command(:command => "in_play",
                        :input => url_for(video_url))
    post(play_url)
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
end
