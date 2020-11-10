class TravelController < ApplicationController
  def index
  end

  	def search
	    countries = find_country(params[:country])
	    unless countries
	      flash[:alert] = 'Country not found'
	      return render action: :index
	    end
	    @country = countries.first
	    @weather = find_weather(@country['capital'], @country['alpha2Code'])
	  end
#this is a "freemium" endpoint therefore I don't have complete access
	  def find_weather(city, country_code)
    query = URI.encode("#{city},#{country_code}")
    request_api(
      "https://community-open-weather-map.p.rapidapi.com/forecast?q=#{query}"
    )
  	end

	private
  	def request_api(url)
    response = Excon.get(
      url,
      headers: {
        'X-RapidAPI-Host' => URI.parse(url).host,
        #RAPIDAPI_API_KEY= 9ef0f95683msh74865d983678d77p17a924jsn005dbcf8bf9f
        #ENV.fetch('KEY_HERE')
        'X-RapidAPI-Key' => '3f5c0e8747msha687f45b66a7728p13eeedjsne26a41a665a2'
      }
    )
    return nil if response.status != 200
    JSON.parse(response.body)
  end
  def find_country(name)
    request_api(
      "https://restcountries-v1.p.rapidapi.com/name/#{URI.encode(name)}"
    )
  end

end