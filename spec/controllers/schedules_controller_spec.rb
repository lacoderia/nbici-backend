feature 'SchedulesController' do
      
  let!(:starting_datetime) { Time.zone.parse('01 Jan 2016 00:00:00') }  
  
  let!(:schedule_current_week_01) { create(:schedule, datetime: starting_datetime ) }
  let!(:schedule_current_week_02) { create(:schedule, datetime: starting_datetime + 7.days + 23.hours + 59.minutes) }
  let!(:schedule_past_week) { create(:schedule, datetime: starting_datetime - 1.day) }
  let!(:schedule_next_week) { create(:schedule, datetime: starting_datetime + 8.days) }

  context 'Get weekly schedules' do

    before do
        Timecop.freeze(starting_datetime)
    end

    it 'should get the current week schedules' do

        visit weekly_scope_schedules_path
        response = JSON.parse(page.body)
        expect(response['schedules'].count).to eql 2
        expect(response['schedules'][0]['id']).to eql schedule_current_week_01.id
        expect(response['schedules'][1]['id']).to eql schedule_current_week_02.id
        expect(Schedule.count).to eql 4

        # Entrando la siguiente semana 
        one_week_after = starting_datetime + 8.days
        Timecop.travel(one_week_after)

        visit weekly_scope_schedules_path
        response = JSON.parse(page.body)
        expect(response['schedules'].count).to eql 1
        expect(response['schedules'][0]['id']).to eql schedule_next_week.id

    end

  end

end
