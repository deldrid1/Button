// Copyright (c) 2013 Electric Imp
// This file is licensed under the MIT License
// http://opensource.org/licenses/MIT
//
// Description: Debounced button press with callbacks
 
class Button
{
    static NORMALLY_HIGH = 1;
    static NORMALLY_LOW  = 0;
    _pin             = null;
    _pull            = null;
    _polarity        = null;
    _pressCallback   = null;
    _releaseCallback = null;

    constructor(pin, pull, polarity, pressCallback, releaseCallback){
        _pin             = pin;               //Unconfigured IO pin, eg hardware.pin2
        _pull            = pull;              //DIGITAL_IN_PULLDOWN, DIGITAL_IN or DIGITAL_IN_PULLUP
        _polarity        = polarity;          //Normal button state, ie 1 if button is pulled up and the button shorts to GND
        _pressCallback   = pressCallback;     //Function to call on a button press (may be null)
        _releaseCallback = releaseCallback;   //Function to call on a button release (may be null)

        _pin.configure(_pull, debounce.bindenv(this));
    }

    // *** Private functions ***
    
    function _debounce(){
        _pin.configure(_pull);
        imp.wakeup(0.010, _getState.bindenv(this));  //Based on googling, bounce times are usually limited to 10ms
    }

    function _getState(){ 
        if( _polarity == _pin.read() ){
            if(_releaseCallback != null){
                _releaseCallback();
            }
        }else{
            if(_pressCallback != null){
                _pressCallback();
            }
        }
        _pin.configure(_pull, _debounce.bindenv(this)); 
    }
}
