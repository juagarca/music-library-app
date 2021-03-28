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

  def create_artist
  end

  def scraping_artist
    artist = params[:artist][:url]
    instagram = params[:artist][:instagram]
    bio = params[:artist][:bio]

    redirect_to "/result/#{artist}?instagram=#{instagram}&bio=#{bio}"
  end

  def result_artist
    artist_url = params[:name]
    instagram = "https://www.instagram.com/#{params[:instagram]}"
    url = "https://www.allmusic.com/artist/#{artist_url}"
    bio = params[:bio]

    html_file = open(url).read
    html_doc = Nokogiri::HTML(html_file)

    @artist = a_group?(html_doc) ? create_group_artist(url, bio, instagram) : create_solo_artist(url, bio, instagram)
  end

  private

  def a_group?(html_doc)
    type = html_doc.search('.birth h4').children.text.strip == 'Formed' ? 'group' : 'solo'
    type == 'group'
  end

  def create_solo_artist(url, bio, instagram)
    html_file = open(url).read
    doc = Nokogiri::HTML(html_file)
    info = retrieve_info_solo(doc)

    if Artist.where(name: info[:name]).count != 0
      artist = Artist.where(name: info[:name]).first.performers.where(full_name: info[:full_name]).first.artists.where(name: info[:name]).first
    end

    unless artist
      artist = Artist.create(name: info[:name], instagram: instagram, bio: bio, description: info[:description])

      unless doc.search('.artist-contain img').first.nil?
        artist_photo = doc.search('.artist-contain img').first.attributes['src'].value
        file = URI.open(artist_photo)
        artist.photos.attach(io: file, filename: artist.name, content_type: 'image/png')
      end

      performer = Performer.where(full_name: info[:full_name], date_of_birth: info[:date_of_birth]).first

      if !performer
        performer = Performer.create(full_name: info[:full_name], date_of_birth: info[:date_of_birth], birth_location: info[:birth_location])
      end
      PerformerArtist.create(artist: artist, performer: performer)

      retrieve_albums_from_web("#{url}/discography", artist, 'album')
      retrieve_albums_from_web("#{url}/discography/singles", artist, 'other')
    end

    artist
  end

  def create_group_artist(url, bio, instagram)
    html_file = open(url).read
    doc = Nokogiri::HTML(html_file)
    artist = retrieve_info_group(doc, bio, instagram)

    unless doc.search('.artist-contain img').first.nil?
      artist_photo = doc.search('.artist-contain img').first.attributes['src'].value
      file = URI.open(artist_photo)
      artist.photos.attach(io: file, filename: artist.name, content_type: 'image/png')
    end

    retrieve_albums_from_web("#{url}/discography", artist, 'album')
    retrieve_albums_from_web("#{url}/discography/singles", artist, 'other')
    artist
  end

  def find_albums_to_listen
    records = UserAlbum.where(played: false, user: current_user)
    records.map do |record|
      record.album
    end
  end

  def retrieve_info_solo(html_doc)
    result = {}

    # Artist
    result[:name] = html_doc.search('.artist-name').text.strip
    result[:description] = html_doc.search('.biography span').first.text.strip unless html_doc.search('.biography span').first.nil?
    result[:photo] = html_doc.search('.artist-contain img').attribute('src').value unless html_doc.search('.artist-contain img').first.nil?

    # Performer
    result[:full_name] = result[:name]

    unless html_doc.search('.birth a').first.nil?
      if html_doc.search('.birth a').count == 1
        raise
        result[:date_of_birth] = html_doc.search('.birth a').first.text.strip
        result[:birth_location] = nil
      else
        result[:date_of_birth] = parse_date(html_doc.search('.birth a').first.text.strip)
        result[:birth_location] = html_doc.search('.birth a')[1].text.strip
      end
    end

    result
  end

  def retrieve_info_group(html_doc, bio, instagram)
    result = {}

    # Artist
    result[:name] = html_doc.search('.artist-name').text.strip
    result[:description] = html_doc.search('.biography span').first.text.strip unless html_doc.search('.biography span').first.nil?
    result[:photo] = html_doc.search('.artist-contain img').attribute('src').value unless html_doc.search('.artist-contain img').first.nil?
    artist = Artist.create(name: result[:name], instagram: instagram, bio: bio, description: result[:description])

    # Performers
    html_doc.search('.group-members a').each do |member|
      member_url = member.attributes['href'].value
      url = "https://www.allmusic.com/#{member_url}"

      doc = Nokogiri::HTML(open(url).read)

      # Retrieving info from member to create performer
      full_name = doc.search('.artist-name').text.strip
      unless doc.search('.birth a').first.nil?
        if doc.search('.birth a').count == 1
          date_of_birth = doc.search('.birth a').first.text.strip
          birth_location = nil
        else
          date_of_birth = parse_date(doc.search('.birth a').first.text.strip)
          birth_location = doc.search('.birth a')[1].text.strip
        end
      end

      performer = Performer.create(full_name: full_name, date_of_birth: date_of_birth, birth_location: birth_location)
      PerformerArtist.create(artist: artist, performer: performer)
    end

    artist
  end

  def retrieve_albums_from_web(url, artist, category)
    html_file = open(url).read
    html_doc = Nokogiri::HTML(html_file)

    html_doc.search('tbody tr').each do |row|
      album_url = row.search('.cover a').attribute('href').value
      url = "https://www.allmusic.com/#{album_url}"
      doc = Nokogiri::HTML(open(url).read)

      # Retrieving album title, date and cover if it has a release date
      unless doc.search('.release-date span').text.strip == ''
        title = doc.search('.album-title').text.strip unless html_doc.search('.album-title').nil?
        cover_url = doc.search('.album-contain img').first.attributes['src'].value
        file = URI.open(cover_url)

        date = doc.search('.release-date span').text.strip
        date = parse_date(date)
        category = category

        album = Album.create(artist: artist, release_date: date, title: title, category: category)
        album.cover.attach(io: file, filename: "#{artist}_#{title}", content_type: 'image/png')
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

      # song.search('.featuring a').each do |performer|
      #   name = performer.text.strip
      #   artist = Artist.find_by(name: name)

      #   unless artist
      #     url = performer.attributes['href'].value
      #     html_file = open(url).read
      #     html_doc = Nokogiri::HTML(html_file)

      #     if a_group?(html_doc)
      #       artist = create_group_artist(url, '', '')
      #     else
      #       artist = create_solo_artist(url, '', '')
      #     end
      #   en
      # end

      length_seconds = minutes * 60 + seconds

      song = Song.create(title: title, length: length_seconds)
      AlbumSong.create(song: song, album: album, track_number: track_number)
      # Collaboration.create(song: song, artist: artist)
    end
  end
end
