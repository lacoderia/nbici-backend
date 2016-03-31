feature 'DistributionsController' do
      
  let!(:distribution) { create(:distribution, description: "controller test") }
  let!(:room) { create(:room, distribution: distribution) }

  context 'Get distribution by room id' do

    it 'should get the room distribution' do
        visit "#{by_room_id_distributions_path}?room_id=#{room.id}"
        response = JSON.parse(page.body)
        expect(response["distribution"]["description"]).to eql "controller test"
    end
  end

end
