DIR ?= ./test
MALICIOUS_DIR ?= ./quarantine
INTERVAL ?= 10

.PHONY: setup antivirus restore clean

setup:
	mkdir -p $(MALICIOUS_DIR)
antivirus: setup
	./antivirusd.sh $(DIR) $(MALICIOUS_DIR) $(INTERVAL)
restore: setup
	./restore.sh $(DIR) $(MALICIOUS_DIR)
clean:
	rm -f directory_info.last directory_info.new


