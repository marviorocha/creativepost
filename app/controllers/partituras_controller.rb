class PartiturasController < ApplicationController


    def index 
    
    
    end


    def search 
        key = "wRjSNdPcrnT7CcK7jaS5HuWeT4Q9RQoF"
      
        require 'algorithmia'
        require 'mechanize'
        agent = Mechanize.new
      

@page = agent.get('https://www.google.com')

 
google_form = @page.form('f')

google_form.q = 'partitura Midian Lima filetype:pdf'

@page = agent.submit(google_form, google_form.buttons.first) 


         
    end


end
