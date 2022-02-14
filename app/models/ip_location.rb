require "resolv"
class IpLocation < ApplicationRecord
  # before_save :check_if_already_exist
  # before_save :is_url_or_ip


  def check_if_already_exist
    ip_location = IpLocation.find_or_create_by(:url => url)
    if ip_location.present?
      return
    else 
      IpLocation.create
    end
  end

  def is_url_or_ip
    iplocation = IpLocation.find_by url =~ Resolv::IPv4::Regex ? true : false
    if iplocation == true
      puts("Ip address")
    else
      puts("its url")
    end
  end
end
