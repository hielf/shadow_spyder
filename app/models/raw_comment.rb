class RawComment < ActiveRecord::Base

  state_machine :state, :initial => :'未处理' do

    event :publish do
      transition :'未处理' => :'已发布'
    end
  end

end
