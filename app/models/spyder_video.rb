class SpyderVideo < ActiveRecord::Base
  belongs_to :user
  has_one :downloaded_video
  scope :unapproved, -> { where( :state => "未处理" ) }
  scope :preapproved, -> { where( :state => "已匹配标签" ) }
  scope :approved, -> { where( :state => "已处理" ) }
  scope :downloaded, -> { where( :state => "已下载" ) }

  STATES = ["未处理", "已匹配标签", "已处理", "已下载", "已发布", "废弃"]

  state_machine :state, :initial => :'未处理' do
    event :pre_approve do
      transition :'未处理' => :'已匹配标签'
    end

    event :approve do
      transition :'已匹配标签' => :'已处理'
    end

    event :download do
      transition :'已处理' => :'已下载'
    end

    event :publish do
      transition :'已下载' => :'已发布'
    end

    event :dispose do
      transition [:'已处理', :'未处理', :'已匹配标签', :'已下载'] => :'废弃'
    end

    event :recover do
      transition [:'废弃', :'已匹配标签', :'已下载', :'已处理'] => :'未处理'
    end
  end

# private
#     def columns
#       include SpydersHelper
#       columns = get_columns
#       columns.uniq!
#     end
end
