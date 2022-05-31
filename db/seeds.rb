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
    Doctor.create(
        name: Faker::Name.unique.name
    )
end

@doctors = Doctor.all
for doctor in @doctors
    10.times do
        Patient.create(
            doctor_id: doctor.id,
            name: Faker::Name.unique.name
        )
    end
end

@patients = Patient.all
for patient in @patients
    #Future
    5.times do 
        Appointment.create(
            patient_id: patient.id,
            doctor_id: patient.doctor_id,
            duration_in_minutes: 50,
            start_time: Date.today + rand(100000)
        )
    end
    #Past
    5.times do 
        Appointment.create(
            patient_id: patient.id,
            doctor_id: patient.doctor_id,
            duration_in_minutes: 50,
            start_time: Date.today - rand(100000)
        )
    end
end
