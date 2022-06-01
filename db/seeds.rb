# TODO: Seed the database according to the following requirements:
# - There should be 10 Doctors with unique names
# - Each doctor should have 10 patients with unique names
# - Each patient should have 10 appointments (5 in the past, 5 in the future)
# - Each appointment should be 50 minutes in duration
require 'faker'

Doctor.destroy_all
Patient.destroy_all
Appointment.destroy_all

10.times do
    # Make 10 Doctors
    @doctor = Doctor.create(
        name: Faker::Name.unique.name
    )
    10.times do
        #Make 10 Patients per Doctor
        @patient = Patient.create(
            doctor_id: @doctor.id,
            name: Faker::Name.unique.name
        )
        5.times do 
            #Make 5 Future Appointments per Patient within 1000 days in the future
            Appointment.create(
                patient_id: @patient.id,
                doctor_id: @patient.doctor_id,
                duration_in_minutes: 50,
                start_time: Time.zone.now + rand( 60 * 60 * 24 * 1000)
            )
        end
        5.times do 
            #Make 5 Past Appointments per Patient within 1000 days in the past
            Appointment.create(
                patient_id: @patient.id,
                doctor_id: @patient.doctor_id,
                duration_in_minutes: 50,
                start_time: Time.zone.now - rand(60 * 60 * 24 * 1000)
            )
        end
    end
end

# doctors endpoint, no appointment
# Doctor.create(
#     name: Faker::Name.unique.name
# )