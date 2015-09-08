class GiveawayHelperController < ApplicationController
  def new
    @userinput = TumblrLink.new(params[:giveawaylink])
  end

  def pick

    #TODO: Do I need a database for this? Enhance the header and the footer, allow Tumblr reblogging. Add errors page, add fanfares. Add more rulesets. Allow the user to go to frontpage.

    require 'nokogiri'
    require 'open-uri'

    @userinput = TumblrLink.new('giveawaylink' => params['tumblr_link']['giveawaylink'])

    if @userinput.valid?
      tumblr_script_ballot(@userinput)
    else
      redirect_to action: :new
    end

  end

  private

  def tumblr_script_ballot(link)
    notes = Nokogiri.HTML(open(link['giveawaylink'])).css("ol.notes")

    notes_reblogs = notes.css("li.reblog")
    notes_likes = notes.css("li.like")
    ballot_box_reblogs = Array.new
    ballot_box_likes = Array.new
    ballot_box = Array.new
    @log = Array.new

    @log << "Adding the people who reblogged the post to the rebloggers box."
    @log << "-" * 50

    notes_reblogs.each do |note|
      @log << "ADDING REBLOG: #{note.text.split.first}"
      ballot_box_reblogs << note.text.split.first
    end

    @log << "-" * 50
    @log << "Adding the people who liked the post to the likes box."
    @log << "-" * 50

    notes_likes.each do |note|
      puts "ADDING LIKE: #{note.text.split.first}"
      ballot_box_likes << note.text.split.first
    end

    @log << "Sorting the reblog box and the likes box alphabetically."
    @log << "-" * 50

    ballot_box_reblogs.sort!
    ballot_box_likes.sort!

    @log << "Comparing both the reblogs box and the likes box to find people who both liked and reblogged the post."
    @log << "-" * 50

    i = 0
    ballot_box_reblogs.each do |candidate|
      #p "Current candidate:", candidate
      while i < ballot_box_likes.size and candidate >= ballot_box_likes[i]
        #p "Comparing with:", ballot_box_likes[i], i

        if candidate == ballot_box_likes[i]
          @log << "#{candidate} both liked and reblogged the post, adding him/her to the ballot box."
          ballot_box << candidate
        end

        i += 1

      end
    end

    @log << "Adding people who reblogged the post to the ballot box."
    @log << "-" * 50

    ballot_box += ballot_box_reblogs

    @log << "The tickets in the ballot box are:"
    @log << "-" * 50
    @log << ballot_box.sort
    @log << "-" * 50

    @log << "And the winner is..."
    @log << "-" * 50
    @winner = ballot_box.sample.to_s
    @log << @winner
    @log << "-" * 50

    # Get winner's avatar?
    @winners_blog_link = @winner.to_s + ".tumblr.com"
    @winners_avatar = Nokogiri.HTML(open("http://#{@winners_blog_link}")).xpath('//link[@rel="shortcut icon"]/@href').text
  end


end

