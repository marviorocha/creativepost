class PartiturasController < ApplicationController
  
  before_action :partitura_set, only: [:edit, :destroy, :update]
  require 'mechanize'
  require 'algorithmia'
  require 'convert_api'
  
  
  def index 
    
    
  end
  
    def new 
      
      @partitura = Partitura.all.order(created_at: :desc).page(params['page'])
      
    end
    
    def edit
      
     
      
      client = Algorithmia.client('simyq5hd59LF15HNzOR8HGJ0YKJ1')
      tags = client.algo('nlp/AutoTag/1.0.1')
      sumarize = client.algo('SummarAI/Summarizer/0.1.3')
      
      tag_input = @partitura.description    
      @tags = tags.pipe(tag_input).result
      get_title = @partitura.title.split("-")
      input = {
        articleName: get_title[0],
                      lang: "pt"
                    }
                    algo = client.algo('web/WikipediaParser/0.1.2')
                    result = algo.pipe(input).result
                    algo.set('timeout':300) # optional
                    
       @suma = result['summary']
       @images = result['images']
       
       # client que gera conteúdoc
       title_friend = @partitura.title.parameterize

       Cloudinary::Uploader.upload(@partitura.link,  :folder => "sheetmusic/", :public_id => title_friend )
       
       @resumo = sumarize.pipe(@suma).result
       
      end
      
      # Update and create score music 
    
      def update 
      
      respond_to do |format|

        

        if(@partitura.update(partitura_params))

          
          
    ConvertApi.config.api_secret = 'Oqj7jopTDGYyXzGw'
  
         pdf_result = ConvertApi.convert(
            'extract',
            File: "#{params['link_cloud']}",
            PageRange: 1,
          )
          
          jpg_result = ConvertApi.convert(
            'jpg',
            File: pdf_result,
            ScaleImage: true,
    ScaleProportions: true,
    ImageHeight: 600,
    ImageWidth: 600,
    Timeout:400,
    JpgQuality: 60,
  )
  
  saved_files = jpg_result.save_files("../showbiz/assets/images/partituras/")
  image_out = "#{saved_files[0].gsub("../showbiz","")}"

  date = Time.zone.now.strftime("%Y-%m-%d-%H-%M")
  
   File.open("../showbiz/_posts/partituras/#{date}-#{@partitura.title}.md", 'w') do |file|
      
      file.puts '---'
      file.puts "title: #{@partitura.title}"
      file.puts "subtitle: #{params['subtitle']}"
      file.puts "permalink: /#{@partitura.title.parameterize.gsub(' ', '-')}/"
      file.puts "date: #{date}"
      file.puts "download_pdf: #{params['link_cloud']}"
      file.puts "category: partituras"
      file.puts "image: #{image_out}"
      file.puts "layout: post"
      file.puts "tags: [#{params['tags']}]"
      file.puts "nivel: #{params['nivel']}"
      file.puts '---'
      file.puts "#{params['description']}"
    end
     
    @partitura.update(title: "ok Concluído ---------------")
    
    
          format.html {redirect_to new_partitura_path, notice: "Conteúdo foi adicionado com sucesso!"}
        else

        end
      
      end

    end
    
    # Show files the search

    def show 
        
        
        source = params["source"]
        key = "wRjSNdPcrnT7CcK7jaS5HuWeT4Q9RQoF"
        agent = Mechanize.new
        @page = agent.get('https://duckduckgo.com/')
        duck_form = @page.form('x')
        duck_form.q = "#{params['text']} #{ source } filetype:pdf"
        @page = agent.submit(duck_form, duck_form.buttons.first)
        
        # Inicio do looping
        @page.search('.links_main').each do |s|

        link = s.search('.result__snippet').map { |link| link['href'] }
        title = s.search('.result__a').text.gsub(/(.com|-|.com.br|PDF)/,'')
        description = s.search('.result__snippet').text.gsub(/\W/,' ')
        date = Time.now.strftime('%Y-%m-%d-%H-%M')
        
        Partitura.create(title: "#{params['text']} - " + title, link: link[0], description: description )
       
    end
    
    redirect_to new_partitura_path
       
    end

   def destroy

 
        if @partitura.destroy
          respond_to do |format|
            format.html {flash[:notice] = "O item [#{@partitura.id}] foi deletado com sucesso!" }
            format.js
            
          end
        end
    
 

   end


 def destroy_multiple
   
    Partitura.destroy(params[:partituras_ids])
   
    respond_to do |format|
     
      format.html { redirect_to new_partitura_path, notice: "Os itens foi deletado com successo"}
       
    end
  end


   private 

   def partitura_set
    @partitura = Partitura.find(params[:id])
   end

   def partitura_params

    params.require(:partitura).permit(:title, :link, :description, :image)

   end




end
