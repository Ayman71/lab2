Simple Antivirus Project

1. Overview
    This project implements a simple antivirus that scans a specific directory for malicious files and quarantine them and also allows restoring files from user input. The antivirus also implements a whitelist function for the restored files which makes them safe from getting quarantined in the next scan.

2. Features
    Directory monitoring: On-demand check for malicious files inside a specific directory
    Malicious extension detection: Detects files with a malicious extensions inside a certain directory
    Malicious keyword detection: Detects files that contain malicious keywords inside the contents of the file
    Quarantine: Copies the malicious file to specified directory and removes it from the original directory 
    File restoration: Allows the user to restore quarantined files back to the original directory, permanently delete them, or leave them as-is
    Whitelist mechanism: Records restored files to not be flagged again in the next scan
        
3. Project structure
    antivirus.sh: Monitors the original directory and contains the predefined malicious extensions and keywords
    restore.sh: Displays the quarantined files and gives the options to restore, permanently delete, or leave
    whitelist.txt: Stores the filenames for whitelisted files that has been marked as safe
    directory_info.last: Stores the previous directory snapshot
    directory_info.new: Stores the current snapshot during monitoring and scanning
    
4. Usage
    Run antivirus.sh: make antivirus DIR MALICIOUS_DIR INTERVAL
    
    DIR: Directory to monitor
    MALICIOUS_DIR: Directory to quarantine malicious files
    INTERVAL: Number of seconds between each scan
    
    Run restore.sh: make restore DIR MALICIOUS_DIR
    DIR: Directory to restore the quarantined files
    MALICIOUS_DIR: Directory to take action on malicious files
    
    Clean snapshots: make clean
    this removes the generated directory snapshot files, it does not clean the whitelist
    
    
