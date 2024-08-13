#!/bin/bash

# Navigate to the project directory

# Task 6: Replace the route 4-hbnb with 100-hbnb and create the corresponding files
# -----------------------------------------------------------------------------
# Copy and rename 4-hbnb.py to 100-hbnb.py
cp web_dynamic/4-hbnb.py web_dynamic/100-hbnb.py

# Replace the route /4-hbnb/ with /100-hbnb/ in 100-hbnb.py
sed -i "s|/4-hbnb/|/100-hbnb/|g" web_dynamic/100-hbnb.py

# Copy and rename 4-hbnb.html to 100-hbnb.html
cp web_dynamic/templates/4-hbnb.html web_dynamic/templates/100-hbnb.html

# Update 100-hbnb.html: Import the 100-hbnb.js script instead of 4-hbnb.js
sed -i "s|static/scripts/4-hbnb.js|static/scripts/100-hbnb.js|g" web_dynamic/templates/100-hbnb.html

# Add input checkboxes to State and City <li> tags with appropriate data attributes
sed -i '/<li data-id="{{ state.id }}" data-name="{{ state.name }}">/a <input type="checkbox" data-id="{{ state.id }}" data-name="{{ state.name }}" style="margin-left: 10px;">' web_dynamic/templates/100-hbnb.html
sed -i '/<li data-id="{{ city.id }}" data-name="{{ city.name }}">/a <input type="checkbox" data-id="{{ city.id }}" data-name="{{ city.name }}" style="margin-left: 10px;">' web_dynamic/templates/100-hbnb.html

# Create the 100-hbnb.js script
cat <<'EOF' > web_dynamic/static/scripts/100-hbnb.js
$(document).ready(function() {
    let selectedAmenities = {};
    let selectedStates = {};
    let selectedCities = {};

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
        const id = $(this).data('id');
        const name = $(this).data('name');
        if ($(this).is(':checked')) {
            if ($(this).parent().parent().hasClass('amenities')) {
                selectedAmenities[id] = name;
            } else if ($(this).parent().parent().hasClass('states')) {
                selectedStates[id] = name;
            } else if ($(this).parent().parent().hasClass('cities')) {
                selectedCities[id] = name;
            }
        } else {
            if ($(this).parent().parent().hasClass('amenities')) {
                delete selectedAmenities[id];
            } else if ($(this).parent().parent().hasClass('states')) {
                delete selectedStates[id];
            } else if ($(this).parent().parent().hasClass('cities')) {
                delete selectedCities[id];
            }
        }

        let locations = Object.values(selectedStates).concat(Object.values(selectedCities)).join(', ');
        if (locations.length > 0) {
            $('.locations h4').text(locations);
        } else {
            $('.locations h4').html('&nbsp;');
        }

        let amenityNames = Object.values(selectedAmenities).join(', ');
        if (amenityNames.length > 0) {
            $('.amenities h4').text(amenityNames);
        } else {
            $('.amenities h4').html('&nbsp;');
        }
    });

    // Load places based on selected amenities, states, and cities
    $('button').click(function() {
        $.ajax({
            url: 'http://0.0.0.0:5001/api/v1/places_search/',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify({ amenities: Object.keys(selectedAmenities), states: Object.keys(selectedStates), cities: Object.keys(selectedCities) }),
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
