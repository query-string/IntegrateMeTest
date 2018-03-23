require "rails_helper"

describe Entry do
  fixtures :entries

  context 'when only e-mail defined' do
    let(:entry) { entries(:entry_nameless) }

    describe '#first_name' do
      it 'returns username as a name' do
        expect(entry.first_name).to eq 'alex'
      end
    end
    describe '#last_name' do
      it 'returns username as a name' do
        expect(entry.last_name).to eq 'alex'
      end
    end
  end

  context 'when short name defined' do
    let(:entry) { entries(:entry_shortname) }

    describe '#first_name' do
      it 'returns first name as a name' do
        expect(entry.first_name).to eq 'Alexander'
      end
    end
    describe '#last_name' do
      it 'returns first name as a name' do
        expect(entry.last_name).to eq 'Alexander'
      end
    end
  end

  context 'when full name defined' do
    let(:entry) { entries(:entry_fullname) }

    describe '#first_name' do
      it 'returns first name as a name' do
        expect(entry.first_name).to eq 'Alexander'
      end
    end
    describe '#last_name' do
      it 'returns last name as a name' do
        expect(entry.last_name).to eq 'Timofeev'
      end
    end
  end
end
