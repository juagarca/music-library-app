# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
p 'Starting'

# Artists
# Artist.destroy_all
# tatu = Artist.create!(name: 'tATu')
# darin = Artist.create!(name: 'Darin')
# zara = Artist.create!(name: 'Zara Larsson')

# # Album
# Album.destroy_all
# lane = Album.create!(title: '200km/h In The Wrong Lane', artist: tatu, release_date: Date.new(2001))
# exit_album = Album.create!(title: 'Exit', artist: darin, release_date: Date.new(2002))
# poster = Album.create!(title: 'Poster Girl', artist: zara, release_date: Date.new(2021))

# # Songs
# Song.destroy_all
# all = Song.create!(title: 'All The Things She Said', length: 80)
# playing = Song.create!(title: 'Playing With Fire', length: 100)
# love = Song.create!(title: 'I Need Love', length: 182)
# fff = Song.create!(title: 'FFF', length: 213)

# # AlbumSongs
# AlbumSong.destroy_all
# AlbumSong.create!(album: lane, song: all, track_number: 2)
# AlbumSong.create!(album: exit_album, song: playing, track_number: 1)
# AlbumSong.create!(album: poster, song: love, track_number: 7)
# AlbumSong.create!(album: poster, song: fff, track_number: 11)

# Users
User.destroy_all
User.create!(email: 'test@email.com', password: '123456')
User.create!(email: 'test@email2.com', password: '123456')

# UserArtists
# UserArtist.destroy_all
# UserArtist.create!(artist: tatu, user: User.first)
# UserArtist.create!(artist: darin, user: User.first)
# UserArtist.create!(artist: zara, user: User.first)

p 'Finished'
