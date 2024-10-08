#!/bin/bash


# Task 7: Replace the route 100-hbnb with 101-hbnb and create the corresponding files
# -----------------------------------------------------------------------------
# Copy and rename 100-hbnb.py to 101-hbnb.py
cp web_dynamic/100-hbnb.py web_dynamic/101-hbnb.py

# Replace the route /100-hbnb/ with /101-hbnb/ in 101-hbnb.py
sed -i "s|/100-hbnb/|/101-hbnb/|g" web_dynamic/101-hbnb.py

# Copy and rename 100-hbnb.html to 101-hbnb.html
cp web_dynamic/templates/100-hbnb.html web_dynamic/templates/101-hbnb.html

# Update 101-hbnb.html: Import the 101-hbnb.js script instead of 100-hbnb.js
sed -i "s|static/scripts/100-hbnb.js|static/scripts/101-hbnb.js|g" web_dynamic/templates/101-hbnb.html

# Add span element to the right of the Reviews H2 with value "show"
sed -i '/<h2>Reviews<\/h2>/a <span class="toggle_reviews" style="float:right; cursor:pointer;">show</span>' web_dynamic/templates/101-hbnb.html

# Create the 101-hbnb.js script
cat <<'EOF' > web_dynamic/static/scripts/101-hbnb.js
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

    // Toggle reviews section
    $('.toggle_reviews').click(function() {
        const $reviewsSection = $('.reviews');
        if ($reviewsSection.is(':visible')) {
            $reviewsSection.empty();
            $(this).text('show');
        } else {
            $.get('http://0.0.0.0:5001/api/v1/reviews/', function(data) {
                $reviewsSection.empty();
                for (let review of data) {
                    $reviewsSection.append(
                        `<div class="review">
                            <h3>${review.name}</h3>
                            <p>${review.text}</p>
                        </div>`
                    );
                }
                $('.toggle_reviews').text('hide');
            });
        }
        $reviewsSection.toggle();
    });
});
EOF

echo "Tasks 6 and 7 have been completed successfully."

