# Device Readings API

Welcome to the Device Readings API! This Ruby on Rails API server provides a way
to track counts at arbitrary intervals from devices in the field.

---

## Getting Started

### Prerequisites

Before getting started, make sure that:

- You have Ruby (version 3.2.2) installed
- You have a recent version of Bundler installed (e.g. `gem install bundler`)
- You have a recent version of Git installed (e.g. `brew install git` on Mac)

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/kylebowen/device-readings-api.git
   ```

2. Navigate to the project directory:

   ```bash
   cd device-readings-api
   ```

3. Install dependencies:

   ```bash
   bundle install
   ```

4. Run the specs:

   ```bash
   bin/rails spec
   ```

5. Start the Rails server:

   ```bash
   bin/rails server
   ```

   The application will be available at [http://localhost:3000](http://localhost:3000).

## API Usage

### Add Readings for a Device

   Format:

   ```
   POST /readings
   ```

   Required Parameters:

   - id - a string representing the UUID for the device
   - readings - an array of readings for the device
     - count - an integer representing the reading data
     - timestamp - an ISO-8601 timestamp for when the reading was taken

   Example request using curl:

   ```bash
   curl -X POST localhost:3000/readings
        -H 'Content-Type: application/json'
        -d '{"id":"36d5658a-6908-479e-887e-a949ec199272","readings":[{"timestamp":"2021-09-29T16:08:15+01:00","count":2},{"timestamp":"2021-09-29T16:09:15+01:00","count":15}]}'
   ```

### Return the Timestamp of the Latest Reading for a Device

   Format:

   ```
   GET /devices/{device_uuid}/latest_timestamp
   ```

   Required Parameters:

   - device_uuid - a string representing the UUID for the device

   Example request using curl:

   ```bash
   curl localhost:3000/devices/36d5658a-6908-479e-887e-a949ec19927/latest_timestamp
   ```

   Response:

   ```json
   {
     "latest_timestamp": "2021-09-29T16:09:15+01:00"
   }
   ```

### Return the Cumulative Count Across All Readings for a Device

   Format:

   ```
   GET /devices/{device_uuid}/cumulative_count`
   ```
   Required Parameters:

   - device_uuid - a string representing the UUID for the device

   Example request using curl:

   ```bash
   curl localhost:3000/devices/36d5658a-6908-479e-887e-a949ec19927/cumulative_count
   ```

   Response:

   ```json
   {
     "cumulative_count": 17
   }
   ```

## Project Structure

The project is structured as a Ruby on Rails API app, with a few exceptions.

- Testing is done with RSpec, featuring mostly request specs to verify proper
  behavior for consumers.
- Since the data is all stored in-memory, ActiveRecord is not included.
- The main data storage is handled by the `Datastore` model, an instance of
  which is initialized in `config/initializers/global_datastore.rb` and set as
  the global variable `$datastore`.
- Since the datastore is an in-memory global, the `Datastore` class implements a
  mutex around `get` & `set` operations to preserve data integrity between
  Puma threads. I used some AI assistance to quickly add some sanity tests
  verifying the mutex was working.
- The instructions said that readings can be sent out of order. They did not say
  that storing the readings in order was required, so the device keeps track of
  the latest timestamp as each reading is added but doesn't make any effort to
  sort the list of readings.
- Likewise, we need to be able to return the cumulative count for a device, but
  that can be easily cached on the device as readings are added to avoid having
  to calculate it iteritively on GET requests.
- The instructions said to ignore duplicate readings for a given timestamp, so
  the timestamp for a reading is checked against a list of existing timestamps
  for inclusion before adding it to the device. I could have just checked the
  reading for inclusion in the list of readings, but the instructions did not
  touch on the desired handling for the possible case of a reading with a
  duplicate timestamp and a unique value for count.

## Further Improvements or Optimizations

Given more time, these are some of the additional items I would include:

- Additional unit testing for the models.
- Better error handling for malformed reading json. The app currently will save
  any valid readings for a device, but does not give any indication of whether
  there were errors or duplicates. I would like to update the response on the
  POST request to return data about what was successfully "saved" and what
  errors (if any) we know of for readings that may have had them.
- Dropping the mutex around the datastore and implementing an async queue system
  may be able to improve performance without sacrificing data integrity, but
  would definitely take some additional time to verify and get put in place.

## Contributing

If you'd like to contribute to the project, please follow these steps:

1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Make your changes and submit a pull request.

## License

This project is licensed under the [MIT License](LICENSE).
