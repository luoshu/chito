module ThemeHelper

    def theme_css_links(options={})
	theme_files(:theme => @theme, :type => :stylesheets, :order => options[:order], :user_theme => @user.user_theme)
    end

    def theme_js_links(options={})
	theme_files(:theme => @theme, :type => :javascripts, :order => options[:order], :user_theme => @user.user_theme)
    end

    def theme_files(options={})
	case options[:type]
	when :javascripts
	    ext = "js"
	when :stylesheets
	    ext = "css"
	else
	    ext = "*"
	end
	f = options[:user_theme] ? Dir["#{@user.base_dir}/themes/#{options[:theme]}/#{options[:type]}/*.#{ext}"] : Dir["#{RAILS_ROOT}/themes/#{options[:theme]}/#{options[:type]}/*.#{ext}"]
	lists = options[:order] || f
	file_list = lists.map {|file| theme_path(:theme => options[:theme], :type => options[:type], :file => File.basename(file), :user_theme => options[:user_theme])}
	
	case options[:type]
	when :javascripts
	    return file_list.inject(""){|html,js|  html << javascript_include_tag(js) << "\n" }
	when :stylesheets
	    return file_list.inject(""){|html,css|  html <<  stylesheet_link_tag(css) << "\n" }
	else
	    return ""
	end
    end

    def theme_path(options={})
	if options[:user_theme]
	    File.join "/user_files/#{@user.name}/themes", options[:theme].to_s, options[:type].to_s, options[:file].to_s
	else
	    File.join "/themes/#{options[:theme].to_s}", options[:type].to_s, options[:file].to_s	
	end
    end

end