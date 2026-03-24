import subprocess
import platform
import re

def get_arp_table():
    os_name = platform.system().lower()
    try:
        if os_name == "windows":
            result = subprocess.run(["arp", "-a"], capture_output=True, text=True)
        else:
            result = subprocess.run(["arp", "-n"], capture_output=True, text=True)
        return result.stdout
    except Exception as e:
        print(f"Error retrieving ARP table: {e}")
        return ""

def parse_arp_table(raw_output):
    entries = []
    os_name = platform.system().lower()
    if os_name == "windows":
        pattern = r"(\d+\.\d+\.\d+\.\d+)\s+([\w-]{17})\s+(\w+)"
    else:
        pattern = r"(\d+\.\d+\.\d+\.\d+)\s+\S+\s+([\w:]{17})"
    for line in raw_output.splitlines():
        match = re.search(pattern, line)
        if match:
            ip = match.group(1)
            mac = match.group(2)
            entries.append((ip, mac))
    return entries

def display_table(entries):
    print(f"\n{'IP Address':<20} {'MAC Address':<20}")
    print("-" * 42)
    for ip, mac in entries:
        print(f"{ip:<20} {mac:<20}")
    print("-" * 42)
    print(f"Total entries: {len(entries)}")

def save_to_file(entries, filename="arp_results.txt"):
    with open(filename, "w") as f:
        f.write(f"{'IP Address':<20} {'MAC Address':<20}\n")
        f.write("-" * 42 + "\n")
        for ip, mac in entries:
            f.write(f"{ip:<20} {mac:<20}\n")
        f.write(f"\nTotal entries: {len(entries)}\n")
    print(f"\nResults saved to {filename}")

def main():
    print("=== ARP Scanner ===")
    raw = get_arp_table()
    entries = parse_arp_table(raw)
    if not entries:
        print("No ARP entries found.")
        return
    display_table(entries)
    save = input("\nSave results to file? (y/n): ").strip().lower()
    if save == "y":
        save_to_file(entries)

if __name__ == "__main__":
    main()
