class PartiturasController < ApplicationController

    before_action :partitura_set, only: [:edit, :destroy, :update]
    require 'mechanize'
    require 'algorithmia'

 
    
    def index 
        
        
    end
    
    def new 
    
    @partitura = Partitura.all
    
    end

    def edit
    

        
        
        client = Algorithmia.client('simyq5hd59LF15HNzOR8HGJ0YKJ1')
        sumarize = client.algo('SummarAI/Summarizer/0.1.3')
        suma = @partitura.desciption
        @resumo = sumarize.pipe(suma).result

    end
    
    def show 
        
        
        key = "wRjSNdPcrnT7CcK7jaS5HuWeT4Q9RQoF"
        agent = Mechanize.new
        @page = agent.get('https://duckduckgo.com/')
        duck_form = @page.form('x')
        duck_form.q = "partitura #{params['text']} filetype:pdf"
        @page = agent.submit(duck_form, duck_form.buttons.first)
        
        # Inicio do looping
        @page.search('.links_main').each do |s|

        link = s.search('.result__snippet').map { |link| link['href'] }
        title = s.search('.result__a').text.gsub(/(.com|-|.com.br|PDF)/,'')
        date = Time.now.strftime('%Y-%m-%d-%H-%M')
        
        # client que gera conteúdoc

        client = Algorithmia.client('simyq5hd59LF15HNzOR8HGJ0YKJ1')
        algo = client.algo('web/WikipediaParser/0.1.2')
        algo.set('timeout':300) # optional
        result = algo.pipe(input).result
        Partitura.create(title: title, link: link[0], description: result["content"] )
       
    end
    
    redirect_to new_partitura_path
       
    end

   def destroy

 
        if @partitura.destroy 
        redirect_to new_partitura_path
        flash[:notice] = "O item [#{@partitura.id}] foi deletado com sucesso!"
        end
    
 

   end


   private 

   def partitura_set
    @partitura = Partitura.find(params[:id])
   end

   def partitura_params

    partitura.require(:partitura).permit(:title, :link, :description, :image)

   end




end
