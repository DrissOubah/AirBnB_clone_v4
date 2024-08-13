#!/bin/bash

# Navigate to the project directory

# Task 4: Replace the route 2-hbnb with 3-hbnb and create the corresponding files
# -----------------------------------------------------------------------------
# Copy and rename 2-hbnb.py to 3-hbnb.py
cp web_dynamic/2-hbnb.py web_dynamic/3-hbnb.py

# Replace the route /2-hbnb/ with /3-hbnb/ in 3-hbnb.py
sed -i "s|/2-hbnb/|/3-hbnb/|g" web_dynamic/3-hbnb.py

# Copy and rename 2-hbnb.html to 3-hbnb.html
cp web_dynamic/templates/2-hbnb.html web_dynamic/templates/3-hbnb.html

# Update 3-hbnb.html: Import the 3-hbnb.js script instead of 2-hbnb.js
sed -i "s|static/scripts/2-hbnb.js|static/scripts/3-hbnb.js|g" web_dynamic/templates/3-hbnb.html

# Remove the entire Jinja section displaying all places (all article tags)
sed -i '/{% for place in places %}/,/{% endfor %}/d' web_dynamic/templates/3-hbnb.html

# Create the 3-hbnb.js script
cat <<'EOF' > web_dynamic/static/scripts/3-hbnb.js
$(document).ready(function() {
    let selectedAmenities = {};

    // Check the API status
    $.get('http://0.0.0.0:5001/api/v1/status/', function(data) {
        if (data.status === 'OK') {
            $('#api_status').addClass('available');
        } else {
            $('#api_status').removeClass('available');
        }
    });

    // Handle amenity selection
    $('input[type="checkbox"]').change(function() {
        if ($(this).is(':checked')) {
            selectedAmenities[$(this).data('id')] = $(this).data('name');
        } else {
            delete selectedAmenities[$(this).data('id')];
        }

        let amenityNames = Object.values(selectedAmenities).join(', ');
        if (amenityNames.length > 0) {
            $('.amenities h4').text(amenityNames);
        } else {
            $('.amenities h4').html('&nbsp;');
        }
    });

    // Load places from the API
    $.ajax({
        url: 'http://0.0.0.0:5001/api/v1/places_search/',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify({}),
        success: function(data) {
            for (let place of data) {
                $('.places').append(
                    `<article>
                        <div class="title_box">
                            <h2>${place.name}</h2>
                            <div class="price_by_night">${place.price_by_night}</div>
                        </div>
                        <div class="information">
                            <div class="max_guest">${place.max_guest} Guests</div>
                            <div class="number_rooms">${place.number_rooms} Bedrooms</div>
                            <div class="number_bathrooms">${place.number_bathrooms} Bathrooms</div>
                        </div>
                        <div class="description">
                            ${place.description}
                        </div>
                    </article>`
                );
            }
        }
    });
});
EOF

# Task 5: Replace the route 3-hbnb with 4-hbnb and create the corresponding files
# -----------------------------------------------------------------------------
# Copy and rename 3-hbnb.py to 4-hbnb.py
cp web_dynamic/3-hbnb.py web_dynamic/4-hbnb.py

# Replace the route /3-hbnb/ with /4-hbnb/ in 4-hbnb.py
sed -i "s|/3-hbnb/|/4-hbnb/|g" web_dynamic/4-hbnb.py

# Copy and rename 3-hbnb.html to 4-hbnb.html
cp web_dynamic/templates/3-hbnb.html web_dynamic/templates/4-hbnb.html

# Update 4-hbnb.html: Import the 4-hbnb.js script instead of 3-hbnb.js
sed -i "s|static/scripts/3-hbnb.js|static/scripts/4-hbnb.js|g" web_dynamic/templates/4-hbnb.html

# Create the 4-hbnb.js script
cat <<'EOF' > web_dynamic/static/scripts/4-hbnb.js
$(document).ready(function() {
    let selectedAmenities = {};

    // Check the API status
    $.get('http://0.0.0.0:5001/api/v1/status/', function(data) {
        if (data.status === 'OK') {
            $('#api_status').addClass('available');
        } else {
            $('#api_status').removeClass('available');
        }
    });

    // Handle amenity selection
    $('input[type="checkbox"]').change(function() {
        if ($(this).is(':checked')) {
            selectedAmenities[$(this).data('id')] = $(this).data('name');
        } else {
            delete selectedAmenities[$(this).data('id')];
        }

        let amenityNames = Object.values(selectedAmenities).join(', ');
        if (amenityNames.length > 0) {
            $('.amenities h4').text(amenityNames);
        } else {
            $('.amenities h4').html('&nbsp;');
        }
    });

    // Load places based on selected amenities
    $('button').click(function() {
        $.ajax({
            url: 'http://0.0.0.0:5001/api/v1/places_search/',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify({ amenities: Object.keys(selectedAmenities) }),
            success: function(data) {
                $('.places').empty();
                for (let place of data) {
                    $('.places').append(
                        `<article>
                            <div class="title_box">
                                <h2>${place.name}</h2>
                                <div class="price_by_night">${place.price_by_night}</div>
                            </div>
                            <div class="information">
                                <div class="max_guest">${place.max_guest} Guests</div>
                                <div class="number_rooms">${place.number_rooms} Bedrooms</div>
                                <div class="number_bathrooms">${place.number_bathrooms} Bathrooms</div>
                            </div>
                            <div class="description">
                                ${place.description}
                            </div>
                        </article>`
                    );
                }
            }
        });
    });
});
EOF

# Print success message
echo "Setup for 3-hbnb and 4-hbnb complete."
echo "You can now run the Flask apps using the following commands:"
echo "HBNB_MYSQL_USER=hbnb_dev HBNB_MYSQL_PWD=hbnb_dev_pwd HBNB_MYSQL_HOST=localhost HBNB_MYSQL_DB=hbnb_dev_db HBNB_TYPE_STORAGE=db python3 -m web_dynamic.3-hbnb"
echo "HBNB_MYSQL_USER=hbnb_dev HBNB_MYSQL_PWD=hbnb_dev_pwd HBNB_MYSQL_HOST=localhost HBNB_MYSQL_DB=hbnb_dev_db HBNB_TYPE_STORAGE=db python3 -m web_dynamic.4-hbnb"

