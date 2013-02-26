require 'bundler'
Bundler.require(:default)
#io = WiringPi::GPIO.new

get '/' do
  haml :home
end

get '/lamp' do
  @status = "On"
  haml :lamp
end

post '/lamp' do
  #io.mode(12,OUTPUT)
  if params[:mode]=='on'
    #io.write(12,HIGH)
    @status = "On"
  elsif params[:mode]=='off'
    #io.write(12,LOW)
    @status = "Off"
  elsif params[:mode]=='toggle'
    #io.write(12,!WiringPi.read(12))
    @status = "On"
  end
  haml :lamp
end

get '/pandora' do
  if `pgrep pianobar`.empty?
    `tmux new -d pianobar`
  end
  haml :pandora
end

get '/song_info' do
  @info = JSON.parse(File.read(File.expand_path("~/.config/pianobar/scripts/out")))
  return "You are listening to #{@info["title"]} by #{@info["artist"]}"
end

post '/send_command' do
  return unless params[:cmd].class==String && params[:cmd].length==1
  return if %w(a c d j r s =).include?(params[:cmd])
  `echo -n "#{params[:cmd]}" >> ~/.config/pianobar/ctl`
end


