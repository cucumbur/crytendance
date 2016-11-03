require "kemal"

attendees = Array(Hash(String, String)).new

# Matches GET "http://host:port/"
get "/" do
  "Hello World!"
end

get "/save" do
  filename = "attendees-" + Time.now.to_s("%Y-%m-%d")
  File.write(filename, attendees) # => "2015-10-12", attendees)
  puts "File saved to " + filename
end

post "/attendance" do |env|
  if (!(env.params.body.has_key?("netid") && !env.params.body["netid"].empty?) || !env.params.body.has_key?("github"))
    puts "Attendance submission failed"
    "Attendance submission failed"
  else
    submission = {"netid" => env.params.body["netid"], "github" => env.params.body["github"]} of String => String
    attendees << submission
    puts "Attendance submission recieved for " + submission["netid"]
    "Attendence received!"
  end
end

Kemal.run(3001)
