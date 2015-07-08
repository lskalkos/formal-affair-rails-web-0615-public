require 'spec_helper'

feature 'baby form' do
  it 'uses the form_for helper' do
    baby_form_template = File.read(File.join(Rails.root, 'app', 'views', 'babies', '_form.html.erb'))

    expect(baby_form_template).to match(/form_for/)
  end

  context 'submitting a form for a new baby' do
    it 'generates correctly structured params' do
      visit new_baby_path

      fill_in('baby[first_name]', with: 'Junior')
      fill_in('baby[last_name]', with: 'Jeewillikers')
      fill_in('baby[weight]', with: 12)
      fill_in('baby[birth_date]', with: '2014-02-12')

      click_button 'Create Baby'

      expected_params = {
        'utf8' => '✓',
        'baby' => {
          'first_name' => 'Junior',
          'last_name'  => 'Jeewillikers',
          'weight'     => '12',
          'birth_date' => '2014-02-12'
        },
        'commit'     =>'Create Baby',
        'action'     =>'create',
        'controller' =>'babies',
        'authenticity_token' => 'test token'
      }

      # {"utf8"=>"✓",
      #  "authenticity_token"=>"SCK4QpCVu1mUeRMc9A5sIYwJp1G5urpfJaQiDYu369Moz9BWZhJ/6YHfPgrDNiS3/R4lfVkjpLJwktpOPT+qsQ==",
      #  "baby"=>{"first_name"=>"Junior", "last_name"=>"Jeewillikers", "weight"=>"12", "birth_date"=>"2014-02-12"},
      #  "commit"=>"Create Baby",
      #  "controller"=>"babies",
      #  "action"=>"create"}


      expect(expected_params).to eq test_params
    end
  end

  context 'submitting a form for an existing baby' do
    it 'generates correctly structured params' do
      baby = Baby.create({
        first_name: 'Cupcake',
        last_name: 'Jenkins',
        weight: 12,
        birth_date: Time.new(2014, 2, 14)
      })

      visit edit_baby_path(baby)

      click_button 'Update Baby'

      expected_params = {
        'utf8'    => '✓',
        '_method' => 'patch',
        'baby' => {
          'first_name' => 'Cupcake',
          'last_name'  => 'Jenkins',
          'weight'     => '12',
          'birth_date' => '2014-02-14'
        },
        'commit'     =>'Update Baby',
        'action'     =>'update',
        'controller' =>'babies',
        'id'         => baby.id.to_s,
        'authenticity_token' => 'test token'
      }

      # {"utf8"=>"✓",
      #  "_method"=>"patch",
      #  "authenticity_token"=>"Cn4KVWit+y4nE4d/S9ZDXCVgCEMqQ2PZUELtEs5U0cUtf1vmcT0jJVwbk3uvLdYxR9c/3MVKbil5A1+p9Y2Dpg==",
      #  "baby"=>{"first_name"=>"Cupcake", "last_name"=>"Jenkins", "weight"=>"12", "birth_date"=>"2014-02-14 05:00:00.000000"},
      #  "commit"=>"Update Baby",
      #  "controller"=>"babies",
      #  "action"=>"update",
      #  "id"=>"1"}


      expect(expected_params).to eq test_params
    end
  end
end
