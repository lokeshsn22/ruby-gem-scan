require 'json'
require "csv" 
require 'net/http'


file='Gemfile.lock'
final_package_details = []
File.readlines(file).each do |line|
  #to delete spaces
  line.delete(' ')

  words_arr = line.split('(')  
  gemVersion = words_arr[1].to_s
 
if gemVersion.length >=0 && !words_arr[1].nil?
    firstCharcter = gemVersion.slice(0)
    gemName = words_arr[0].delete(' ')
    gemVersionsplit = gemVersion.split(')')
    gemVersion = gemVersionsplit[0]    

    puts " Fetching data for #{gemName} ....."
    sleep 1
    #to find the latest version
    uri = URI("https://rubygems.org/api/v1/gems/#{gemName}")
     
    res = Net::HTTP.get_response(uri)
    response_json = JSON.parse(res.body)
    gemLatestVersion = response_json['version']
    

  if (firstCharcter === "~" ) 
    packageLevel = "SubLevel" 
  elsif (firstCharcter === "=" ) 
    packageLevel = "SubLevel" 
  elsif (firstCharcter === ">" )
    packageLevel = "SubLevel" 
  else  
    packageLevel = "TopLevel" 
  end
  final_package_details << {"gem_name" => gemName, "gem_version" => gemVersion,"latest_version"=> gemLatestVersion, "package_level" => packageLevel }
end  
end


CSV.open("RISK_OSS.csv", "w") do |csv|
    csv << ["Gem Name", "Version Used", "New Version", "Package Level"]
    final_package_details.each do |final_package_detail|
        csv << [ final_package_detail["gem_name"], final_package_detail["gem_version"],final_package_detail['latest_version'] ,final_package_detail["package_level"    ]]
    end    
end

 



 


  