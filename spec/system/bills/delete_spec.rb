RSpec.describe 'bills deletion', type: :feature do
  it 'should allow to delete bill' do
    visit('/')
    click_on(id: 'view-bills-0') # Test One
    expect(page).to have_content('electricity')
    click_on(id: 'delete-bill-0') # electricity
    expect(page).not_to have_content('electricity')
  end

  it 'should display message when there are no bills left' do
    visit('/')
    click_on(id: 'view-bills-2') # Z Z
    expect(page).to have_content('rent')
    click_on(id: 'delete-bill-0')
    expect(page).to have_content('No bills')
  end
end
