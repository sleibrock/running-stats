// some javascript stuff or whatever

var $ = function(eid) {
    return document.getElementById(eid);
};

var showHide = function(eid) {
    var obj = $(eid);
    if(obj.style.display === "block") {
	obj.style.display = "none";
    } else {
	obj.style.display = "block";
    }
};

// end
