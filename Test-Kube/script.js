document.getElementById('login-form').addEventListener('submit', function(e) {
    e.preventDefault(); // Prevent default form submission behavior
    var username = document.getElementById('username').value;
    var password = document.getElementById('password').value;
    
    // Example: Logging the input values to the console
    console.log('Username: ' + username);
    console.log('Password: ' + password);
    
    // Here you would typically send an AJAX request to your server
    // to authenticate the user.
});
