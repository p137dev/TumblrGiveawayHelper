class GiveawayHelperController < ApplicationController
  def new
    @link = TumblrLink.new(params[:giveawaylink])
  end

  def pick

    #TODO: Do I need a database for this? Also sanitize input, make a header and a footer, add a log to view, allow Tumblr reblogging

    @link = TumblrLink.create('giveawaylink' => params['tumblr_link']['giveawaylink'])

    require 'nokogiri'
    require 'open-uri'

    notes = Nokogiri.HTML(open(@link['giveawaylink'])).css("ol.notes")

    notes_reblogs = notes.css("li.reblog")
    notes_likes = notes.css("li.like")
    ballot_box_reblogs = Array.new
    ballot_box_likes = Array.new
    ballot_box = Array.new

    puts "Adding the people who reblogged the post to the rebloggers box."

    notes_reblogs.each do |note|
      puts "ADDING REBLOG: #{note.text.split.first}"
      ballot_box_reblogs << note.text.split.first
    end

    puts "Adding the people who liked the post to the likes box."

    notes_likes.each do |note|
      puts "ADDING LIKE: #{note.text.split.first}"
      ballot_box_likes << note.text.split.first
    end

    puts "Sorting the reblog box and the likes box alphabetically."

    ballot_box_reblogs.sort!
    ballot_box_likes.sort!

    puts "Comparing both the reblogs box and the likes box to find people who both liked and reblogged the post."

    i = 0
    ballot_box_reblogs.each do |candidate|
      #p "Current candidate:", candidate
      while i < ballot_box_likes.size and candidate >= ballot_box_likes[i]
        #p "Comparing with:", ballot_box_likes[i], i

        if candidate == ballot_box_likes[i]
          puts "* #{candidate} both liked and reblogged the post, adding him/her to the ballot box."
          ballot_box << candidate
        end

        i += 1

      end
    end

    puts "Adding people who reblogged the post to the ballot box."

    ballot_box += ballot_box_reblogs

    puts "The tickets in the ballot box are:"
    print ballot_box.sort, "\n"

    puts "And the winner is... "
    @winner = ballot_box.sample.to_s
    puts @winner

    # Get winner's avatar?
    @winners_blog_link = @winner.to_s + ".tumblr.com"
    @winners_avatar = Nokogiri.HTML(open("http://#{@winners_blog_link}")).xpath('//link[@rel="shortcut icon"]/@href').text


  end

end
