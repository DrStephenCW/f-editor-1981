
package fstacks is
    --. F editor - file input and output routines 
	procedure intobuf(ch: in character);

	function readfile return boolean;

	function writefile return boolean;

end fstacks;
