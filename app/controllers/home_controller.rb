class HomeController < ApplicationController
  
    before_action :post_now, only: [:post]

include HomeHelper

    def index
    

    #secret ""    

    # resp = RestClient.get "#{url}"
    
    # @description = JSON.parse(resp.to_str).take(9)

  
    key = "wRjSNdPcrnT7CcK7jaS5HuWeT4Q9RQoF"
    url  =  RestClient.get("http://api.musescore.com/services/rest/score.json?oauth_consumer_key=#{key}&part=1&sort=view_count&text&language&page&parts&view_count&date_uploaded&relevance&comment_count")
    @score = JSON.parse(url.to_str)
    
  
    end

    def show
        key = "wRjSNdPcrnT7CcK7jaS5HuWeT4Q9RQoF"
        
        # WP Get Score Piano
        category = RestClient.get('https://www.showbiz.mus.br/wp-json/wp/v2/categories')
        @categories = JSON.parse(category.to_str)
        
        #get score api
        response = RestClient.get("http://api.musescore.com/services/rest/score/#{params[:id]}.json?oauth_consumer_key=#{key}")
        @score = JSON.parse(response.to_str)
        
        #get user api
        url_user = RestClient.get("http://api.musescore.com/services/rest/user/#{@score['user']['uid']}.json?oauth_consumer_key=#{key}")
        @score_user = JSON.parse(url_user.to_str)
          
        @content = "<!-- wp:paragraph -->
        <p><a title='link para download de partitura' href='#download'>Download</a> | <strong>Compositor:</strong> #{@score['metadata']['composer']}  - <strong>Arranjo:</strong> 
        <img alt='#{@score_user['name']}' class='wp-image-40' width='40' hight='40' sizes='40' 
        src='#{@score_user['avatar_url']}' /> #{@score_user['name']}</p>
        <!-- /wp:paragraph -->
        
        <!-- wp:paragraph -->
        <figure class='wp-block-image'>
        <img  alt='#{@score['title']}' src='#{ score_img(@score['id'], @score['secret'])}' class='wp-image-600'/></figure>
        <!-- /wp:paragraph -->
        
        <!-- wp:paragraph -->
        <p><strong>Descrição:</strong> #{@score['description']} </p>
        <!-- /wp:paragraph -->
        
        <!-- wp:paragraph -->
        <p><br><strong>Páginas:</strong> #{ @score['metadata']['pages']} 
        <br><strong>Sub titulo:</strong> #{ 
            @score['metadata']['subtitle']
   
            }<br><strong id='download'>Download:</strong></p>
        <!-- /wp:paragraph -->
        
        <!-- wp:columns {'columns':4,'align':'wide'} -->
        <div class='wp-block-columns alignwide has-4-columns'><!-- wp:column -->
        <div class='wp-block-column'><!-- wp:button {'backgroundColor':'vivid-red','align':'center'} -->
        <div class='wp-block-button aligncenter'><a  target='_blank' href='#{ score_pdf(@score['id'], @score['secret'])}' class='wp-block-button__link
         has-background has-vivid-red-background-color'>PDF</a></div>
        <!-- /wp:button --></div>
        <!-- /wp:column -->
        
        <!-- wp:column -->
        <div class='wp-block-column'><!-- wp:button {'customBackgroundColor':'#2eb9d1','align':'center'} -->
        <div class='wp-block-button aligncenter'><a  target='_blank' href='#{ score_midi(@score['id'], @score['secret'])}' class='wp-block-button__link has-background' style='background-color:#2eb9d1'>Midi</a></div>
        <!-- /wp:button -->
        
        <!-- wp:paragraph -->
        <p></p>
        <!-- /wp:paragraph --></div>
        <!-- /wp:column -->
        
        <!-- wp:column -->
        <div class='wp-block-column'><!-- wp:button {'backgroundColor':'very-dark-gray','align':'center'} -->
        <div class='wp-block-button aligncenter'><a  target='_blank' href='#{ score_xml(@score['id'], @score['secret'])}' class='wp-block-button__link has-background has-very-dark-gray-background-color'>MusicXML</a></div>
        <!-- /wp:button --></div>
        <!-- /wp:column -->
        
        <!-- wp:column -->
        <div class='wp-block-column'><!-- wp:button {'customBackgroundColor':'#3474bd','align':'center'} -->
        <div class='wp-block-button aligncenter'><a  target='_blank' href='#{ score_musescore(@score['id'], @score['secret'])}' class='wp-block-button__link has-background' style='background-color:#3474bd'>MuseScore</a></div>
        <!-- /wp:button --></div>
        <!-- /wp:column --></div>
        <!-- /wp:columns -->"
         end

    def search
    
        key = "wRjSNdPcrnT7CcK7jaS5HuWeT4Q9RQoF"
        text = params['text']
        url  =  RestClient.get("http://api.musescore.com/services/rest/score.json?oauth_consumer_key=#{key}&part=1&sort=view_count&text='#{text}'&language&page&parts&view_count&date_uploaded&relevance&comment_count")
        @score = JSON.parse(url.to_str)
    end


    def post
        
 
        # RestClient.post '/', :myfile => File.new(score_img(@score['id'], @score['secret']), 'rb')
      
   

     
        RestClient::Request.execute(
            method: :post, 
            url: 'https://www.showbiz.mus.br/wp-json/wp/v2/posts/',
            user: 'showbiz', 
            password: 'luacho07',
            payload: { 
                #'status'  => 'publish',
                'title'   => params['title'],
                'content' => params['content'],
                'categories' => params['categories']
                
            }
          )
        flash['notice'] =  "Post criado com sucesso" 
        redirect_to root_path
        

        
         
    end

    private

    def post_now
        params.permit(:title, :content, :image, :categories => [])
    end


end
