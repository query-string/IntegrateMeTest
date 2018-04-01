require "rails_helper"

describe Competition do
  fixtures :competitions

  context 'validations' do
    it "should require a name" do
      expect { Competition.create!(name: nil) }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  context 'MailChimp' do
    describe '#list_id' do
      subject { competition.list_id }

      context 'when does not have API key' do
        let(:competition) { competitions(:competition_keyless) }
        it 'raises an execption' do
          expect { subject }.to raise_error(ArgumentError, 'MailChimp API key is not defined')
        end
      end

      context 'when associated list does not exit yet' do
        let(:competition) { competitions(:competition_inexistent) }
        it 'raises an execption' do
          expect { subject }.to raise_error(NameError, "A list named `#{competition.name}` doesn't exist on MailChimp side yet")
        end
      end

      context 'when associated list exists' do
        let(:competition) { competitions(:competition) }

        it 'updates competition list id' do
          expect { subject }.to change { competition.mailchimp_list_id }.from(nil).to('6a59ad935f')
        end
        it 'returns list id' do
          expect(subject).to eq '6a59ad935f'
        end
      end
    end

    describe '#get_list' do
      let(:competition) { competitions(:competition) }

      it 'returns list attributes' do
        expect(competition.get_list(:name)).to eq competition.name
      end
    end
  end
end
