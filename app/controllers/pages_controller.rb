require 'open-uri'
require 'Nokogiri'

class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[home]

  def home
  end

  def dashboard
    @artists = current_user.artists
    @albums_to_listen = find_albums_to_listen
  end

  def tick
    record = UserAlbum.where(album: params[:id], user: current_user)
    record.update(played: true)
    redirect_to :dashboard
  end

  def search
  end

  def scraping
    artist = params[:artist][:url]
    instagram = params[:artist][:instagram]
    bio = params[:artist][:bio]

    redirect_to "/result/#{artist}?instagram=#{instagram}&bio=#{bio}"
  end

  def result
    artist = params[:name]
    @instagram = "https://www.instagram.com/#{params[:instagram]}"
    @url = "https://www.allmusic.com/artist/#{artist}"

    @info = retrieve_info_from_web(@url)
    @bio = params[:bio]
  end

  private

  def find_albums_to_listen
    records = UserAlbum.where(played: false, user: current_user)
    records.map do |record|
      record.album
    end
  end

  # Using AllMusic website
  def retrieve_info_from_web(url)
    html_file = open(url).read
    html_doc = Nokogiri::HTML(html_file)
    result = {}

    # Artist
    result[:name] = html_doc.search('.artist-name').text.strip
    result[:description] = html_doc.search('.biography span').first.text.strip
    result[:photo] = html_doc.search('.artist-contain img').attribute('src').value

    # Performer
    unless html_doc.search('.aliases div').first.nil?
      result[:full_name] = html_doc.search('.aliases div').first.text.strip
    else
      result[:full_name] = result[:name]
    end
    result[:date_of_birth] = Date.parse(html_doc.search('.birth a').first.text.strip)
    result[:birth_location] = html_doc.search('.birth a')[1].text.strip

    result
  end
end
