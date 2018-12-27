RSpec.describe 'payers creation', type: :feature do
  it 'should allow payer creation' do
    visit('/')
    click_on('Add payer')
    
    fill_in('First name', with: 'Manual')
    fill_in('Last name', with: 'Testing')
    fill_in('Patronymic', with: 'Initiative')
    click_on('Create')

    expect(page).to have_content('Testing Manual Initiative')
  end

  it 'should allow empty patronymic' do
    visit('/')
    click_on('Add payer')
    
    fill_in('First name', with: 'Manual')
    fill_in('Last name', with: 'Testing')
    click_on('Create')

    expect(page).to have_content('Testing Manual')
  end

  it 'should not allow empty first and last names' do
    visit('/')
    click_on('Add payer')
    
    fill_in('Patronymic', with: 'Only')
    click_on('Create')

    expect(page).to have_content('New payer')
    expect(page).to have_content('This form contains the following errors')
  end

  it 'should not allow blank first and last names' do
    visit('/')
    click_on('Add payer')
    
    fill_in('First name', with: '   ')
    fill_in('Last name', with: '   ')
    fill_in('Patronymic', with: 'Only')
    click_on('Create')

    expect(page).to have_content('New payer')
    expect(page).to have_content('This form contains the following errors')
  end
end