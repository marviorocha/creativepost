class HomeController < ApplicationController
    
    def index
    
 

    key = "wRjSNdPcrnT7CcK7jaS5HuWeT4Q9RQoF"
    #secret ""    
    url  = "http://api.musescore.com/services/rest/score.xml?oauth_consumer_key=#{key}&part=0&parts&license"

   
    # resp = RestClient.get "#{url}"
    
    # @description = JSON.parse(resp.to_str).take(9)

  
    response = RestClient.get('http://api.musescore.com/services/rest/score.json?oauth_consumer_key=wRjSNdPcrnT7CcK7jaS5HuWeT4Q9RQoF&part=0',
        text: '""',)

 
    end

    def post

        response = RestClient.get('http://api.musescore.com/services/rest/score.json?oauth_consumer_key=wRjSNdPcrnT7CcK7jaS5HuWeT4Q9RQoF&part=0',
            text: '""',)
    
        @score = JSON.parse(response.to_str)

        RestClient::Request.execute(
            method: :post, 
            url: 'https://www.showbiz.mus.br/wp-json/wp/v2/posts/',
            user: 'showbiz', 
            password: 'luacho07',
            payload: { 
                #'status'  => 'publish',
                'title'   => @score['title'],
                 'content' => @score['description'],
               
            }
          )
    
     
    end

end
