require 'spec_helper'

describe Shortcodes do
  it 'is a module (sanity check)' do
    Shortcodes.should be_kind_of(Module)
  end

  def strip_whitespace(string)
    string.to_s.gsub(/\s+/, ' ')
  end


  it 'replaces a youtube shortcode' do
    content = '[youtube url="https://www.youtube.com/watch?v=jyOSP36sHx0"]'
    expected_content = '<iframe width="560" height="315" src="http://www.youtube.com/embed/jyOSP36sHx0" frameborder="0" allowfullscreen></iframe>'

    Shortcodes.shortcode(content).should == expected_content
  end

  it 'replaces a wufoo shortcode' do
    content = '[wufoo username="awesome_user" formhash="a04909c" autoresize="true" height="961" header="show" ssl="true"]'
    expected_content = <<-HTML
      <div id="wufoo-a04909c">
         Fill out my <a href="http://awesome_user.wufoo.com/forms/a04909c">online form</a>.
      </div>
      <script type="text/javascript">var a04909c;(function(d, t) {
      var s = d.createElement(t), options = {
      'userName':'awesome_user',
      'formHash':'a04909c',
      'autoResize':true,
      'height':'961',
      'async':true,
      'header':'show',
      'ssl':true};
      s.src = ('https:' == d.location.protocol ? 'https://' : 'http://') + 'wufoo.com/scripts/embed/form.js';
      s.onload = s.onreadystatechange = function() {
      var rs = this.readyState; if (rs) if (rs != 'complete') if (rs != 'loaded') return;
      try { a04909c = new WufooForm();a04909c.initialize(options);a04909c.display(); } catch (e) {}};
      var scr = d.getElementsByTagName(t)[0], par = scr.parentNode; par.insertBefore(s, scr);
      })(document, 'script');</script>
    HTML

    strip_whitespace(Shortcodes.shortcode(content)).should == strip_whitespace(expected_content)
  end
end