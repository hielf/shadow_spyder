namespace :publish do
  task :publish_comment => :environment do
    include SpydersHelper
    include SessionsHelper

    max_mobile = User.where("mobile BETWEEN ? AND ?", "13000000001", "13000010000").maximum(:mobile)
    max_mobile = "13000000001" if max_mobile.nil?

    # process commenters
    RawComment.where("created_at >= ?", 1.hour.ago).each do |comment|
      commenter = User.find_by(nick_name: comment.comment_user)

      if commenter.nil?
        # max_mobile = User.where("mobile BETWEEN ? AND ?", "13000000001", "13000010000").maximum(:mobile)
        break if (max_mobile == "13000010000")
        # p comment.comment_user
        next if (comment.comment_user.length > 10)
        # max_mobile = "13000000001" if max_mobile.nil?
        max_mobile = (max_mobile.to_i + 1).to_s

        user = dummy_login(max_mobile)
        # p user
        sleep 0.3
        res = modify_user_info(user, comment.comment_user, comment.avatar)
        sleep 0.3
        # p comment
        if res == 0
          user = dummy_login(max_mobile)
        else
          # user.destroy
          next
        end
      end

    end

    # post comments, each video one comment
    a = get_videos
    a.each do |v|
      mobile = Random.rand(13000000001..max_mobile.to_i).to_s
      user = dummy_login(mobile)
      # p user
      next if user.nick_name[0..3] == "130x"
      comment = RawComment.where(key_word: v[1], state: "未处理").last
      # p comment
      sleep 0.3
      RawComment.transaction do
        # p v
        publish_comment(user, v[0], comment.text)
        comment.publish
        sleep 0.3
      end if comment
    end

  end
end
