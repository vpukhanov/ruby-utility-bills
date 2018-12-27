RSpec.describe 'bills payment', type: :feature do
  it 'should allow paying for bills' do
    visit('/')
    click_on(id: 'view-bills-0') # Test One
    click_on(id: 'pay-bill-0') # electricity
    fill_in('To pay', with: 50)
    click_on('Pay')
    expect(page).to have_content('$200')
  end

  it 'should not allow paying more than remaining' do
    visit('/')
    click_on(id: 'view-bills-0')
    click_on(id: 'pay-bill-0')
    fill_in('To pay', with: 300)
    click_on('Pay')
    expect(page).to have_content('Pay a bill')
    expect(page).to have_content('This form contains the following errors')
  end

  it 'should not allow entering invalid pay ammount' do
    visit('/')
    click_on(id: 'view-bills-0')
    click_on(id: 'pay-bill-0')
    fill_in('To pay', with: 'abc')
    click_on('Pay')
    expect(page).to have_content('Pay a bill')
    expect(page).to have_content('This form contains the following errors')
  end

  it 'should not have a pay button for paid off bills' do
    visit('/')
    click_on(id: 'view-bills-0')
    expect(page).not_to have_selector('#pay-bill-1')
    expect(page).to have_selector('#pay-bill-2')
  end
end
