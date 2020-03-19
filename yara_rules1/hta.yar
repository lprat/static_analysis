rule hta_file {
	meta:
		description = "HTA file"
		author = "Lionel PRAT"
        version = "0.1"
		weight = 1
	    check_level2 = "check_command_bool"
	strings:
	    $hta0 = "<hta:application" nocase	    
	condition:
	    all of ($hta*) or PathFile matches /.*\.hta$/i or CDBNAME matches /.*\.hta$/i
}

rule hta_script {
	meta:
		description = "HTA file with script"
		author = "Lionel PRAT"
        version = "0.1"
		weight = 4
	    check_level2 = "check_command_bool,check_clsid_bool"
	    tag = "attack.execution,attack.T1170"
	strings:
	    $hta0 = "<hta:application" nocase	
	    $hta1 = "<script" nocase
	condition:
	    all of ($hta*) or PathFile matches /.*\.hta$/i or CDBNAME matches /.*\.hta$/i
}

rule hta_scriptA {
	meta:
		description = "HTA file with script use ActiveX"
		author = "Lionel PRAT"
        version = "0.1"
		weight = 6
	    check_level2 = "check_command_bool,check_clsid_bool"
	    tag = "attack.execution,attack.T1170"
	strings:
	    $hta0 = "<hta:application" nocase	
	    $hta1 = "<script" nocase
	    $hta2 = "ActiveXObject" nocase
	condition:
	    all of ($hta*) or PathFile matches /.*\.hta$/i or CDBNAME matches /.*\.hta$/i
}

rule hta_mini {
	meta:
		description = "HTA file minimize windows"
		author = "Lionel PRAT"
        version = "0.1"
		weight = 4
	    check_level2 = "check_command_bool"
	    tag = "attack.execution,attack.T1170"
	strings:
	    $hta0 = "<hta:application" nocase	
	    $hta1 = /windowstate\s*=(\s*|\")+minimize/ nocase
	condition:
	    all of ($hta*) or PathFile matches /.*\.hta$/i or CDBNAME matches /.*\.hta$/i
}

