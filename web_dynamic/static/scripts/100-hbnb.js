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
