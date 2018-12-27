RSpec.describe 'bills viewing', type: :feature do
  it 'should display list of bills' do
    visit('/')
    click_on(id: 'view-bills-0')
    expect(page).to have_content('Bills of Test One')
    expect(page).to have_content('Type')
    expect(page).to have_content('Remaining')
    expect(page).to have_content('Total amount')
    expect(page).to have_content('rent')
    expect(page).to have_content('$1000')
    expect(page).to have_content('Total')
  end

  it 'should calculate remaining total and complete total' do
    visit('/')
    click_on(id: 'view-bills-0')
    expect(page).to have_selector('#remaining-debt', text: '$1250')
    expect(page).to have_selector('#complete-debt', text: '$2000')
  end
end
