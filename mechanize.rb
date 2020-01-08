require 'rubygems'
require 'mechanize'
require 'open-uri'
require 'rest-client'
require 'convert_api'
require 'tmpdir'
agent = Mechanize.new
page = agent.get('https://duckduckgo.com/')


duck_form = page.form('x')
#duck_form_image = page_image.form('x')


# puts 'Qual é o nome da musica que você deseja: '


# puts "Qual é o Artista + Instrumentos"
# name_sheet = gets

name_sheet = "Mozart"

duck_form.q = "partitura #{name_sheet} filetype:pdf"
#duck_form_image.q = "#{name_sheet} Album"



page = agent.submit(duck_form, duck_form.buttons.first)


puts "Qual será o nível"    
nivel = gets

puts 'Gerando posts sheet music...'



page.search('.links_main').each do |s|
  
  
  
  
  link = s.search('.result__snippet').map { |link| link['href'] }
  
  title = s.search('.result__a').text
  date = Time.now.strftime('%Y-%m-%d-%H-%M')
  
  ConvertApi.config.api_secret = 'Oqj7jopTDGYyXzGw'
  pdf_result = ConvertApi.convert(
    'extract',
    File: "#{link[0]}",
    PageRange: 1,
  )
  
  jpg_result = ConvertApi.convert(
    'jpg',
    File: pdf_result,
    ScaleImage: true,
    ScaleProportions: true,
    ImageHeight: 600,
    ImageWidth: 600,
    JpgQuality: 60,
  )
  
  saved_files = jpg_result.save_files("../showbiz/assets/images/partituras/")
  
  puts "The thumbnail saved to #{title}"
  
  clear_title = title.gsub(/(.com|-|.com.br|PDF)/,'') 
  
    
    File.open("../showbiz/_posts/partituras/#{date}-#{title.gsub(' ', '-')}.md", 'w') do |file|
      
      file.puts '---'
      file.puts "title: Partitura #{clear_title}"
      file.puts "permalink: /#{title.gsub(' ', '_')}/"
      file.puts "date: #{date}"
      file.puts "download_pdf: #{link[0]}"
      file.puts "category: partituras"
      file.puts "image:  /assets/images/partituras/#{saved_files[0]}"
      file.puts "layout: post"
        file.puts "nivel: #{nivel} "
        file.puts '---'
      end
    
    end

 
 
 