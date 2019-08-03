module HomeHelper

def score_img (id, secret)
   gen = id.split(//).last(3).reverse.join('/') 
   url = "http://musescore.com/static/musescore/scoredata/gen/#{gen}/#{id}/#{secret}/score_0.png"
end

def score_pdf (id, secret)
   gen = id.split(//).last(3).reverse.join('/') 
   url = "https://musescore.com/score/#{id}/download/pdf"
end

def score_midi (id, secret)
   gen = id.split(//).last(3).reverse.join('/') 
   url = "http://musescore.com/static/musescore/scoredata/gen/#{gen}/#{id}/#{secret}/score.mid"
end

def score_mp3 (id, secret)
   gen = id.split(//).last(3).reverse.join('/') 
   url = "http://musescore.com/static/musescore/scoredata/gen/#{gen}/#{id}/#{secret}/score.mp3"
end

def score_musescore (id, secret)
   gen = id.split(//).last(3).reverse.join('/') 
   url = "https://musescore.com/score/#{id}/download/mscz"
end

def score_xml (id, secret)
   gen = id.split(//).last(3).reverse.join('/') 
   url = "http://musescore.com/static/musescore/scoredata/gen/#{gen}/#{id}/#{secret}/score.mxl"
end

end
