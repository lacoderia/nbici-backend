ActiveAdmin.register_page "Pagos_a_instructores" do

  menu priority: 1, label: "Pagos a instructores"

  content title: "Pagos a instructores" do
  
    grouped_schedules = Schedule.for_instructor_payments

    panel "Clases" do
      grouped_schedules.each do |date, schedules|
        table "#{date}" do
          thead do
            tr do
              %w[Instructor Reservas].each &method(:th)
            end
          end
          tbody do
            schedules.each do |schedule|
              td do
                "#{schedule.instructor.first_name}"
              end
              td do
                "#{schedule["app_num"]}"
              end
            end
          end
        end
      end
    end
    
  end

    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       ul do
    #         Post.recent(5).map do |post|
    #           li link_to(post.title, admin_post_path(post))
    #         end
    #       end
    #     end
    #   end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
end
