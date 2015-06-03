require 'ruboto/widget'
require 'ruboto/util/toast'

ruboto_import_widgets :Button, :LinearLayout, :TextView

# http://xkcd.com/378/

class QuickStartActivity
  def onCreate(bundle)
    super
    set_title 'A great app'

    self.content_view =
        linear_layout :orientation => :vertical do
          @text_view = text_view :text => 'Why does KC do what he does?', :id => 42, 
                                 :layout => {:width => :match_parent},
                                 :gravity => :center, :text_size => 48.0
          button :text => 'Ask', 
                 :layout => {:width => :match_parent},
                 :id => 43, :on_click_listener => proc { butterfly }
        end
  rescue Exception
    puts "Exception creating activity: #{$!}"
    puts $!.backtrace.join("\n")
  end

  private

  def butterfly
#    @text_view.text = 'What hath Matz wrought!'
    toast 'Because he loves Shelyse'
  end

end
