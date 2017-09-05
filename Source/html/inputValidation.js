var regEx;
var OK = null;

function generalValidate(textInput) {
	regEx = /[" ' < >]*$/gi;
	OK = regEx.exec(textInput.value);
	
	if (!OK) {
		window.alert(textInput.value + ' is not valid');
		textInput.value = "";
	}
}

function validateText(textInput){
	regEx = /^[a-z 0-9.,]*$/gi;
	OK = regEx.exec(textInput.value);
	
	if (!OK) { 
		window.alert(textInput.value + ' is not a valid name'); 
		textInput.value = "";
	}
}

function validatePhone(textInput) {	
	regEx = /^\d{10}$/gi;
	OK = regEx.exec(textInput.value);
	
	if (!OK) {
		window.alert(textInput.value + ' is not a valid phone number');
		textInput.value = "";
	}
}	

function validatePassword(textInput) {
	regEx = /^\d{6}$/gi;
	OK = regEx.exec(textInput.value);
	
	if (!OK) {
		window.alert('Please choose a longer password');
		textInput.value = "";
	}
}