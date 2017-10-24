class CarCategory < ActiveRecord::Base
  belongs_to :parent, :class_name => "CarCategory", :foreign_key => "parent_id"

  scope :available_depth_1, -> { where( :state => "使用", :depth => "1" ) }
  scope :available_depth_3, -> { where( :state => "使用", :depth => "3" ) }

  state_machine :state, :initial => :'使用' do
    event :unuse do
      transition :'使用' => :'关闭'
    end

    event :use do
      transition :'关闭' => :'使用'
    end
  end
end
