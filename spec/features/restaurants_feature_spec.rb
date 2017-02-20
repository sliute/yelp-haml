require 'rails_helper'

feature 'Restaurants:' do
  context 'With no restaurants added' do
    scenario 'the page should display a prompt to add a restaurant' do
      visit '/restaurants'
      expect(page).to have_content 'No restaurants yet'
      expect(page).to have_link 'Add a restaurant'
    end
  end

  context 'With restaurants added' do
    before do
      Restaurant.create(name: 'Los pollos hermanos')
    end

    scenario 'the page displays them' do
      visit '/restaurants'
      expect(page).to have_content('Los pollos hermanos')
      expect(page).not_to have_content('No restaurants yet')
    end
  end

  context 'Users can create restaurants' do
    scenario 'by filling out a form, then seeing the new restaurant displayed' do
      visit '/restaurants'
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'Los pollos hermanos'
      click_button 'Create Restaurant'
      expect(page).to have_content 'Los pollos hermanos'
      expect(current_path).to eq '/restaurants'
    end
  end

  context 'Users can view restaurants' do
    let!(:lph){ Restaurant.create(name:'Los pollos hermanos') }

    scenario 'on individual pages' do
      visit '/restaurants'
      click_link 'Los pollos hermanos'
      expect(page).to have_content 'Los pollos hermanos'
      expect(current_path).to eq "/restaurants/#{lph.id}"
    end
  end

  context 'Users can edit restaurants' do
    before { Restaurant.create name: 'Las chulas', description: 'Street food served well, esse!', id: 1 }
    scenario 'let a user edit a restaurant' do
      visit '/restaurants'
      click_link 'Edit Las chulas'
      fill_in 'Name', with: 'El gran restorante Las Chulas'
      fill_in 'Description', with: 'Street food served well, esse!'
      click_button 'Update Restaurant'
      click_link 'El gran restorante Las Chulas'
      expect(page).to have_content 'El gran restorante Las Chulas'
      expect(page).to have_content 'Street food served well, esse!'
      expect(current_path).to eq '/restaurants/1'
    end
  end

  context 'User can delete restaurants' do
    before { Restaurant.create name: 'La perdida', description: 'Slow, old food' }

    scenario 'by clicking a delete link' do
      visit '/restaurants'
      click_link 'Delete La perdida'
      expect(page).not_to have_content 'La perdida'
      expect(page).to have_content 'Restaurant deleted successfully'
    end
  end
end
