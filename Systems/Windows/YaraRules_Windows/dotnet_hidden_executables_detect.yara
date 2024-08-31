rule Dotnet_Hidden_Executables_Detect {
    meta:
        description = "This rule detects hidden PE file presence."
    strings:
        $pattern1 = "4D!5A!90" nocase wide ascii
        $pattern2 = "4D-5A-90O" nocase wide ascii
        $pattern3 = "4D5A9ZZZ" nocase wide ascii
        $pattern4 = "~~~9A5D4" nocase wide ascii
        $pattern5 = "09~A5~D4" nocase wide ascii
        $pattern6 = "09}A5}D4" nocase wide ascii
        $pattern7 = "WP09PA5PD4" nocase wide ascii
        $pattern8 = "X-09-A5-D4" nocase wide ascii
        $pattern9 = "ZZ-09-A5-D4" nocase wide ascii
        $hexpat1 = { 74 65 6D 61 }
        $hexpat2 = { 90 5A 4D }
        $hexpat3 = { 65 72 50 78 }
        $hexpat4 = { F8 AF CF C0 }
        $hexpat5 = { AB F4 DB BF }
    condition:
        ((any of ($pattern*)) or (all of ($hexpat*)))
}