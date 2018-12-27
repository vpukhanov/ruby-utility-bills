RSpec.describe 'payers viewing and filtering', type: :feature do
  it 'should display a table of payers' do
    visit('/')
    expect(page).to have_content('Test One')
    expect(page).to have_content('Test Two Patric')
    expect(page).not_to have_content('This form contains the following errors')
  end

  it 'should allow filtering by debt range' do
    visit('/')
    fill_in('From', with: 500)
    fill_in('To', with: 1500)
    click_on('Filter')
    expect(page).to have_content('Test One')
    expect(page).not_to have_content('Test Two Patric')
  end

  it 'should display message when filtered to empty list' do
    visit('/')
    fill_in('From', with: 1500)
    fill_in('To', with: 2000)
    click_on('Filter')
    expect(page).to have_content('No payers found')
  end

  it 'should display an error message when filter options are invalid' do
    visit('/')
    fill_in('From', with: 2000)
    fill_in('To', with: 500)
    click_on('Filter')
    expect(page).to have_content('This form contains the following errors')
  end
end