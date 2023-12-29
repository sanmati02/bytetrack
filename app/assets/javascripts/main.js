// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function() {
    $('#company_title').autocomplete({
        source: '/company_titles',
        minLength: 1,
        messages: {
            noResults: '',
            results: ''
        }
    });
});

$(document).ready(function() {
    $('#job_title').autocomplete({
        source: '/job_titles',
        minLength: 1,
        messages: {
            noResults: '',
            results: ''
        }
    });
});