import * as wasm from "./bootstrap.js";

//	  import * as wasm from "wasm-game-of-life";
	  function run_zerosum(){
		document.getElementById('out').value = '';
		wasm.main(document.getElementById('in').value);
	  }
//wasm.greet();
//wasm.main("-1	Apples\n-2	Bananas\n-3	Carrots\n3	Dave\n-4	Eggs\n4	Fred\n5 Greg\n");
document.getElementById('out').value = '';

//area=document.getElementById('in');//.onChange="run_zerosum();";
if (document.getElementById('in').addEventListener) {
  document.getElementById('in').addEventListener('input', function() { run_zerosum()
    // event handling code for sane browsers
  }, false);
} else if (document.getElementById('in').attachEvent) {
  document.getElementById('in').attachEvent('onpropertychange', function() { run_zerosum()
    // IE-specific event handling code
  });
}

wasm.main("-1.00	Apples\n-2.00	Bananas\n-3.00	Carrots\n3.00 Dave\n");
wasm.main(document.getElementById('in').value);
//wasm.main("-4.00	Eggs\n4.00	Fred\n5.0 Greg\n");

