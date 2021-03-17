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

  def search_singer
  end

  def scraping_singer
    artist = params[:artist][:url]
    instagram = params[:artist][:instagram]
    bio = params[:artist][:bio]

    redirect_to "/result/#{artist}?instagram=#{instagram}&bio=#{bio}"
  end

  def result_singer
    artist_url = params[:name]
    instagram = "https://www.instagram.com/#{params[:instagram]}"
    url = "https://www.allmusic.com/artist/#{artist_url}"
    bio = params[:bio]

    @artist = create_artist(url, bio, instagram)
  end

  private

  def create_artist(url, bio, instagram)
    @info = retrieve_info_from_web(url)

    artist = Artist.create(name: @info[:name], instagram: instagram, bio: bio, description: @info[:description])
    performer = Performer.create(full_name: @info[:full_name], date_of_birth: @info[:date_of_birth], birth_location: @info[:birth_location])
    PerformerArtist.create(artist: artist, performer: performer)

    retrieve_albums_from_web("#{url}/discography", artist)
    artist
  end

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
    result[:description] = html_doc.search('.biography span').first.text.strip unless html_doc.search('.biography span').first.nil?
    result[:photo] = html_doc.search('.artist-contain img').attribute('src').value unless html_doc.search('.artist-contain img').first.nil?

    # Performer
    unless html_doc.search('.aliases div').first.nil?
      result[:full_name] = html_doc.search('.aliases div').first.children[1].text.strip
    else
      result[:full_name] = result[:name]
    end

    result[:date_of_birth] = parse_date(html_doc.search('.birth a').first.text.strip) unless html_doc.search('.birth a').first.nil?
    result[:birth_location] = html_doc.search('.birth a')[1].text.strip unless html_doc.search('.birth a')[1].nil?

    result
  end

  def retrieve_albums_from_web(url, artist)
    html_file = open(url).read
    html_doc = Nokogiri::HTML(html_file)

    html_doc.search('tbody tr').each do |row|
      album_url = row.search('.cover a').attribute('href').value
      url = "https://www.allmusic.com/#{album_url}"

      doc = Nokogiri::HTML(open(url).read)

      # Retrieving album title and date
      title = doc.search('.album-title').text.strip unless html_doc.search('.album-title').nil?

      unless doc.search('.release-date span').text.strip == ''
        date = doc.search('.release-date span').text.strip
        date = parse_date(date)

        category = 'album'

        album = Album.create!(artist: artist, release_date: date, title: title, category: category)

        create_album_songs(album, doc)
      end
    end
  end

  def parse_date(string)
    date = nil
    if string.length == 4
      date = Date.parse("#{string}/01/01")
    else
      date = Date.parse(string)
    end
    date
  end

  def create_album_songs(album, doc)
    doc.search('tbody tr').each do |song|
      track_number = song.search('.tracknum').text.strip.to_i

      title = song.search('.title a').text.strip
      length = song.search('.time').text.strip
      minutes = length.split(':').first.to_i
      seconds = length.split(':').last.to_i
      artist = nil

      song.search('.featuring a').each do |performer|
        name = performer.text.strip
        artist = Artist.find_by(name: name)

        unless artist
          url = performer.attributes['href'].value
          artist = create_artist(url, '', '')
        end
      end

      length_seconds = minutes * 60 + seconds

      song = Song.create(title: title, length: length_seconds)
      AlbumSong.create(song: song, album: album, track_number: track_number)
      Collaboration.create(song: song, artist: artist)
    end
  end
end
