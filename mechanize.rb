require 'rubygems'
require 'mechanize'
require 'open-uri'
require 'rest-client'
response = Unirest.post "https://macgyverapi-music-graph-v1.p.rapidapi.com/",

headers:{
    "X-RapidAPI-Host" => "macgyverapi-music-graph-v1.p.rapidapi.com",
    "X-RapidAPI-Key" => "95027519d7mshd5af3da2c4b7d5bp1bb28ajsn108a37c9a747",
    "Content-Type" => "application/json",
    "Accept" => "application/json"
  }


response.code # Status code
response.headers # Response headers
response.body # Parsed body
response.raw_body # Unparsed body

agent = Mechanize.new
page = agent.get('https://duckduckgo.com/')
 
page_image = agent.get("https://duckduckgo.com/?q=#{name_sheet}&t=h_&iax=images&ia=images")

duck_form = page.form('x')
duck_form_image = page_image.form('x')


# puts 'Qual é o nome da musica que você deseja: '


# puts "Qual é o Artista + Instrumentos"
# name_sheet = gets

name_sheet = "Adele"

duck_form.q = "partitura #{name_sheet} filetype:pdf"
duck_form_image.q = "#{name_sheet} Album"



 page = agent.submit(duck_form, duck_form.buttons.first, duck_form_image, duck_form_image.buttons.first)

    
# puts "Qual será o nível"    
# nivel = gets
puts response.body
 
puts 'Gerando posts sheet music...'

 

page.search('.links_main').each do |s|
    
    
    
    
    link = s.search('.result__snippet').map { |link| link['href'] }
    
    title = s.search('.result__a').text
    date = Time.now.strftime('%Y-%m-%d-%H-%M')

  
    clear_title = title.gsub(/(.com|-|.com.br|PDF)/,'') 
 
 

    File.open("../showbiz/_posts/partituras/#{date}-#{title.gsub(' ', '-')}.md", 'w') do |file|
        
        file.puts '---'
        file.puts "title: Partitura #{clear_title}"
        file.puts "permalink: /#{title.gsub(' ', '_')}/"
        file.puts "date: #{date}"
        file.puts "download_pdf: #{link[0]}"
        file.puts "category: partituras"
        file.puts "layout: post"
        file.puts "nivel: #{nivel} "
        file.puts '---'
      end
    
    end

 
 
 