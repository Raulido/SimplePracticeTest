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
