class SpyderVideo < ActiveRecord::Base
  belongs_to :user
  belongs_to :spyder
  scope :unapproved, -> lambda { where( :state => "未处理" ) }
  scope :downloaded, -> lambda { where( :state => "已下载" ) }
  scope :published, -> lambda { where( :state => "已发布" ) }

  STATES = ["未处理", "已下载", "已发布"]

  state_machine :state, :initial => :'未处理' do

    event :download do
      transition :'未处理' => :'已下载'
    end

    event :publish do
      transition :'已下载' => :'已发布'
    end

    event :recover do
      transition [:'已下载', :'已发布'] => :'未处理'
    end
  end

end
