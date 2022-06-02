My Implemmentation for SimplePractice Programming Test
=======================

This is my solution to SimplePractice's Programming Test. The test has
5 requirments that need to be implemmented in a basic Rails API scaffold.
To test each requirment I used Postman to send GET/POST request to each endpoint. 
Although not required, I also included some test cases in
the spec folder to test each requirment.

### My Approach for Requirement 1:

The first requirment was to seed data into the database. I did so by using
nested for loops. The outer for loop creates 10 doctors, middle for loop 
creates 10 patients per doctor and the two inner for loops create 10 appointments
per patient (5 appointments in the future and 5 appointments in the past). 

I use the gem faker to create some random unique patient and doctor names. 
I also used rand() to create random dates for the appointments.

It is worth mentioning that appointments can overlap with the way I seed the data.
For example, a doctor can have an appointment that starts at 5:30PM with a duration of
50 minutes and also have another appointment that same day at 5:50PM. 
Maybe in the future I could add a validation to the appointmesnt model and a
overlapping scope "that reads overlapping appointments for an appointment". This isn't
mentioned in the requirments so I'll leave it as is.

credit to: (https://stackoverflow.com/questions/27834133/custom-validator-to-prevent-overlapping-appointments-in-rails-4-app)


### My Approach for Requirement 2:

The second requirment is to return all appointments from api/appointments endpoint,
but with a specific structure. To do this I just use a representer class that structures the
hash based on the spec requirements.

### My Approach for Requirement 3:

The third requirment is to allow filtering params for the api/appointments endpoint.

To handle past params I just check params[:past] and if past=1 I query for commands in the past
by comapring to Time.zone.now. Same thing with past=0 just flip the less than operator to greater than.
If :past params is not inluded I just retrieve all appointments.

For the pagination filters I just use the built in ruby on rails methods limit and offset.
@appointments.limit(params[:length]).offset(params[:page])


### My Approach for Requirement 4:

Fourth requirment is to return doctors with no appointments via api/doctors endpoint.
For this I just create a new controller for doctors and a new route.
Then I just query for all doctors whose id is not in Appointment table.
@doctors = Doctor.where.not(id: Appointment.all.map(&:doctor_id))


### My Approach for Requirement 5:

The last requirment is to make a POST method for api/appointments. For this I just implement the
create method in the appointments controller. Since params is different from appointment's structure,
this does require querying to find patient by name. 

It is worth mentioning that it is currently possible to create an appointment
between a patient and a different doctor that the patient doesn't belong to. This might require
adding a validation in the appointment model to make sure appointments are only between doctors that
patients belong to. However, it is not specified to do this in the requirments so I'll leave it as is.

### Conclusion

In conclusion, I had a lot of fun with this test. Usually, when I apply to a company they send me a leetcode test rather than a test that is more revelvant to the job. So, I appreciate it when companies go out of their way to create more relevant test. I'm still newish to Ruby on Rails so I am not to familiar with the common good code patterns and anti patterns, so hopefully my code isn't a complete eyesore. Thanks. 

------------------------------
SimplePractice Programming Test
=======================

The goal of the SimplePractice programming test is to evaluate the programming abilities
of candidates. The ideal candidate would know Ruby, JavaScript, or another language with
great proficiency, be familiar with basic database and HTTP API principles, and able to
write clean, maintainable code. This test gives candidates a chance to show these
abilities.

Getting Your Environment Ready
------------------------------

You'll need a development computer with access to github.com. You'll also need to set up
Docker CE (https://www.docker.com/community-edition), which is free. Sample `Dockerfile`
and `docker-compose.yml` files are included in this repo along with a basic scaffolded
Rails application.

There is a `Makefile` included for your convenience that has sample commands for building
and managing your application via the command line.

Please make sure you can bring up your app with `make up` well before the start of the
test. You should be able to run the tests if the basic setup works.

```bash
$ make
$ make build
$ make dbcreate
$ make test
```

If you need to use generators with docker:

```bash
docker-compose run app bundle exec rails scaffold users
```

Or, alternatively, you can "ssh" into the container (to exit, type `exit` or `ctrl + d`)

```bash
$ make bash
$ bundle exec rails g scaffold users
```

**NOTE** since the generator runs inside of Docker (and this container runs as
the `root` user), you will need to change the permissions of the generated
files. The following command is added as a convenience and should be run after
generated files are created to avoid "write permission" failures.

```bash
sudo chown -R $USER .
```

OR

```bash
make chown
```

Evaluation Criteria
-------------------

When evaluating the program, the following are among the factors considered:

 * Does it run?
 * Does it produce the correct output?
 * How did _you_ gain confidence your submission is correct?
 * Were appropriate algorithms and data structures chosen?
 * Was it well written? Are the source code and algorithms implemented cleanly?
   Would we enjoy your code living along side our own?
 * Is it slow? For small to medium sized inputs, the processing delay should
   probably not be noticeable.


Requirements
----------------------------

SimplePractice has decided to spin off part of our application into "SimplePractice Lite".
We're on a tight deadline and for MVP we need to build a single api endpoint that returns the
appointments between a doctor and a patient. The requirements are detailed below, if you
have any questions or need clarifications, please ask!

You have been given the basic data models: `Doctor`, `Patient`, and `Appointment`. For the
purpose of this exercise, you can assume that the `Patient` will only have one `Doctor`.

### Requirement 1: seed the database

Seed the database using `db/migrate/seeds.rb`
- There should be 10 Doctors with unique names
- Each doctor should have 10 patients with unique names
- Each patient should have 10 appointments (5 in the past, 5 in the future)

### Requirement 2: api/appointments endpoint

Return all appointments.

The spec for the endpoint requires the following structure:
```
[
  {
    id: <int>,
    patient: { name: <string> },
    doctor : { name: <string>, id: <int> },
    created_at: <iso8601>,
    start_time: <iso8601>,
    duration_in_minutes: <int>
  }, ...
]
```

### Requirement 3: allow the api/appointments endpoint to return filtered records

The following url params should filter the results:
- `?past=1` returns only appointments in the past
- `?past=0` returns only appointments in the future
- `?length=5&page=1` returns paginated appointments, starting at `page`; use page size of `length`

### Requirement 4: create a new endpoint api/doctors

Create a new endpoint that returns all doctors that do not have an appointment.

### Requirement 5: create new appointment POST to api/appointments

```
{
  patient: { name: <string> },
  doctor: { id: <int> },
  start_time: <iso8604>,
  duration_in_minutes: <int>
}
```
