require "rails_helper"

RSpec.feature "Dynamic Settings" do
  background do
    FactoryGirl.create(:dynamic_setting, ns: 'bbbns', name: 'ssss1', value: 'v1')
    FactoryGirl.create(:dynamic_setting, ns: 'aaans', name: 'ssss2', value: 'v2')
    FactoryGirl.create(:dynamic_setting, ns: 'cccns', name: 'bbbbb', value: 'v3')
    FactoryGirl.create(:dynamic_setting, ns: 'cccns', name: 'aaaaa', value: 'v4')
  end

  scenario "User can see all sorted settings" do
    visit '/'
    expect(page).to have_content('List of Dynamic Settings')
    expect(page).to have_content(/aaans.+bbbns.+cccns.+aaaaa.+cccns.+bbbbb/)
  end

  scenario "User can see edit page" do
    visit '/dynamic_settings'
    find(:xpath, ".//tr[contains(., 'aaans')]//a[.='Edit']").click
    expect(page).to have_content("Edit dynamic setting")
    expect(page).to have_css("#dynamic_setting_ns[disabled]")
    expect(page).to have_css("#dynamic_setting_name[disabled]")
  end

  scenario "User can update specific setting with bottom button" do
    visit '/dynamic_settings'
    find(:xpath, ".//tr[contains(., 'aaans')]//a[.='Edit']").click
    fill_in('dynamic_setting_value', with: 456)
    within('div.row.panel') do
      click_button('Save')
    end
    expect(page.current_url).to eql('http://www.example.com/dynamic_settings')
    expect(page).to have_content('456')
    expect(page).to_not have_content('v2')
  end

  scenario "User can back from edit to index page" do
    visit '/dynamic_settings'
    find(:xpath, ".//tr[contains(., 'aaans')]//a[.='Edit']").click
    fill_in('dynamic_setting_value', with: 789)
    click_link('Back')
    expect(page.current_url).to eql('http://www.example.com/dynamic_settings')
    expect(page).to have_content('v2')
    expect(page).to_not have_content('789')
  end
end