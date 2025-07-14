#!/bin/bash

# Ensure domain argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <target-domain>"
  exit 1
fi

domain="$1"
output_dir="kerberos-recon-$domain"
mkdir -p "$output_dir"
cd "$output_dir" || exit

echo "[*] Starting subdomain + Kerberos recon for: $domain"
echo

# === Subdomain Enumeration ===
echo "[*] Running Subfinder..."
subfinder -d "$domain" -silent > subfinder.txt

echo "[*] Running Assetfinder..."
assetfinder --subs-only "$domain" > assetfinder.txt

# Combine and deduplicate
cat subfinder.txt assetfinder.txt | sort -u > all-subs.txt
echo "[+] Total unique subdomains found: $(wc -l < all-subs.txt)"
echo

# === DNS Resolution ===
echo "[*] Resolving subdomains using dnsx..."
dnsx -silent -a -l all-subs.txt | tee resolved_raw.txt > /dev/null

# Format: domain ip
awk '{if (NF==2) print $1, $2}' resolved_raw.txt > resolved.txt
echo "[+] Resolved $(wc -l < resolved.txt) subdomains to IPs"
echo

# === Scan for Kerberos Ports ===
touch kerberos_targets.txt

echo "[*] Scanning IPs for Kerberos/LDAP/SMB ports..."

while read -r line; do
  subdomain=$(echo "$line" | awk '{print $1}')
  ip=$(echo "$line" | awk '{print $2}')

  # Skip empty IPs
  if [ -z "$ip" ]; then
    echo "[!] Skipping $subdomain — no IP resolved."
    continue
  fi

  echo "[*] Scanning $subdomain ($ip)..."
  nmap_output=$(nmap -p88,135,139,445,389,636 --open -Pn "$ip" | grep "/open")

  if [ -n "$nmap_output" ]; then
    echo "$subdomain ($ip):" >> kerberos_targets.txt
    echo "$nmap_output" >> kerberos_targets.txt
    echo "---" >> kerberos_targets.txt
    echo "[✓] Found open ports on $subdomain"
  fi
done < resolved.txt

echo
echo "[✓] Done! Valid Kerberos-related services saved to: $output_dir/kerberos_targets.txt"
