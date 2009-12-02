class TableBuilder
  def initialize(options)
    @rows    = options[:rows]
    @headers = options[:headers]
  end
    
  # HTML =======================================================================
  
  def to_html
    trs = []
    if @headers.any?
      ths = @headers.collect do |cell|
        classes = cell[:class].nil? ? '' : " class=\"cell[:class]\""
        if cell[:href]
          "<th#{classes}><a href=\"#{cell[:href]}\">#{cell[:value]}</a></th>"
        else
          "<th#{classes}>#{cell[:value]}</th>"
        end
      end
      trs << "<tr>#{ths.join}</tr>"
    end
    trs += @rows.collect do |line|
      tds = line.collect do |cell|
        classes = cell[:class].nil? ? '' : " class=\"cell[:class]\""
        if cell[:href]
          "<td#{classes}><a href=\"#{cell[:href]}\">#{cell[:value]}</a></td>"
        elsif cell[:bold]
          "<td#{classes}><strong>#{cell[:value]}</strong></td>"
        else
          "<td#{classes}>#{cell[:value]}</td>"
        end
      end
      "<tr>#{tds.join}</tr>"
    end
    "<table>#{trs.join}</table>"
  end
  
  # Prawn ======================================================================
  
  def to_prawn(options = {})
    ths = @headers.collect do |cell|
      cell[:value]
    end

    trs = @rows.collect do |row|
      row.collect do |cell|
        params = {
          :text => cell[:value].to_s
        }
        params[:font_style] = :bold if cell[:bold]
        Prawn::Table::Cell.new(params)
      end
    end
        
    options[:headers] = ths if ths.any?
        
    return trs, options
  end
end

# h = [{:value => 'Prix'}, {:value => 'Pays'}, {:value => 'Nombre de clients supposés'}]
# 
# a = [
#   [{:value => '50€'}, {:value => 'Australia'}, {:value => '2'}],
#   [{:value => '50€'}, {:value => 'Spain', :bold => true},     {:value => '1'}]
# ]