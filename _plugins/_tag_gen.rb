module Jekyll
   module Paginate  

	class CatsAndTags < Generator
    safe true
	priority :lowest
	
    def generate(site)
        site.tags.each do |tag|
          paginate(site, "tag", tag)
        end
    end

    def paginate(site, type, posts)
     pages = Pager.calculate_pages(posts[1], site.config['paginate'].to_i)

     (1..pages).each do |num_page|
		pager = Pager.new(site, num_page, posts[1], pages)

        path = "/#{type}/#{posts[0]}"
        if num_page > 1
          path = path + "/page#{num_page}"
        end

        newpage = GroupSubPage.new(site, site.source, path, type, posts[0])
		newpage.pager = pager
        site.pages << newpage 
      end
    end
  end

  class GroupSubPage < Page
    def initialize(site, base, dir, type, val)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'post_list.html')
      self.data['tag'] = val
	  self.data['title'] = "Posts Tagged: #{val}"
    end
  end

 end 
end
