feature 'InstructorsController' do
      
  let!(:instructor_01) { create(:instructor, quote: "YES EN INGLES") }
  let!(:instructor_02) { create(:instructor, quote: "OUI EN FRANCES") }

  context 'Get all instructors' do

    it 'should get all the instructors' do
        visit instructors_path
        response = JSON.parse(page.body)
        expect(response["instructors"].count).to eql 2
        expect(response["instructors"][0]["quote"]).to eql "YES EN INGLES"
        expect(response["instructors"][1]["quote"]).to eql "OUI EN FRANCES"
    end
  end

end
