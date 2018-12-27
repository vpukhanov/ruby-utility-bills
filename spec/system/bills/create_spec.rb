RSpec.describe 'bills creation', type: :feature do
  it 'should allow bill creation' do
    visit('/')
    click_on(id: 'view-bills-2') # Z Z
    click_on('Add bill')
    select('phone', from: 'Bill type')
    fill_in('Total ammount to pay', with: 250)
    fill_in('Ammount already paid', with: 50)
    click_on('Create')
    expect(page).to have_content('phone')
    expect(page).to have_content('$250')
    expect(page).to have_content('$200')
  end

  it 'should not allow higher paid than total' do
    visit('/')
    click_on(id: 'view-bills-2')
    click_on('Add bill')
    select('phone', from: 'Bill type')
    fill_in('Total ammount to pay', with: 250)
    fill_in('Ammount already paid', with: 500)
    click_on('Create')
    expect(page).to have_content('New bill')
    expect(page).to have_content('This form contains the following errors')
  end

  it 'should not allow invalid paid and total' do
    visit('/')
    click_on(id: 'view-bills-2')
    click_on('Add bill')
    select('phone', from: 'Bill type')
    fill_in('Total ammount to pay', with: 'abc')
    fill_in('Ammount already paid', with: 'def')
    click_on('Create')
    expect(page).to have_content('New bill')
    expect(page).to have_content('This form contains the following errors')
  end
end